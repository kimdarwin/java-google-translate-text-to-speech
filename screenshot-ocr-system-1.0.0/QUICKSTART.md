# Quick Start Guide

## Installation

### Linux (Ubuntu/Debian)
1. Extract the archive and navigate to the directory
2. Run the installation script:
   ```bash
   ./install.sh
   ```

### Windows
1. Extract the archive and navigate to the directory
2. Run the installation script:
   ```cmd
   install_windows.bat
   ```

## Usage

### Test the System
**Linux:**
```bash
./demo.py
```
**Windows:**
```cmd
python demo.py
```

### Start Screenshot OCR
**Linux:**
```bash
./run_screenshot_ocr.sh
```
**Windows:**
```cmd
run_screenshot_ocr.bat
```

### Stop the System
Press `Ctrl+C` in the terminal

## What It Does

1. **Takes periodic screenshots** of your desktop (every 5 seconds)
2. **Monitors mouse clicks** in real-time
3. **Extracts text** around cursor click positions using OCR
4. **Saves everything** to `screenshots_output/` directory

## Output Files

- `screenshots/` - Full desktop screenshots
- `extracted_regions/` - Areas around mouse clicks
- `ocr_text/` - Text files with extracted content
- `click_summary.json` - Summary of all clicks
- `screenshot_ocr.log` - System log

## Configuration

Edit `config.json` to customize:
- Screenshot interval
- Extraction radius around clicks
- Output directory
- File formats

## Troubleshooting

1. **No screenshots**: Check if running in graphical environment
2. **Permission errors**: Ensure X11 access permissions
3. **OCR not working**: Verify Tesseract installation: `tesseract --version`
4. **Dependencies missing**: Re-run `./install.sh`

## Uninstall

```bash
./uninstall.sh
```
