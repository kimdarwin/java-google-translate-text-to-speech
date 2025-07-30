#!/bin/bash

# Screenshot OCR System Launcher
# This script activates the virtual environment and runs the system

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Check if virtual environment exists
if [ ! -d "screenshot_ocr_env" ]; then
    echo "Error: Virtual environment not found!"
    echo "Please run the installation steps first:"
    echo "  python3 -m venv screenshot_ocr_env"
    echo "  source screenshot_ocr_env/bin/activate"
    echo "  pip install -r requirements.txt"
    exit 1
fi

# Activate virtual environment
source screenshot_ocr_env/bin/activate

# Check if dependencies are installed
if ! python -c "import pytesseract, cv2, PIL, pynput, numpy" 2>/dev/null; then
    echo "Error: Required dependencies not installed!"
    echo "Please install dependencies:"
    echo "  pip install -r requirements.txt"
    exit 1
fi

# Check if tesseract is available
if ! command -v tesseract &> /dev/null; then
    echo "Error: Tesseract OCR not found!"
    echo "Please install tesseract:"
    echo "  sudo apt install tesseract-ocr"
    exit 1
fi

echo "Starting Screenshot OCR System..."
echo "Virtual environment: $(which python)"
echo "Working directory: $PWD"
echo ""

# Run the system with any provided arguments
python screenshot_ocr.py "$@"