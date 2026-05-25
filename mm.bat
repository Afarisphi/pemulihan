@echo off

echo Starting Maintenance...
echo.

echo Cleaning Temp...
del /q /s "%TEMP%\*" >nul 2>&1
del /q /s "C:\Windows\Temp\*" >nul 2>&1

echo Flush DNS...
ipconfig /flushdns >nul 2>&1

echo Running SFC...
sfc /scannow

echo Running DISM...
DISM /Online /Cleanup-Image /RestoreHealth

echo Optimizing Drive...
defrag C: /O >nul 2>&1

echo Maintenance Completed.
echo.

pause