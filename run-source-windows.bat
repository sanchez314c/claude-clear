@echo off
setlocal enabledelayedexpansion

REM Claude Clear - Manual Launch Script for Windows
REM Run Claude Clear manually without installing the service

set RED=[91m
set GREEN=[92m
set YELLOW=[93m
set BLUE=[94m
set PURPLE=[95m
set CYAN=[96m
set WHITE=[97m
set GRAY=[90m
set NC=[0m

echo.
echo %PURPLE%╔══════════════════════════════════════════════════════════════════════════════╗%NC%
echo %PURPLE%║                                                                              ║%NC%
echo %PURPLE%║    ████████╗ █████╗ ███╗   ██╗██╗  ██╗    ██████╗ ███████╗ █████╗        ║%NC%
echo %PURPLE%║    ╚══██╔══╝██╔══██╗████╗  ██║██║ ██╔╝    ██╔══██╗██╔════╝██╔══██╗       ║%NC%
echo %PURPLE%║       ██║   ███████║██╔██╗ ██║█████╔╝     ██████╔╝█████╗  ███████║       ║%NC%
echo %PURPLE%║       ██║   ██╔══██║██║╚██╗██║██╔═██╗     ██╔══██╗██╔══╝  ██╔══██║       ║%NC%
echo %PURPLE%║       ██║   ██║  ██║██║ ╚████║██║  ██╗    ██║  ██║███████╗██║  ██║       ║%NC%
echo %PURPLE%║       ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝    ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝       ║%NC%
echo %PURPLE%║                                                                              ║%NC%
echo %PURPLE%║                          🧹  Claude Clear                                    ║%NC%
echo %PURPLE%║                Clean Claude Code's bloated configuration file                 ║%NC%
echo %PURPLE%║                                                                              ║%NC%
echo %PURPLE%╚══════════════════════════════════════════════════════════════════════════════╝%NC%
echo.

REM Get script directory
set "SCRIPT_DIR=%~dp0"
cd /d "%SCRIPT_DIR%"

echo %CYAN%[%TIME%]%NC% Initializing Claude Clear...
echo.

REM Check Python installation
where python >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo %RED%[X] Python 3 is not installed%NC%
    echo %GRAY%    Download from: https://python.org%NC%
    echo.
    pause
    exit /b 1
)

REM Check Python version
for /f "tokens=2" %%i in ('python --version 2^>^&1') do set PYTHON_VERSION=%%i
echo %GREEN%[OK]%NC% Python %PYTHON_VERSION% detected
echo.

REM Check if virtual environment exists
if exist "venv\Scripts\activate.bat" (
    echo %BLUE%[%TIME%]%NC% Activating virtual environment...
    call venv\Scripts\activate.bat
    echo %GREEN%[OK]%NC% Virtual environment activated
    echo.
) else (
    echo %YELLOW%[!] No virtual environment found%NC%
    echo %GRAY%    Creating virtual environment...%NC%
    python -m venv venv
    if %ERRORLEVEL% NEQ 0 (
        echo %RED%[X] Failed to create virtual environment%NC%
        pause
        exit /b 1
    )
    call venv\Scripts\activate.bat
    echo %GREEN%[OK]%NC% Virtual environment created and activated
    echo.

    REM Install dependencies
    echo %BLUE%[%TIME%]%NC% Installing dependencies...
    pip install -r requirements.txt -q
    if %ERRORLEVEL% NEQ 0 (
        echo %RED%[X] Failed to install dependencies%NC%
        pause
        exit /b 1
    )
    echo %GREEN%[OK]%NC% Dependencies installed
    echo.
)

REM Check dependencies
if not exist "venv\Lib\site-packages\click" (
    echo %BLUE%[%TIME%]%NC% Installing dependencies...
    pip install -r requirements.txt -q
    if %ERRORLEVEL% NEQ 0 (
        echo %RED%[X] Failed to install dependencies%NC%
        pause
        exit /b 1
    )
    echo %GREEN%[OK]%NC% Dependencies installed
    echo.
)

REM Run the cleaner
echo %CYAN%[%TIME%]%NC% Starting Claude Clear cleaner...
echo.
python src\cleaner.py

if %ERRORLEVEL% EQU 0 (
    echo.
    echo %GREEN%[OK]%NC% Cleanup completed successfully
) else (
    echo.
    echo %RED%[X]%NC% Cleanup encountered errors
)

echo.
echo %GRAY%Press any key to exit...%NC%
pause >nul
