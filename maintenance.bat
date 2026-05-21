@echo off
title Monthly Windows Maintenance
color 0A

:: =====================================================
:: MONTHLY WINDOWS MAINTENANCE SCRIPT
:: Safe routine maintenance for Windows
:: Run as Administrator
:: =====================================================

echo.
echo ============================================
echo   WINDOWS MAINTENANCE STARTING...
echo ============================================
echo.

:: -----------------------------------------------------
:: CHECK ADMIN
:: -----------------------------------------------------
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo [ERROR] Run this script as Administrator.
    pause
    exit
)

:: -----------------------------------------------------
:: CREATE LOG
:: -----------------------------------------------------
set LOGFILE=%~dp0maintenance_log.txt

echo ============================================ >> "%LOGFILE%"
echo Maintenance Started : %date% %time% >> "%LOGFILE%"
echo ============================================ >> "%LOGFILE%"

:: -----------------------------------------------------
:: TEMP FILE CLEANUP
:: -----------------------------------------------------
echo.
echo [1/9] Cleaning TEMP files...
echo Cleaning TEMP files... >> "%LOGFILE%"

del /q /f /s "%TEMP%\*" >nul 2>&1
del /q /f /s "C:\Windows\Temp\*" >nul 2>&1

echo TEMP cleanup completed. >> "%LOGFILE%"

:: -----------------------------------------------------
:: DISK CLEANUP
:: -----------------------------------------------------
echo.
echo [2/9] Running Disk Cleanup...
echo Running Disk Cleanup... >> "%LOGFILE%"

cleanmgr /verylowdisk >nul 2>&1

echo Disk Cleanup completed. >> "%LOGFILE%"

:: -----------------------------------------------------
:: FLUSH DNS
:: -----------------------------------------------------
echo.
echo [3/9] Flushing DNS...
echo Flushing DNS... >> "%LOGFILE%"

ipconfig /flushdns >> "%LOGFILE%"

:: -----------------------------------------------------
:: SFC SCAN
:: -----------------------------------------------------
echo.
echo [4/9] Running System File Checker...
echo Running SFC scan... >> "%LOGFILE%"

sfc /scannow >> "%LOGFILE%"

:: -----------------------------------------------------
:: DISM HEALTH REPAIR
:: -----------------------------------------------------
echo.
echo [5/9] Running DISM RestoreHealth...
echo Running DISM RestoreHealth... >> "%LOGFILE%"

DISM /Online /Cleanup-Image /RestoreHealth >> "%LOGFILE%"

:: -----------------------------------------------------
:: OPTIMIZE DRIVES
:: -----------------------------------------------------
echo.
echo [6/9] Optimizing Drives...
echo Optimizing Drives... >> "%LOGFILE%"

defrag C: /O >> "%LOGFILE%"

echo Drive optimization completed. >> "%LOGFILE%"

:: -----------------------------------------------------
:: WINDOWS DEFENDER QUICK SCAN
:: -----------------------------------------------------
echo.
echo [7/9] Running Microsoft Defender Quick Scan...
echo Running Defender Quick Scan... >> "%LOGFILE%"

powershell -Command "Start-MpScan -ScanType QuickScan" >> "%LOGFILE%"

echo Defender scan completed. >> "%LOGFILE%"

:: -----------------------------------------------------
:: RESTART PRINT SPOOLER
:: -----------------------------------------------------
echo.
echo [8/9] Restarting Print Spooler...
echo Restarting Print Spooler... >> "%LOGFILE%"

net stop spooler >nul 2>&1
timeout /t 2 >nul
net start spooler >nul 2>&1

echo Print Spooler restarted. >> "%LOGFILE%"

:: -----------------------------------------------------
:: CHECK DISK HEALTH
:: -----------------------------------------------------
echo.
echo [9/9] Checking Disk Health...
echo Checking Disk Health... >> "%LOGFILE%"

wmic diskdrive get model,status >> "%LOGFILE%"

echo.
echo ============================================
echo   MAINTENANCE COMPLETED
echo ============================================
echo.

echo Maintenance Finished : %date% %time% >> "%LOGFILE%"
echo ============================================ >> "%LOGFILE%"

echo Log saved to:
echo %LOGFILE%

echo.
echo PC will shutdown in 60 seconds...
echo Save your work now.

shutdown /s /t 60

pause