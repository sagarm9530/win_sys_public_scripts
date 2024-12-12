# PowerShell Script to perform Disk Cleanup for all Windows Versions

# Check if the script is running as Administrator
If (-NOT (Test-Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\System\DisableTaskMgr")) {
    Write-Host "This script requires Administrator privileges." -ForegroundColor Red
    Exit
}

# Function to Run Disk Cleanup with default settings
Function Run-DiskCleanup {
    Write-Host "Running Disk Cleanup utility..."
    
    # Disk Cleanup command to clean up system files and other junk
    Start-Process cleanmgr.exe -ArgumentList "/sagerun:1" -Wait

    Write-Host "Disk Cleanup has completed."
}

# Check Windows Version
$windowsVersion = [System.Environment]::OSVersion.Version
Write-Host "Windows Version: $windowsVersion"

# For Windows 10 and above, use cleanmgr with preconfigured options
If ($windowsVersion.Major -ge 10) {
    Run-DiskCleanup
}

# For older versions of Windows (7, 8, Server 2008/2012), use alternative method if needed
Else {
    Write-Host "For versions older than Windows 10, this method may not work as cleanmgr might not support all options."
    Write-Host "You can manually run cleanmgr or use DISM and other cleanup utilities."
}

# Run additional cleanup tasks (optional) like clearing the temp files, update cache, etc.
Write-Host "Performing additional cleanup tasks..."

# Clean temporary files
Remove-Item -Path "C:\Windows\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -Path "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue

# Clean Windows Update cache (Optional but useful)
Write-Host "Cleaning Windows Update Cache..."
Stop-Service wuauserv -Force
Remove-Item -Path "C:\Windows\SoftwareDistribution\Download\*" -Recurse -Force -ErrorAction SilentlyContinue
Start-Service wuauserv

Write-Host "Cleanup tasks are complete."
