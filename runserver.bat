@echo off
setlocal

set "projectName=app"
set "projectRoot=C:\"
set "projectPath=%projectRoot%%projectName%"

echo Navigating to project directory: %projectPath%
cd /d "%projectPath%"

:: Activate virtual environment
echo Activating virtual environment...
if exist ".venv\Scripts\activate.bat" (
    call .venv\Scripts\activate.bat
) else if exist ".venv\Scripts\activate" (
    call .venv\Scripts\activate
) else (
    echo Error: Virtual environment activation failed.
    pause
    exit /b 1
)

:: Start both processes in the same window
echo Starting Django server and backup bot...
echo [CTRL+C] to stop both processes

:: Run backup bot as a background process
start /B python manage.py backup_bot --interval-days=7 --retention-months=3

:: Run development server (foreground)
daphne -b 172.16.0.191 -p 9000 library.asgi:application

:: Cleanup when CTRL+C is pressed
:shutdown
taskkill /f /im python.exe >nul 2>&1
echo Both processes have been stopped.
pause
