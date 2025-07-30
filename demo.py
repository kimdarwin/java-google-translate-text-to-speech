#!/usr/bin/env python3
"""
Demo script for Screenshot OCR System
This script demonstrates the core functionality without requiring a full desktop environment.
"""

import os
import sys
import time
from datetime import datetime
from PIL import Image, ImageDraw, ImageFont

# Add the current directory to path so we can import our module
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

try:
    from screenshot_ocr import ScreenshotOCR
except ImportError as e:
    print(f"Error importing ScreenshotOCR: {e}")
    print("Make sure all dependencies are installed.")
    sys.exit(1)

def create_test_image():
    """Create a test image with text for OCR demonstration."""
    # Create a test image
    width, height = 800, 600
    image = Image.new('RGB', (width, height), color='white')
    draw = ImageDraw.Draw(image)
    
    # Try to use a larger font, fall back to default if not available
    try:
        font = ImageFont.truetype("/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf", 24)
    except:
        font = ImageFont.load_default()
    
    # Add some text to the image
    text_lines = [
        "Screenshot OCR Demo",
        "This is a test image for OCR",
        "Created at: " + datetime.now().strftime("%Y-%m-%d %H:%M:%S"),
        "",
        "Features demonstrated:",
        "• Text extraction from images",
        "• OCR processing with Tesseract",
        "• Image preprocessing",
        "• Region extraction simulation",
        "",
        "Click coordinates would be: (400, 300)",
        "Extraction radius: 100 pixels"
    ]
    
    y_offset = 50
    for line in text_lines:
        draw.text((50, y_offset), line, fill='black', font=font)
        y_offset += 35
    
    # Add a border
    draw.rectangle([10, 10, width-10, height-10], outline='blue', width=3)
    
    # Save the test image
    test_image_path = "test_image.png"
    image.save(test_image_path)
    print(f"Test image created: {test_image_path}")
    
    return image, test_image_path

def demo_ocr_functionality():
    """Demonstrate OCR functionality using a test image."""
    print("=" * 60)
    print("Screenshot OCR System Demo")
    print("=" * 60)
    
    # Create test image
    print("\n1. Creating test image...")
    test_image, test_image_path = create_test_image()
    
    # Initialize OCR system
    print("\n2. Initializing OCR system...")
    config = {
        "capture_interval": 10,
        "extraction_radius": 100,
        "output_dir": "demo_output",
        "tesseract_config": "--psm 6",
        "image_format": "PNG",
        "save_full_screenshots": False,
        "save_extracted_regions": True,
        "save_ocr_text": True
    }
    
    # Create a temporary config file for demo
    import json
    with open("demo_config.json", "w") as f:
        json.dump(config, f, indent=2)
    
    try:
        ocr_system = ScreenshotOCR("demo_config.json")
        
        # Demonstrate OCR on the test image
        print("\n3. Performing OCR on test image...")
        extracted_text = ocr_system.perform_ocr(test_image)
        
        print("\n4. OCR Results:")
        print("-" * 40)
        print(extracted_text)
        print("-" * 40)
        
        # Simulate region extraction
        print("\n5. Simulating region extraction around point (400, 300)...")
        ocr_system.last_screenshot = test_image
        
        # Extract a region around the center of the image
        center_x, center_y = 400, 300
        region, region_text = ocr_system.extract_region_around_point(center_x, center_y)
        
        if region:
            print(f"Region extracted: {region.size} pixels")
            print("Text found in region:")
            print("-" * 30)
            print(region_text)
            print("-" * 30)
        
        # Show system status
        print("\n6. System Status:")
        ocr_system.status()
        
        print(f"\n7. Output files created in: {ocr_system.output_dir}")
        
        # List created files
        import glob
        output_files = glob.glob(str(ocr_system.output_dir / "**" / "*"), recursive=True)
        if output_files:
            print("Created files:")
            for file_path in output_files:
                if os.path.isfile(file_path):
                    print(f"  - {file_path}")
    
    except Exception as e:
        print(f"Error during demo: {e}")
        import traceback
        traceback.print_exc()
    
    finally:
        # Cleanup
        print("\n8. Cleaning up...")
        cleanup_files = ["test_image.png", "demo_config.json"]
        for file_path in cleanup_files:
            try:
                if os.path.exists(file_path):
                    os.remove(file_path)
                    print(f"Removed: {file_path}")
            except Exception as e:
                print(f"Could not remove {file_path}: {e}")

def show_usage_instructions():
    """Show instructions for using the full system."""
    print("\n" + "=" * 60)
    print("Full System Usage Instructions")
    print("=" * 60)
    print("""
To use the full Screenshot OCR system:

1. Basic usage:
   ./run_screenshot_ocr.sh

2. With custom config:
   ./run_screenshot_ocr.sh my_config.json

3. Direct Python execution:
   source screenshot_ocr_env/bin/activate
   python screenshot_ocr.py

The system will:
- Take periodic screenshots of your desktop
- Monitor mouse clicks in real-time
- Extract text around click locations
- Save screenshots, extracted regions, and OCR text
- Create a log of all activities

Press Ctrl+C to stop the system gracefully.

Output will be saved in the 'screenshots_output' directory.
""")

def main():
    """Main demo function."""
    if "--help" in sys.argv:
        print("Screenshot OCR Demo")
        print("Usage: python demo.py [--ocr-only]")
        print("\nOptions:")
        print("  --ocr-only    Only run OCR demo, skip usage instructions")
        return
    
    # Run OCR demo
    demo_ocr_functionality()
    
    # Show usage instructions unless --ocr-only is specified
    if "--ocr-only" not in sys.argv:
        show_usage_instructions()
    
    print("\nDemo completed!")

if __name__ == "__main__":
    main()