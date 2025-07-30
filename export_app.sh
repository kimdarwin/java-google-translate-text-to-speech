#!/bin/bash

# Screenshot OCR Application Export Script
# This script packages the entire application for distribution

APP_NAME="screenshot-ocr-system"
VERSION="1.0.0"
EXPORT_DIR="${APP_NAME}-${VERSION}"
ARCHIVE_NAME="${EXPORT_DIR}.tar.gz"

echo "==========================================="
echo "Screenshot OCR System - Export Script"
echo "Version: $VERSION"
echo "==========================================="

# Create export directory
echo "Creating export directory: $EXPORT_DIR"
rm -rf "$EXPORT_DIR" 2>/dev/null
mkdir -p "$EXPORT_DIR"

# Copy main application files
echo "Copying application files..."
cp screenshot_ocr.py "$EXPORT_DIR/"
cp demo.py "$EXPORT_DIR/"
cp config.json "$EXPORT_DIR/"
cp requirements.txt "$EXPORT_DIR/"
cp README.md "$EXPORT_DIR/"
cp run_screenshot_ocr.sh "$EXPORT_DIR/"
cp run_screenshot_ocr.bat "$EXPORT_DIR/"
cp install_windows.bat "$EXPORT_DIR/"
cp uninstall_windows.bat "$EXPORT_DIR/"
cp QUICKSTART_WINDOWS.md "$EXPORT_DIR/"

# Create installation script
echo "Creating installation script..."
cat > "$EXPORT_DIR/install.sh" << 'EOF'
#!/bin/bash

# Screenshot OCR System - Installation Script

echo "============================================"
echo "Screenshot OCR System - Installation"
echo "============================================"

# Check if running on Linux
if [[ "$OSTYPE" != "linux-gnu"* ]]; then
    echo "Error: This application requires Linux with X11 support."
    exit 1
fi

# Check Python version
python3_version=$(python3 --version 2>/dev/null | cut -d' ' -f2 | cut -d'.' -f1-2)
if [[ -z "$python3_version" ]]; then
    echo "Error: Python 3 is required but not found."
    echo "Please install Python 3.8 or higher:"
    echo "  sudo apt update"
    echo "  sudo apt install python3 python3-pip"
    exit 1
fi

echo "Found Python: $(python3 --version)"

# Install system dependencies
echo "Installing system dependencies..."
if command -v apt-get >/dev/null 2>&1; then
    # Debian/Ubuntu
    echo "Detected Debian/Ubuntu system"
    sudo apt update
    sudo apt install -y python3-venv python3-pip tesseract-ocr python3-tk
elif command -v yum >/dev/null 2>&1; then
    # RedHat/CentOS/Fedora
    echo "Detected RedHat/CentOS/Fedora system"
    sudo yum install -y python3-virtualenv python3-pip tesseract python3-tkinter
elif command -v pacman >/dev/null 2>&1; then
    # Arch Linux
    echo "Detected Arch Linux system"
    sudo pacman -S python-virtualenv python-pip tesseract tk
else
    echo "Warning: Could not detect package manager."
    echo "Please manually install: python3-venv, tesseract-ocr, python3-tk"
fi

# Create virtual environment
echo "Creating Python virtual environment..."
python3 -m venv screenshot_ocr_env

# Check if virtual environment was created successfully
if [[ ! -d "screenshot_ocr_env" ]]; then
    echo "Error: Failed to create virtual environment."
    echo "Please ensure python3-venv is installed:"
    echo "  sudo apt install python3-venv"
    exit 1
fi

# Activate virtual environment and install dependencies
echo "Installing Python dependencies..."
source screenshot_ocr_env/bin/activate
pip install --upgrade pip
pip install -r requirements.txt

# Verify installation
echo "Verifying installation..."
if python -c "import pytesseract, cv2, PIL, pynput, numpy" 2>/dev/null; then
    echo "✓ Python dependencies installed successfully"
else
    echo "✗ Error installing Python dependencies"
    exit 1
fi

if command -v tesseract >/dev/null 2>&1; then
    echo "✓ Tesseract OCR found: $(tesseract --version | head -1)"
else
    echo "✗ Tesseract OCR not found"
    exit 1
fi

# Make scripts executable
chmod +x screenshot_ocr.py
chmod +x demo.py
chmod +x run_screenshot_ocr.sh

echo ""
echo "============================================"
echo "Installation completed successfully!"
echo "============================================"
echo ""
echo "Quick Start:"
echo "1. Run demo:        ./demo.py"
echo "2. Start system:    ./run_screenshot_ocr.sh"
echo "3. Show help:       ./screenshot_ocr.py --help"
echo ""
echo "The system will:"
echo "- Capture desktop screenshots every 5 seconds"
echo "- Monitor mouse clicks and extract text around them"
echo "- Save all data to 'screenshots_output' directory"
echo ""
echo "Press Ctrl+C to stop the system."
echo ""
EOF

chmod +x "$EXPORT_DIR/install.sh"

# Create uninstall script
echo "Creating uninstall script..."
cat > "$EXPORT_DIR/uninstall.sh" << 'EOF'
#!/bin/bash

# Screenshot OCR System - Uninstall Script

echo "============================================"
echo "Screenshot OCR System - Uninstall"
echo "============================================"

