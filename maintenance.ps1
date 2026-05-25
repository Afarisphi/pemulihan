Write-Host ""
Write-Host "SAFE WINDOWS MAINTENANCE"
Write-Host ""

Write-Host "[1/5] Cleaning Temp..."
Remove-Item "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item "C:\Windows\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue

Write-Host "[2/5] Flush DNS..."
ipconfig /flushdns | Out-Null

Write-Host "[3/5] Running SFC..."
sfc /scannow

Write-Host "[4/5] Optimizing Drive..."
defrag C: /O

Write-Host "[5/5] Defender Quick Scan..."

try {
    Start-MpScan -ScanType QuickScan
}
catch {
    Write-Host "Defender not available."
}

Write-Host ""
Write-Host "Maintenance Completed."

Start-Sleep -Seconds 5