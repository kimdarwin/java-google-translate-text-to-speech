@echo off
REM Screenshot OCR System - Windows Installation Script
REM This script sets up the Screenshot OCR system on Windows

setlocal EnableDelayedExpansion

echo ============================================
echo Screenshot OCR System - Windows Installation
echo ============================================
echo.

REM Check if Python is installed
echo Checking Python installation...
python --version >nul 2>&1
if errorlevel 1 (
    echo Error: Python not found!
    echo.
    echo Please install Python 3.8 or higher from: https://python.org
    echo.
    echo IMPORTANT: During installation, make sure to:
    echo  1. Check "Add Python to PATH"
    echo  2. Choose "Install for all users" (recommended)
    echo.
    echo After installing Python, run this script again.
    pause
    exit /b 1
)

REM Display Python version
for /f "tokens=2" %%i in ('python --version 2^>^&1') do set PYTHON_VERSION=%%i
echo Found Python: %PYTHON_VERSION%

REM Check Python version (basic check for 3.8+)
for /f "tokens=1,2 delims=." %%a in ("%PYTHON_VERSION%") do (
    set MAJOR=%%a
    set MINOR=%%b
)

if %MAJOR% LSS 3 (
    echo Error: Python 3.8+ is required, found Python %PYTHON_VERSION%
    echo Please update Python from: https://python.org
    pause
    exit /b 1
)

if %MAJOR% EQU 3 if %MINOR% LSS 8 (
    echo Error: Python 3.8+ is required, found Python %PYTHON_VERSION%
    echo Please update Python from: https://python.org
    pause
    exit /b 1
)

echo Python version is compatible.
echo.

REM Check if pip is available
echo Checking pip...
pip --version >nul 2>&1
if errorlevel 1 (
    echo Error: pip not found!
    echo Please ensure pip is installed with Python.
    echo Try: python -m ensurepip --upgrade
    pause
    exit /b 1
)

echo pip is available.
echo.

REM Create virtual environment
echo Creating Python virtual environment...
if exist "screenshot_ocr_env" (
    echo Virtual environment already exists. Removing old environment...
    rmdir /s /q "screenshot_ocr_env"
)

python -m venv screenshot_ocr_env
if errorlevel 1 (
    echo Error: Failed to create virtual environment.
    echo This might be due to:
    echo  1. Insufficient permissions
    echo  2. Antivirus software blocking the operation
    echo  3. Python installation issues
    echo.
    echo Try running as administrator or check your Python installation.
    pause
    exit /b 1
)

echo Virtual environment created successfully.
echo.

REM Activate virtual environment
echo Activating virtual environment...
call screenshot_ocr_env\Scripts\activate.bat

REM Upgrade pip in virtual environment
echo Upgrading pip...
python -m pip install --upgrade pip

REM Install Python dependencies
echo Installing Python dependencies...
echo This may take a few minutes...
pip install -r requirements.txt

if errorlevel 1 (
    echo Error: Failed to install Python dependencies.
    echo This might be due to:
    echo  1. Network connectivity issues
    echo  2. Missing Visual C++ build tools (for some packages)
    echo  3. Firewall blocking pip
    echo.
    echo For build tools, you may need to install:
    echo Microsoft Visual C++ Build Tools or Visual Studio
    pause
    exit /b 1
)

echo Python dependencies installed successfully.
echo.

REM Verify installation
echo Verifying installation...
python -c "import pytesseract, cv2, PIL, pynput, numpy" 2>nul
if errorlevel 1 (
    echo Error: Some Python packages failed to import.
    echo Please check the error messages above.
    pause
    exit /b 1
)

echo Python packages verified successfully.
echo.

REM Check for Tesseract OCR
echo Checking Tesseract OCR...
set "TESSERACT_FOUND=0"

REM Check if tesseract is in PATH
tesseract --version >nul 2>&1
if not errorlevel 1 (
    set "TESSERACT_FOUND=1"
    echo Found Tesseract OCR in PATH
) else (
    REM Check common installation paths
    if exist "C:\Program Files\Tesseract-OCR\tesseract.exe" (
        set "TESSERACT_FOUND=1"
        echo Found Tesseract OCR at: C:\Program Files\Tesseract-OCR
    ) else if exist "C:\Program Files (x86)\Tesseract-OCR\tesseract.exe" (
        set "TESSERACT_FOUND=1"
        echo Found Tesseract OCR at: C:\Program Files (x86)\Tesseract-OCR
    ) else if exist "%LOCALAPPDATA%\Programs\Tesseract-OCR\tesseract.exe" (
        set "TESSERACT_FOUND=1"
        echo Found Tesseract OCR at: %LOCALAPPDATA%\Programs\Tesseract-OCR
    )
)

if "!TESSERACT_FOUND!"=="0" (
    echo.
    echo WARNING: Tesseract OCR not found!
    echo.
    echo Tesseract is REQUIRED for text recognition.
    echo Please download and install from:
    echo https://github.com/UB-Mannheim/tesseract/wiki
    echo.
    echo Installation steps:
    echo 1. Download tesseract-ocr-w64-setup-5.x.x.exe
    echo 2. Run the installer as administrator
    echo 3. Use default installation path
    echo 4. After installation, restart this script
    echo.
    echo Continue installation without Tesseract? (y/N)
    set /p "continue="
    if /i not "!continue!"=="y" (
        echo Installation cancelled.
        echo Please install Tesseract and run this script again.
        pause
        exit /b 1
    )
    echo Continuing without Tesseract (OCR will not work)...
) else (
    echo Tesseract OCR is ready.
)

echo.

REM Create a test to verify everything works
echo Running installation test...
python -c "
import sys
try:
    from screenshot_ocr import ScreenshotOCR
    print('✓ Screenshot OCR module loads successfully')
    
    # Test basic functionality
    config = {
        'capture_interval': 10,
        'extraction_radius': 100,
        'output_dir': 'test_output',
        'save_full_screenshots': False,
        'save_extracted_regions': False,
        'save_ocr_text': False
    }
    
    ocr_system = ScreenshotOCR()
    print('✓ Screenshot OCR system initializes correctly')
    
    print('✓ Installation test passed')
except Exception as e:
    print('✗ Installation test failed:', str(e))
    sys.exit(1)
" 2>nul

if errorlevel 1 (
    echo Installation test failed. Please check the error messages above.
    pause
    exit /b 1
)

echo.
echo ============================================
echo Installation completed successfully!
echo ============================================
echo.
echo Quick Start:
echo 1. Test demo:           demo.py
echo 2. Start system:       run_screenshot_ocr.bat
echo 3. Show help:          python screenshot_ocr.py --help
echo.
echo The system will:
echo - Capture desktop screenshots every 5 seconds
echo - Monitor mouse clicks and extract text around them
echo - Save all data to 'screenshots_output' directory
echo.
echo Windows-specific notes:
echo - Make sure Windows Defender allows the application
echo - Run as administrator if you encounter permission issues
echo - Tesseract OCR is required for text recognition
echo.
echo Press Ctrl+C to stop the system when running.
echo.
echo Installation log saved to: installation.log
echo.
pause