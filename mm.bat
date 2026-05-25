@echo off

:: Auto Run as Administrator
net session >nul 2>&1
if %errorlevel% neq 0 (
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit
)

color 0A
title Safe Windows Maintenance

echo ============================================
echo      SAFE WINDOWS MAINTENANCE
echo ============================================
echo.

echo [1/5] Cleaning Temp...
del /q /s "%TEMP%\*" >nul 2>&1
del /q /s "C:\Windows\Temp\*" >nul 2>&1
echo Done.
echo.

echo [2/5] Flushing DNS...
ipconfig /flushdns >nul 2>&1
echo Done.
echo.

echo [3/5] Running SFC...
sfc /scannow
echo Done.
echo.

echo [4/5] Optimizing Drive...
defrag C: /O
echo Done.
echo.

echo [5/5] Running Defender Quick Scan...

powershell -Command "try { Start-MpScan -ScanType QuickScan } catch {}"

echo Done.
echo.

echo ============================================
echo         MAINTENANCE COMPLETED
echo ============================================
echo.

pause
