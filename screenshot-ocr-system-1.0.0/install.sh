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
