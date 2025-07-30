# Desktop Screenshot and OCR System

A Python-based system that captures desktop screenshots periodically, performs OCR (Optical Character Recognition), and extracts text around mouse cursor clicks.

## Features

- **Periodic Screenshot Capture**: Automatically takes desktop screenshots at configurable intervals
- **Real-time OCR Processing**: Extracts text from screenshots using Tesseract OCR
- **Mouse Click Detection**: Monitors mouse clicks and captures text around cursor position
- **Configurable Extraction Radius**: Customizable area around mouse clicks for text extraction
- **Multiple Output Formats**: Saves screenshots, extracted regions, and OCR text
- **Comprehensive Logging**: Detailed logging of all operations
- **JSON Configuration**: Easy configuration through JSON file

## Prerequisites

### System Requirements

- Linux (tested on Ubuntu 24.04+)
- Python 3.8 or higher
- Tesseract OCR engine
- X11 display server (for screenshot capture)

### System Dependencies

Install the required system packages:

```bash
sudo apt update
sudo apt install -y python3.13-venv python3-pip tesseract-ocr python3-tk
```

## Installation

1. **Clone or download the project files**

2. **Create a Python virtual environment:**
   ```bash
   python3 -m venv screenshot_ocr_env
   source screenshot_ocr_env/bin/activate
   ```

3. **Install Python dependencies:**
   ```bash
   pip install -r requirements.txt
   ```

## Usage

### Basic Usage

Run the system with default settings:

```bash
source screenshot_ocr_env/bin/activate
python screenshot_ocr.py
```

### Command Line Options

```bash
# Show help
python screenshot_ocr.py --help

# Use custom configuration file
python screenshot_ocr.py my_config.json
```

### Configuration

The system uses a `config.json` file for configuration. If it doesn't exist, a default one will be created:

```json
{
    "capture_interval": 5,
    "extraction_radius": 100,
    "output_dir": "screenshots_output",
    "tesseract_config": "--psm 6",
    "image_format": "PNG",
    "save_full_screenshots": true,
    "save_extracted_regions": true,
    "save_ocr_text": true
}
```

**Configuration Options:**

- `capture_interval`: Time between screenshots in seconds (default: 5)
- `extraction_radius`: Pixel radius around mouse clicks for text extraction (default: 100)
- `output_dir`: Directory to save all outputs (default: "screenshots_output")
- `tesseract_config`: Tesseract OCR configuration (default: "--psm 6")
- `image_format`: Image format for saved files (PNG, JPEG, etc.)
- `save_full_screenshots`: Whether to save full desktop screenshots
- `save_extracted_regions`: Whether to save extracted regions around clicks
- `save_ocr_text`: Whether to save OCR text to files

## Output Structure

The system creates the following directory structure:

```
screenshots_output/
├── screenshots/          # Full desktop screenshots
├── extracted_regions/    # Regions around mouse clicks
├── ocr_text/            # OCR text files
├── click_summary.json   # Summary of all clicks
└── screenshot_ocr.log   # System log file
```

### File Naming Convention

- Screenshots: `screenshot_YYYYMMDD_HHMMSS.png`
- Extracted regions: `region_YYYYMMDD_HHMMSS_xXXX_yYYY.png`
- OCR text files: `text_YYYYMMDD_HHMMSS_xXXX_yYYY.txt`

## How It Works

1. **Screenshot Capture**: The system periodically captures full desktop screenshots
2. **OCR Processing**: Each screenshot is processed through Tesseract OCR to extract text
3. **Mouse Monitoring**: Mouse clicks are detected in real-time
4. **Region Extraction**: When a click occurs, a region around the cursor is extracted
5. **Text Analysis**: OCR is performed on the extracted region
6. **Output Generation**: Images and text are saved with timestamps and coordinates

## Example Output

When you click on text, the system will:

1. Print to console:
   ```
   === CLICK DETECTED ===
   Position: (523, 342)
   Extracted Text around cursor:
   ----------------------------------------
   Hello World
   This is sample text
   ----------------------------------------
   ```

2. Save extracted region image with a red circle marking the click position
3. Save OCR text to a file with metadata

## Stopping the System

Press `Ctrl+C` to gracefully stop the system. This will:
- Stop screenshot capture
- Stop mouse monitoring
- Save a summary of all clicks
- Clean up resources

## Troubleshooting

### Common Issues

1. **Permission Errors**: Make sure you have proper permissions for screenshot capture
2. **Display Issues**: Ensure you're running in a graphical environment with X11
3. **Tesseract Not Found**: Verify Tesseract is installed: `tesseract --version`
4. **Virtual Environment**: Always activate the virtual environment before running

### Logs

Check `screenshot_ocr.log` for detailed error messages and system information.

### Performance Tips

- Adjust `capture_interval` based on your needs (longer intervals use less resources)
- Reduce `extraction_radius` for faster processing of click regions
- Disable `save_full_screenshots` if you only need click-based extraction

## Dependencies

- **Pillow**: Image processing and screenshot capture
- **pytesseract**: Python wrapper for Tesseract OCR
- **opencv-python**: Image preprocessing for better OCR results
- **pynput**: Mouse and keyboard input monitoring
- **numpy**: Numerical operations for image processing

## License

This project is provided as-is for educational and practical use.

## Contributing

Feel free to submit issues, feature requests, or improvements to enhance the system's functionality.