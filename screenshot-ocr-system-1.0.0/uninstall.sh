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