read -p "Are you sure you want to uninstall? This will remove all files. (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Uninstall cancelled."
    exit 0
fi

# Remove virtual environment
if [[ -d "screenshot_ocr_env" ]]; then
    echo "Removing virtual environment..."
    rm -rf screenshot_ocr_env
    echo "✓ Virtual environment removed"
fi

# Remove output directories
if [[ -d "screenshots_output" ]]; then
    echo "Removing output directory..."
    rm -rf screenshots_output
    echo "✓ Output directory removed"
fi

if [[ -d "demo_output" ]]; then
    echo "Removing demo output..."
    rm -rf demo_output
    echo "✓ Demo output removed"
fi

# Remove log files
if [[ -f "screenshot_ocr.log" ]]; then
    rm -f screenshot_ocr.log
    echo "✓ Log file removed"
fi

# Remove cache
if [[ -d "__pycache__" ]]; then
    rm -rf __pycache__
    echo "✓ Cache removed"
fi

echo ""
echo "Uninstall completed!"
echo "Application files (*.py, *.sh, *.md, etc.) were kept."
echo "Remove the application directory manually if desired."
EOF

chmod +x "$EXPORT_DIR/uninstall.sh"

# Create version info
echo "Creating version info..."
cat > "$EXPORT_DIR/VERSION" << EOF
Screenshot OCR System
Version: $VERSION
Build Date: $(date)
Platform: Linux (X11 required)

Components:
- screenshot_ocr.py: Main application
- demo.py: Demonstration script
- config.json: Configuration file
- requirements.txt: Python dependencies
- README.md: Documentation
- install.sh: Linux installation script
- install_windows.bat: Windows installation script
- uninstall.sh: Linux removal script
- uninstall_windows.bat: Windows removal script
- run_screenshot_ocr.sh: Linux launcher script
- run_screenshot_ocr.bat: Windows launcher script

Dependencies:
- Python 3.8+
- Tesseract OCR
- PIL (Pillow)
- OpenCV
- pynput
- numpy

Author: AI Assistant
License: MIT-style (provided as-is)
EOF

# Create a quick start guide
echo "Creating quick start guide..."
cat > "$EXPORT_DIR/QUICKSTART.md" << 'EOF'
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
EOF

# Create changelog
echo "Creating changelog..."
cat > "$EXPORT_DIR/CHANGELOG.md" << 'EOF'
# Changelog

## Version 1.0.0 - Initial Release

### Features
- Periodic desktop screenshot capture
- Real-time OCR text extraction using Tesseract
- Mouse click detection and monitoring
- Configurable text extraction radius around clicks
- Multiple output formats (PNG images, text files)
- Comprehensive logging system
- JSON-based configuration
- Cross-platform installation scripts
- Demo mode for testing functionality

### Components
- Main application (`screenshot_ocr.py`)
- Configuration system (`config.json`)
- Installation automation (`install.sh`)
- Demonstration script (`demo.py`)
- Launcher script (`run_screenshot_ocr.sh`)
- Uninstall utility (`uninstall.sh`)

### Dependencies
- Python 3.8+
- Tesseract OCR engine
- Pillow (PIL) for image processing
- OpenCV for image preprocessing
- pynput for input monitoring
- numpy for numerical operations

### Supported Platforms
- Linux with X11 (tested on Ubuntu 24.04+)
- Windows 10/11 (tested on Windows 10+)
- Debian-based distributions
- RedHat/CentOS/Fedora (experimental)
- Arch Linux (experimental)

### Known Limitations
- Requires graphical environment (X11 on Linux, native on Windows)
- Cross-platform support (Linux and Windows)
- May require manual permissions for screenshot access
EOF

# Create LICENSE file
echo "Creating license file..."
cat > "$EXPORT_DIR/LICENSE" << 'EOF'
MIT License

Copyright (c) 2025 Screenshot OCR System

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
EOF

# Copy additional documentation if exists
if [[ -f "screenshot_ocr.log" ]]; then
    cp screenshot_ocr.log "$EXPORT_DIR/example.log"
fi

# Create the archive
echo "Creating archive: $ARCHIVE_NAME"
tar -czf "$ARCHIVE_NAME" "$EXPORT_DIR"

# Calculate file sizes
ARCHIVE_SIZE=$(du -h "$ARCHIVE_NAME" | cut -f1)
DIR_SIZE=$(du -h "$EXPORT_DIR" | cut -f1)

echo ""
echo "==========================================="
echo "Export completed successfully!"
echo "==========================================="
echo "Archive: $ARCHIVE_NAME ($ARCHIVE_SIZE)"
echo "Directory: $EXPORT_DIR ($DIR_SIZE)"
echo ""
echo "Contents:"
ls -la "$EXPORT_DIR"
echo ""
echo "To distribute:"
echo "1. Share the archive: $ARCHIVE_NAME"
echo "2. Or share the directory: $EXPORT_DIR"
echo ""
echo "Installation for users:"
echo "1. Extract: tar -xzf $ARCHIVE_NAME"
echo "2. Install: cd $EXPORT_DIR && ./install.sh"
echo "3. Run: ./run_screenshot_ocr.sh"
echo ""
echo "Archive is ready for distribution!"
EOF