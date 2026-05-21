@echo off
title Monthly Windows Maintenance
color 0A

:: =====================================================
:: SAFE MONTHLY WINDOWS MAINTENANCE SCRIPT
:: Optimized for stability and minimal interruption
:: Run as Administrator
:: =====================================================

:: -----------------------------------------------------
:: CHECK ADMIN
:: -----------------------------------------------------
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo.
    echo [ERROR] Please run this script as Administrator.
    pause
    exit
)

:: -----------------------------------------------------
:: SET LOG FILE
:: -----------------------------------------------------
set LOGFILE=%~dp0maintenance_log.txt

echo ============================================ >> "%LOGFILE%"
echo Maintenance Started : %date% %time% >> "%LOGFILE%"
echo ============================================ >> "%LOGFILE%"

cls
echo ============================================
echo     WINDOWS MAINTENANCE STARTING
echo ============================================
echo.

:: -----------------------------------------------------
:: 1. CLEAN TEMP FILES
:: -----------------------------------------------------
echo [1/9] Cleaning Temporary Files...
echo [1/9] Cleaning Temporary Files... >> "%LOGFILE%"

del /q /f /s "%TEMP%\*" >nul 2>&1
del /q /f /s "C:\Windows\Temp\*" >nul 2>&1

echo Temporary files cleaned. >> "%LOGFILE%"

:: -----------------------------------------------------
:: 2. DISK CLEANUP
:: -----------------------------------------------------
echo.
echo [2/9] Running Disk Cleanup...
echo [2/9] Running Disk Cleanup... >> "%LOGFILE%"

cleanmgr /verylowdisk >nul 2>&1

echo Disk Cleanup completed. >> "%LOGFILE%"

:: -----------------------------------------------------
:: 3. FLUSH DNS
:: -----------------------------------------------------
echo.
echo [3/9] Flushing DNS Cache...
echo [3/9] Flushing DNS Cache... >> "%LOGFILE%"

ipconfig /flushdns >> "%LOGFILE%"

:: -----------------------------------------------------
:: 4. SYSTEM FILE CHECKER
:: -----------------------------------------------------
echo.
echo [4/9] Running System File Checker...
echo [4/9] Running SFC Scan... >> "%LOGFILE%"

start /wait sfc /scannow

echo SFC completed. >> "%LOGFILE%"

:: -----------------------------------------------------
:: 5. DISM HEALTH RESTORE
:: -----------------------------------------------------
echo.
echo [5/9] Running DISM RestoreHealth...
echo [5/9] Running DISM RestoreHealth... >> "%LOGFILE%"

start /wait DISM /Online /Cleanup-Image /RestoreHealth

echo DISM completed. >> "%LOGFILE%"

:: -----------------------------------------------------
:: 6. OPTIMIZE DRIVE
:: -----------------------------------------------------
echo.
echo [6/9] Optimizing Drive...
echo [6/9] Optimizing Drive... >> "%LOGFILE%"

defrag C: /O >> "%LOGFILE%"

echo Drive optimization completed. >> "%LOGFILE%"

:: -----------------------------------------------------
:: 7. WINDOWS DEFENDER QUICK SCAN
:: -----------------------------------------------------
echo.
echo [7/9] Running Microsoft Defender Quick Scan...
echo [7/9] Running Defender Scan... >> "%LOGFILE%"

powershell -WindowStyle Hidden -Command "Start-MpScan -ScanType QuickScan"

echo Defender scan completed. >> "%LOGFILE%"

:: -----------------------------------------------------
:: 8. RESTART PRINT SPOOLER
:: -----------------------------------------------------
echo.
echo [8/9] Restarting Print Spooler...
echo [8/9] Restarting Print Spooler... >> "%LOGFILE%"

net stop spooler >nul 2>&1
timeout /t 2 >nul
net start spooler >nul 2>&1

echo Print Spooler restarted. >> "%LOGFILE%"

:: -----------------------------------------------------
:: 9. CHECK DISK HEALTH
:: -----------------------------------------------------
echo.
echo [9/9] Checking Disk Health...
echo [9/9] Checking Disk Health... >> "%LOGFILE%"

wmic diskdrive get model,status >> "%LOGFILE%"

echo Disk health check completed. >> "%LOGFILE%"

:: -----------------------------------------------------
:: CLEANUP UNUSED WINDOWS
:: -----------------------------------------------------
taskkill /f /im cleanmgr.exe >nul 2>&1
taskkill /f /im dism.exe >nul 2>&1

:: -----------------------------------------------------
:: COMPLETE
:: -----------------------------------------------------
echo.
echo ============================================
echo        MAINTENANCE COMPLETED
echo ============================================
echo.

echo Maintenance Finished : %date% %time% >> "%LOGFILE%"
echo ============================================ >> "%LOGFILE%"

echo Log saved:
echo %LOGFILE%

echo.
echo PC will shutdown automatically in 60 seconds.
echo Please save your remaining work.

shutdown /s /t 60

timeout /t 5 >nul
exit