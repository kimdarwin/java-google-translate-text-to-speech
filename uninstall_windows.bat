@echo off
REM Screenshot OCR System - Windows Uninstall Script
REM This script removes the Screenshot OCR system from Windows

setlocal EnableDelayedExpansion

echo ============================================
echo Screenshot OCR System - Windows Uninstall
echo ============================================
echo.

echo This will remove:
echo - Python virtual environment
echo - Screenshot output directories
echo - Log files and cache
echo.
echo Application files (*.py, *.bat, *.md, etc.) will be kept.
echo.

set /p "confirm=Are you sure you want to uninstall? (y/N): "
if /i not "%confirm%"=="y" (
    echo Uninstall cancelled.
    pause
    exit /b 0
)

echo.
echo Starting uninstall process...
echo.

REM Remove virtual environment
if exist "screenshot_ocr_env" (
    echo Removing Python virtual environment...
    rmdir /s /q "screenshot_ocr_env" 2>nul
    if exist "screenshot_ocr_env" (
        echo Warning: Could not remove virtual environment completely.
        echo Some files may be in use. Please restart and try again.
    ) else (
        echo ✓ Virtual environment removed
    )
) else (
    echo Virtual environment not found (already removed)
)

REM Remove output directories
if exist "screenshots_output" (
    echo Removing screenshots output directory...
    rmdir /s /q "screenshots_output" 2>nul
    if exist "screenshots_output" (
        echo Warning: Could not remove screenshots_output completely.
        echo Some files may be in use.
    ) else (
        echo ✓ Screenshots output directory removed
    )
) else (
    echo Screenshots output directory not found
)

if exist "demo_output" (
    echo Removing demo output directory...
    rmdir /s /q "demo_output" 2>nul
    if exist "demo_output" (
        echo Warning: Could not remove demo_output completely.
        echo Some files may be in use.
    ) else (
        echo ✓ Demo output directory removed
    )
) else (
    echo Demo output directory not found
)

if exist "test_output" (
    echo Removing test output directory...
    rmdir /s /q "test_output" 2>nul
    if exist "test_output" (
        echo Warning: Could not remove test_output completely.
        echo Some files may be in use.
    ) else (
        echo ✓ Test output directory removed
    )
) else (
    echo Test output directory not found
)

REM Remove log files
if exist "screenshot_ocr.log" (
    echo Removing log file...
    del "screenshot_ocr.log" 2>nul
    if exist "screenshot_ocr.log" (
        echo Warning: Could not remove screenshot_ocr.log
        echo File may be in use.
    ) else (
        echo ✓ Log file removed
    )
) else (
    echo Log file not found
)

if exist "installation.log" (
    echo Removing installation log...
    del "installation.log" 2>nul
    if exist "installation.log" (
        echo Warning: Could not remove installation.log
    ) else (
        echo ✓ Installation log removed
    )
) else (
    echo Installation log not found
)

REM Remove Python cache
if exist "__pycache__" (
    echo Removing Python cache...
    rmdir /s /q "__pycache__" 2>nul
    if exist "__pycache__" (
        echo Warning: Could not remove __pycache__ completely.
    ) else (
        echo ✓ Python cache removed
    )
) else (
    echo Python cache not found
)

REM Remove any .pyc files
for /r . %%f in (*.pyc) do (
    echo Removing: %%f
    del "%%f" 2>nul
)

echo.
echo ============================================
echo Uninstall completed!
echo ============================================
echo.
echo Removed:
echo - Python virtual environment
echo - Output directories
echo - Log files
echo - Python cache files
echo.
echo Kept:
echo - Application source files (*.py)
echo - Configuration files (*.json)
echo - Documentation (*.md)
echo - Scripts (*.bat, *.sh)
echo.
echo To completely remove the application:
echo 1. Delete the entire application directory
echo 2. Or manually remove the remaining files
echo.
echo To reinstall:
echo 1. Run: install_windows.bat
echo 2. Or follow the installation instructions
echo.
pause