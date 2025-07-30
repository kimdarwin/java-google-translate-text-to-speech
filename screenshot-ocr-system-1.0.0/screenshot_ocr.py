#!/usr/bin/env python3
"""
Desktop Screenshot and OCR System
Captures desktop screenshots periodically, performs OCR, and extracts text around mouse clicks.
"""

import os
import time
import threading
import json
from datetime import datetime
from pathlib import Path
import numpy as np
import cv2
import pytesseract
from PIL import Image, ImageGrab, ImageDraw
from pynput import mouse
from pynput.mouse import Listener
import logging

class ScreenshotOCR:
    def __init__(self, config_file="config.json"):
        """Initialize the Screenshot OCR system with configuration."""
        self.config = self.load_config(config_file)
        self.setup_logging()
        self.setup_directories()
        
        # State variables
        self.running = False
        self.last_screenshot = None
        self.last_ocr_result = ""
        self.click_positions = []
        self.screenshot_thread = None
        self.mouse_listener = None
        
        # Screenshot capture interval (seconds)
        self.capture_interval = self.config.get("capture_interval", 5)
        # Radius around cursor click to extract (pixels)
        self.extraction_radius = self.config.get("extraction_radius", 100)
        
        logging.info("ScreenshotOCR initialized")
    
    def load_config(self, config_file):
        """Load configuration from JSON file or create default."""
        default_config = {
            "capture_interval": 5,
            "extraction_radius": 100,
            "output_dir": "screenshots_output",
            "tesseract_config": "--psm 6",
            "image_format": "PNG",
            "save_full_screenshots": True,
            "save_extracted_regions": True,
            "save_ocr_text": True
        }
        
        if os.path.exists(config_file):
            try:
                with open(config_file, 'r') as f:
                    config = json.load(f)
                # Merge with defaults for missing keys
                for key, value in default_config.items():
                    if key not in config:
                        config[key] = value
                return config
            except Exception as e:
                print(f"Error loading config: {e}. Using defaults.")
                return default_config
        else:
            # Create default config file
            with open(config_file, 'w') as f:
                json.dump(default_config, f, indent=4)
            return default_config
    
    def setup_logging(self):
        """Setup logging configuration."""
        logging.basicConfig(
            level=logging.INFO,
            format='%(asctime)s - %(levelname)s - %(message)s',
            handlers=[
                logging.FileHandler('screenshot_ocr.log'),
                logging.StreamHandler()
            ]
        )
    
    def setup_directories(self):
        """Create necessary output directories."""
        self.output_dir = Path(self.config["output_dir"])
        self.screenshots_dir = self.output_dir / "screenshots"
        self.extracted_dir = self.output_dir / "extracted_regions"
        self.text_dir = self.output_dir / "ocr_text"
        
        for directory in [self.output_dir, self.screenshots_dir, self.extracted_dir, self.text_dir]:
            directory.mkdir(parents=True, exist_ok=True)
        
        logging.info(f"Output directories created in: {self.output_dir}")
    
    def capture_screenshot(self):
        """Capture a screenshot of the entire desktop."""
        try:
            screenshot = ImageGrab.grab()
            self.last_screenshot = screenshot
            
            if self.config["save_full_screenshots"]:
                timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
                filename = self.screenshots_dir / f"screenshot_{timestamp}.{self.config['image_format'].lower()}"
                screenshot.save(filename, self.config["image_format"])
                logging.info(f"Screenshot saved: {filename}")
            
            return screenshot
        except Exception as e:
            logging.error(f"Error capturing screenshot: {e}")
            return None
    
    def perform_ocr(self, image):
        """Perform OCR on the given image."""
        try:
            # Convert PIL image to numpy array for OpenCV
            cv_image = cv2.cvtColor(np.array(image), cv2.COLOR_RGB2BGR)
            
            # Preprocess image for better OCR results
            gray = cv2.cvtColor(cv_image, cv2.COLOR_BGR2GRAY)
            
            # Apply threshold to get image with only black and white
            _, thresh = cv2.threshold(gray, 0, 255, cv2.THRESH_BINARY + cv2.THRESH_OTSU)
            
            # Convert back to PIL Image
            processed_image = Image.fromarray(thresh)
            
            # Perform OCR
            text = pytesseract.image_to_string(processed_image, config=self.config["tesseract_config"])
            self.last_ocr_result = text.strip()
            
            return self.last_ocr_result
        except Exception as e:
            logging.error(f"Error performing OCR: {e}")
            return ""
    
    def extract_region_around_point(self, x, y, radius=None):
        """Extract a rectangular region around a given point."""
        if self.last_screenshot is None:
            logging.warning("No screenshot available for region extraction")
            return None, ""
        
        if radius is None:
            radius = self.extraction_radius
        
        # Get screenshot dimensions
        width, height = self.last_screenshot.size
        
        # Calculate extraction bounds
        left = max(0, x - radius)
        top = max(0, y - radius)
        right = min(width, x + radius)
        bottom = min(height, y + radius)
        
        # Extract region
        region = self.last_screenshot.crop((left, top, right, bottom))
        
        # Perform OCR on the extracted region
        text = self.perform_ocr(region)
        
        if self.config["save_extracted_regions"]:
            # Add a red circle to mark the click position
            marked_region = region.copy()
            draw = ImageDraw.Draw(marked_region)
            center_x = x - left
            center_y = y - top
            circle_radius = 5
            draw.ellipse(
                [center_x - circle_radius, center_y - circle_radius, 
                 center_x + circle_radius, center_y + circle_radius],
                outline='red', width=2
            )
            
            # Save the extracted region with timestamp and coordinates
            timestamp = datetime.now().strftime("%Y%m%d_%H%M%S_%f")[:-3]
            filename = self.extracted_dir / f"region_{timestamp}_x{x}_y{y}.{self.config['image_format'].lower()}"
            marked_region.save(filename, self.config["image_format"])
            logging.info(f"Extracted region saved: {filename}")
        
        if self.config["save_ocr_text"] and text:
            # Save OCR text
            timestamp = datetime.now().strftime("%Y%m%d_%H%M%S_%f")[:-3]
            text_filename = self.text_dir / f"text_{timestamp}_x{x}_y{y}.txt"
            with open(text_filename, 'w', encoding='utf-8') as f:
                f.write(f"Click Position: ({x}, {y})\n")
                f.write(f"Extraction Radius: {radius}\n")
                f.write(f"Timestamp: {datetime.now().isoformat()}\n")
                f.write(f"Region Bounds: ({left}, {top}, {right}, {bottom})\n")
                f.write("-" * 50 + "\n")
                f.write(text)
            logging.info(f"OCR text saved: {text_filename}")
        
        return region, text
    
    def on_click(self, x, y, button, pressed):
        """Handle mouse click events."""
        if pressed:  # Only process on button press, not release
            logging.info(f"Mouse clicked at ({x}, {y}) with {button}")
            
            # Store click position
            click_info = {
                'x': x,
                'y': y,
                'button': str(button),
                'timestamp': datetime.now().isoformat()
            }
            self.click_positions.append(click_info)
            
            # Extract region around click
            region, text = self.extract_region_around_point(x, y)
            
            if region and text:
                print(f"\n=== CLICK DETECTED ===")
                print(f"Position: ({x}, {y})")
                print(f"Extracted Text around cursor:")
                print("-" * 40)
                print(text)
                print("-" * 40)
            else:
                print(f"\n=== CLICK DETECTED ===")
                print(f"Position: ({x}, {y})")
                print("No text detected in the region")
    
    def screenshot_worker(self):
        """Worker thread for periodic screenshot capture."""
        while self.running:
            screenshot = self.capture_screenshot()
            if screenshot:
                # Perform OCR on full screenshot for background processing
                full_text = self.perform_ocr(screenshot)
                if full_text and self.config["save_ocr_text"]:
                    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
                    text_filename = self.text_dir / f"full_ocr_{timestamp}.txt"
                    with open(text_filename, 'w', encoding='utf-8') as f:
                        f.write(f"Full Screenshot OCR - {datetime.now().isoformat()}\n")
                        f.write("-" * 50 + "\n")
                        f.write(full_text)
            
            time.sleep(self.capture_interval)
    
    def start(self):
        """Start the screenshot and OCR system."""
        if self.running:
            logging.warning("System is already running")
            return
        
        self.running = True
        logging.info("Starting Screenshot OCR system...")
        
        # Start screenshot capture thread
        self.screenshot_thread = threading.Thread(target=self.screenshot_worker, daemon=True)
        self.screenshot_thread.start()
        
        # Start mouse listener
        self.mouse_listener = Listener(on_click=self.on_click)
        self.mouse_listener.start()
        
        print(f"Screenshot OCR system started!")
        print(f"- Taking screenshots every {self.capture_interval} seconds")
        print(f"- Extracting text around mouse clicks with radius {self.extraction_radius} pixels")
        print(f"- Output directory: {self.output_dir}")
        print("Press Ctrl+C to stop...")
        
        try:
            # Keep the main thread alive
            while self.running:
                time.sleep(1)
        except KeyboardInterrupt:
            self.stop()
    
    def stop(self):
        """Stop the screenshot and OCR system."""
        if not self.running:
            return
        
        logging.info("Stopping Screenshot OCR system...")
        self.running = False
        
        if self.mouse_listener:
            self.mouse_listener.stop()
        
        if self.screenshot_thread:
            self.screenshot_thread.join(timeout=5)
        
        # Save click positions summary
        if self.click_positions:
            summary_file = self.output_dir / "click_summary.json"
            with open(summary_file, 'w') as f:
                json.dump(self.click_positions, f, indent=2)
            logging.info(f"Click summary saved: {summary_file}")
        
        print("\nScreenshot OCR system stopped.")
        print(f"Total clicks recorded: {len(self.click_positions)}")
    
    def status(self):
        """Print current system status."""
        print(f"\n=== Screenshot OCR Status ===")
        print(f"Running: {self.running}")
        print(f"Capture Interval: {self.capture_interval} seconds")
        print(f"Extraction Radius: {self.extraction_radius} pixels")
        print(f"Output Directory: {self.output_dir}")
        print(f"Clicks Recorded: {len(self.click_positions)}")
        print(f"Last Screenshot: {'Available' if self.last_screenshot else 'None'}")
        if self.last_screenshot:
            print(f"Screenshot Size: {self.last_screenshot.size}")

def main():
    """Main function to run the Screenshot OCR system."""
    import sys
    
    if len(sys.argv) > 1 and sys.argv[1] == "--help":
        print("Screenshot OCR System")
        print("Usage: python screenshot_ocr.py [config_file]")
        print("\nFeatures:")
        print("- Periodic desktop screenshot capture")
        print("- OCR text extraction from full screenshots")
        print("- Mouse click detection")
        print("- Text extraction around cursor clicks")
        print("- Configurable extraction radius and capture interval")
        return
    
    config_file = sys.argv[1] if len(sys.argv) > 1 else "config.json"
    
    # Initialize and start the system
    ocr_system = ScreenshotOCR(config_file)
    
    try:
        ocr_system.start()
    except Exception as e:
        logging.error(f"Error running system: {e}")
        ocr_system.stop()

if __name__ == "__main__":
    main()