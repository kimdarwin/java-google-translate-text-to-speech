# Screenshot OCR System - Windows Quick Start

## 🖥️ **Windows Installation Guide**

### **Step 1: Prerequisites**

1. **Install Python 3.8+**
   - Download from [python.org](https://python.org)
   - ⚠️ **IMPORTANT:** Check "Add Python to PATH" during installation
   - Choose "Install for all users" (recommended)

2. **Install Tesseract OCR**
   - Download from [UB-Mannheim/tesseract](https://github.com/UB-Mannheim/tesseract/wiki)
   - Download: `tesseract-ocr-w64-setup-5.x.x.exe`
   - Run as administrator and use default installation path

### **Step 2: Install Application**

1. Extract the downloaded archive
2. Open Command Prompt or PowerShell in the extracted folder
3. Run the installation script:
   ```cmd
   install_windows.bat
   ```

The installer will:
- ✅ Verify Python installation
- ✅ Create virtual environment
- ✅ Install Python packages
- ✅ Detect Tesseract OCR
- ✅ Test the installation

### **Step 3: Run the Application**

**Option 1: Double-click**
- Double-click `run_screenshot_ocr.bat`

**Option 2: Command line**
```cmd
run_screenshot_ocr.bat
```

**Option 3: Manual**
```cmd
screenshot_ocr_env\Scripts\activate
python screenshot_ocr.py
```

### **Step 4: Test First**
```cmd
python demo.py
```

---

## 🎯 **What It Does**

1. **📸 Screenshots:** Captures your desktop every 5 seconds
2. **🖱️ Click Detection:** Monitors all mouse clicks
3. **📝 Text Extraction:** OCR text around where you click
4. **💾 Auto Save:** Everything saved to `screenshots_output\`

## 📁 **Output Structure**
```
screenshots_output\
├── screenshots\          # Full desktop screenshots
├── extracted_regions\    # Areas around mouse clicks
├── ocr_text\            # Text files with extracted content
├── click_summary.json   # Summary of all clicks
└── screenshot_ocr.log   # System log
```

## ⚙️ **Configuration**

Edit `config.json` to customize:
```json
{
    "capture_interval": 5,        // Screenshot every N seconds
    "extraction_radius": 100,     // Area around clicks (pixels)
    "output_dir": "screenshots_output",
    "save_full_screenshots": true
}
```

## 🛠️ **Troubleshooting**

### **Python Not Found**
- Reinstall Python from [python.org](https://python.org)
- Make sure "Add Python to PATH" is checked

### **Tesseract Not Found**
- Install from [UB-Mannheim/tesseract](https://github.com/UB-Mannheim/tesseract/wiki)
- Use default installation path: `C:\Program Files\Tesseract-OCR`

### **Permission Errors**
- Run Command Prompt as Administrator
- Check Windows Defender/antivirus settings

### **Screenshots Not Working**
- Make sure you're in a graphical environment (not remote desktop without proper setup)
- Check Windows privacy settings for screen capture

### **Dependencies Fail to Install**
- Install Visual C++ Build Tools if needed
- Check your internet connection
- Try running as administrator

## 🚀 **Quick Commands**

```cmd
# Install
install_windows.bat

# Run demo
python demo.py

# Start system
run_screenshot_ocr.bat

# Stop system
Ctrl+C in command window

# Uninstall
uninstall_windows.bat
```

## 🔒 **Windows Security Notes**

- **Windows Defender:** May flag the application initially - allow it
- **User Account Control:** May request permission - allow for installation
- **Privacy Settings:** Ensure screen capture is allowed for the application
- **Antivirus:** Some antivirus software may interfere with screenshot capture

## 💡 **Pro Tips**

1. **Run as Administrator** if you encounter permission issues
2. **Pin to Taskbar:** Create a shortcut to `run_screenshot_ocr.bat`
3. **Startup:** Add to Windows startup folder for auto-start
4. **Multiple Monitors:** Works with multi-monitor setups
5. **Performance:** Increase `capture_interval` to reduce CPU usage

---

## 🎉 **You're Ready!**

Your Screenshot OCR system is now installed and ready to use on Windows. The system will capture everything you do and extract text around your mouse clicks automatically.

Perfect for:
- 📊 Data collection
- 📝 Research notes
- 🔍 Accessibility
- 🤖 Automation workflows