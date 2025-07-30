@echo off
REM Screenshot OCR System - Windows Launcher
REM This script activates the virtual environment and runs the system on Windows

setlocal EnableDelayedExpansion

echo ============================================
echo Screenshot OCR System - Windows Launcher
echo ============================================

REM Get the directory where this script is located
set "SCRIPT_DIR=%~dp0"
cd /d "%SCRIPT_DIR%"

REM Check if virtual environment exists
if not exist "screenshot_ocr_env" (
    echo Error: Virtual environment not found!
    echo Please run the installation steps first:
    echo   python -m venv screenshot_ocr_env
    echo   screenshot_ocr_env\Scripts\activate
    echo   pip install -r requirements.txt
    echo.
    pause
    exit /b 1
)

REM Check if Python is available
python --version >nul 2>&1
if errorlevel 1 (
    echo Error: Python not found!
    echo Please install Python 3.8+ from https://python.org
    echo Make sure to check "Add Python to PATH" during installation
    echo.
    pause
    exit /b 1
)

REM Activate virtual environment
echo Activating virtual environment...
call screenshot_ocr_env\Scripts\activate.bat

REM Check if dependencies are installed
echo Checking dependencies...
python -c "import pytesseract, cv2, PIL, pynput, numpy" 2>nul
if errorlevel 1 (
    echo Error: Required dependencies not installed!
    echo Please install dependencies:
    echo   pip install -r requirements.txt
    echo.
    pause
    exit /b 1
)

REM Check if Tesseract is available (try common installation paths)
set "TESSERACT_FOUND=0"

REM Check if tesseract is in PATH
tesseract --version >nul 2>&1
if not errorlevel 1 (
    set "TESSERACT_FOUND=1"
    echo Found Tesseract in PATH
) else (
    REM Check common Tesseract installation paths
    if exist "C:\Program Files\Tesseract-OCR\tesseract.exe" (
        set "TESSERACT_FOUND=1"
        set "PATH=C:\Program Files\Tesseract-OCR;!PATH!"
        echo Found Tesseract at: C:\Program Files\Tesseract-OCR
    ) else if exist "C:\Program Files (x86)\Tesseract-OCR\tesseract.exe" (
        set "TESSERACT_FOUND=1"
        set "PATH=C:\Program Files (x86)\Tesseract-OCR;!PATH!"
        echo Found Tesseract at: C:\Program Files (x86)\Tesseract-OCR
    ) else if exist "%LOCALAPPDATA%\Programs\Tesseract-OCR\tesseract.exe" (
        set "TESSERACT_FOUND=1"
        set "PATH=%LOCALAPPDATA%\Programs\Tesseract-OCR;!PATH!"
        echo Found Tesseract at: %LOCALAPPDATA%\Programs\Tesseract-OCR
    )
)

if "!TESSERACT_FOUND!"=="0" (
    echo Warning: Tesseract OCR not found!
    echo Please install Tesseract from:
    echo https://github.com/UB-Mannheim/tesseract/wiki
    echo.
    echo The system may not work correctly without Tesseract.
    echo Continue anyway? (y/N)
    set /p "continue="
    if /i not "!continue!"=="y" (
        echo Installation cancelled.
        pause
        exit /b 1
    )
) else (
    tesseract --version | findstr "tesseract"
)

echo.
echo Starting Screenshot OCR System...
echo Virtual environment: %VIRTUAL_ENV%
echo Working directory: %CD%
echo.

REM Run the system with any provided arguments
python screenshot_ocr.py %*

REM Keep window open if there was an error
if errorlevel 1 (
    echo.
    echo An error occurred. Check the log file for details.
    pause
)