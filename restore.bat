@echo off
REM Batch script to restore the database from a selected backup file

REM Set the path to your Django project directory
set PROJECT_DIR=C:\app

REM Set the default backup folder path
set BACKUP_DIR=C:\backups

REM Navigate to the backup directory
cd /d %BACKUP_DIR%

REM List available backup files
echo Available backup files in %BACKUP_DIR%:
dir /b *.sqlite3.gz *.bak *.backup *.db 2>nul

echo.
set /p BACKUP_FILE="Enter the backup filename: "

REM Check if file exists
if not exist "%BACKUP_DIR%\%BACKUP_FILE%" (
    echo ERROR: Backup file "%BACKUP_DIR%\%BACKUP_FILE%" not found.
    pause
    exit /b 1
)

REM Continue with restoration
cd /d %PROJECT_DIR%
call .venv\Scripts\activate.bat
python manage.py restore_db "%BACKUP_DIR%\%BACKUP_FILE%"
deactivate

echo.
echo ============================================
echo Database restoration completed successfully!
echo ============================================
pause
