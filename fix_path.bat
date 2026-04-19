@echo off
REM This script must be run as Administrator
REM Right-click and select "Run as administrator"

echo Checking if running as Administrator...
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo This script requires Administrator privileges.
    echo Please right-click this file and select "Run as administrator"
    pause
    exit /b 1
)

echo Adding PowerShell to system PATH...
setx PATH "C:\Windows\System32\WindowsPowerShell\v1.0;%PATH%" /M

if %errorLevel% equ 0 (
    echo.
    echo ✓ Successfully added PowerShell path to system PATH
    echo.
    echo NOTE: You may need to restart VS Code or your terminal for changes to take effect
    echo.
) else (
    echo Failed to update PATH
)

pause
