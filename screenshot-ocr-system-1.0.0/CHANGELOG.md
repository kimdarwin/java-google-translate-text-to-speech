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
- Debian-based distributions
- RedHat/CentOS/Fedora (experimental)
- Arch Linux (experimental)

### Known Limitations
- Requires graphical environment (X11)
- Linux-only (no Windows/macOS support)
- May require manual permissions for screenshot access
