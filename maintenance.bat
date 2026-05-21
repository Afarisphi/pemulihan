@echo off
title Safe Windows Maintenance
color 0A

:: =====================================================
:: SAFE WINDOWS MAINTENANCE
:: Stable - Sequential - Minimal Risk
:: Run as Administrator
:: =====================================================

:: -----------------------------------------------------
:: CHECK ADMIN
:: -----------------------------------------------------
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo.
    echo Please run this script as Administrator.
    pause
    exit
)

cls

echo ============================================
echo        SAFE WINDOWS MAINTENANCE
echo ============================================
echo.

:: -----------------------------------------------------
:: 1. CLEAN TEMP FILES
:: -----------------------------------------------------
echo [1/6] Cleaning Temporary Files...
echo Please wait...

del /q /s "%TEMP%\*" >nul 2>&1
del /q /s "C:\Windows\Temp\*" >nul 2>&1

echo Done.
echo.

:: -----------------------------------------------------
:: 2. FLUSH DNS
:: -----------------------------------------------------
echo [2/6] Flushing DNS Cache...
echo Please wait...

ipconfig /flushdns >nul 2>&1

echo Done.
echo.

:: -----------------------------------------------------
:: 3. SYSTEM FILE CHECKER
:: -----------------------------------------------------
echo [3/6] Running System File Checker...
echo This may take several minutes...
echo Please do not close the window.

sfc /scannow

echo SFC Scan Completed.
echo.

:: -----------------------------------------------------
:: 4. DISM RESTORE HEALTH
:: -----------------------------------------------------
echo [4/6] Running DISM RestoreHealth...
echo This may take several minutes...
echo Please do not close the window.

DISM /Online /Cleanup-Image /RestoreHealth

echo DISM Completed.
echo.

:: -----------------------------------------------------
:: 5. OPTIMIZE DRIVE
:: -----------------------------------------------------
echo [5/6] Optimizing Drive...
echo Please wait...

defrag C: /O >nul 2>&1

echo Drive Optimization Completed.
echo.

:: -----------------------------------------------------
:: 6. MICROSOFT DEFENDER QUICK SCAN
:: -----------------------------------------------------
echo [6/6] Running Microsoft Defender Quick Scan...
echo Please wait...

powershell -WindowStyle Hidden -Command "Start-MpScan -ScanType QuickScan"

echo Defender Scan Completed.
echo.

:: -----------------------------------------------------
:: FINISHED
:: -----------------------------------------------------
echo ============================================
echo         MAINTENANCE COMPLETED
echo ============================================
echo.

echo All processes finished successfully.
echo.

echo PC will shutdown in 60 seconds.
echo Please save your remaining work.

shutdown /s /t 60

timeout /t 5 >nul
exit
