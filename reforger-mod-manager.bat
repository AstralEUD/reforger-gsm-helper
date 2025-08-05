@echo off
setlocal enabledelayedexpansion

REM Reforger Mod Manager - Windows CLI Tool
REM This is a Windows wrapper for the Linux bash script

echo ================================================
echo     Reforger Mod Manager CLI Tool
echo ================================================
echo.

REM Check if WSL is available
wsl --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] WSL (Windows Subsystem for Linux) is required to run this tool.
    echo Please install WSL and a Linux distribution first.
    echo.
    echo Installation guide:
    echo https://docs.microsoft.com/en-us/windows/wsl/install
    pause
    exit /b 1
)

echo [INFO] Running Reforger Mod Manager through WSL...
echo.

REM Convert Windows path to WSL path
set "SCRIPT_DIR=%~dp0"
set "WSL_SCRIPT_DIR=/mnt/c%SCRIPT_DIR:C:=%"
set "WSL_SCRIPT_DIR=%WSL_SCRIPT_DIR:\=/%"

REM Run the bash script in WSL
wsl bash "%WSL_SCRIPT_DIR%reforger-mod-manager.sh"

pause
