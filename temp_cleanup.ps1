# PowerShell Script to clean %temp% and C:\Windows\Temp folders with Admin Rights

# Check if the script is running as Administrator
If (-NOT (Test-Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\System\DisableTaskMgr")) {
    Write-Host "This script requires Administrator privileges." -ForegroundColor Red
    Exit
}

# Function to clean the %TEMP% folder (User Temp folder)
Function Clean-UserTemp {
    $userTempPath = $env:TEMP
    Write-Host "Cleaning user temp folder: $userTempPath"

    # Remove files in the user's TEMP directory
    Try {
        Remove-Item -Path "$userTempPath\*" -Recurse -Force -ErrorAction SilentlyContinue
        Write-Host "User temp folder cleaned: $userTempPath" -ForegroundColor Green
    }
    Catch {
        Write-Host "Failed to clean user temp folder: $userTempPath" -ForegroundColor Red
    }
}

# Function to clean the C:\Windows\Temp folder (System-wide Temp folder)
Function Clean-SystemTemp {
    $systemTempPath = "C:\Windows\Temp"
    Write-Host "Cleaning system temp folder: $systemTempPath"

    # Remove files in the system's TEMP directory
    Try {
        Remove-Item -Path "$systemTempPath\*" -Recurse -Force -ErrorAction SilentlyContinue
        Write-Host "System temp folder cleaned: $systemTempPath" -ForegroundColor Green
    }
    Catch {
        Write-Host "Failed to clean system temp folder: $systemTempPath" -ForegroundColor Red
    }
}

# Clean User's Temp folder
Clean-UserTemp

# Clean System Temp folder (C:\Windows\Temp)
Clean-SystemTemp

Write-Host "Cleanup completed." -ForegroundColor Green
