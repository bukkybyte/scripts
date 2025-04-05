@echo off
REM Batch script to restore the database from a backup file in C:\backups

REM Set the path to your Django project directory
set PROJECT_DIR=C:\app

REM Set the name of the backup file (replace with the actual filename)
set BACKUP_FILE=db_backup_2025-04-05.sqlite3.gz

REM Set the backup folder path
set BACKUP_DIR=C:\backups

REM Navigate to the Django project directory
cd /d %PROJECT_DIR%

REM Check if the backup file exists in C:\backups
if not exist "%BACKUP_DIR%\%BACKUP_FILE%" (
    echo ERROR: Backup file "%BACKUP_DIR%\%BACKUP_FILE%" not found.
    pause
    exit /b 1
)

REM Activate the virtual environment (if applicable)
REM Replace "venv" with the name of your virtual environment folder
call .venv\Scripts\activate.bat

REM Run the Django management command to restore the database
python manage.py restore_db %BACKUP_FILE%

REM Display a success message
echo.
echo ============================================
echo Database restoration completed successfully!
echo ============================================

REM Deactivate the virtual environment
deactivate

REM Pause to keep the terminal open
pause
