@echo off
setlocal

set "projectName=app"
set "repoUrl=https://github.com/bukkybyte/library-app.git"
set "projectRoot=C:\"
set "projectPath=%projectRoot%%projectName%"
set "new_allowed_host=172.200.1.80" 

echo Checking for Git...
where git >nul 2>&1
if errorlevel 1 (
    echo Git is not installed.
    echo Please download and install Git from: https://git-scm.com/downloads
    echo After installing Git, please run this script again.
    pause
    goto :error
)

echo Creating project folder: %projectPath%
if exist "%projectPath%" (
    echo Error: Folder "%projectPath%" already exists.
    goto :continue
)
mkdir "%projectPath%" || (
    echo Error: Failed to create folder "%projectPath%".
    goto :continue
)

:continue
pushd "%projectPath%"

echo Cloning repository...
git clone "%repoUrl%" . || (
    echo Error: Failed to clone repository. Check the URL and your internet connection.
    goto :continue2
)

:continue2

echo Editing .env file...
if exist .env (
    echo Adding ALLOWED_HOSTS to .env file...
    echo. >> .env 
    echo ALLOWED_HOSTS=localhost,127.0.0.1,%new_allowed_host% >> .env 
) else (
    echo No .env file found. Skipping editing.
)

echo Creating virtual environment...
python -m venv .venv || (
    echo Error: Failed to create virtual environment. Ensure Python is installed and in your PATH.
    goto :continue3
)

:continue3

echo Activating virtual environment...
if exist ".venv\Scripts\activate.bat" (
    call .venv\Scripts\activate.bat
) else if exist ".venv\Scripts\activate" (
    call .venv\Scripts\activate
) else (
    echo Error: Could not find activation script.
    goto :continue4
)
:continue4

echo Installing requirements...
pip install -r requirements.txt || (
    echo Error: Failed to install requirements. Check your requirements.txt file.
    goto :end
)

:end
echo.
if exist manage.py (
    echo Project setup (mostly) complete!
    echo You can now navigate to the project directory: cd "%projectPath%"
    if exist ".venv\Scripts\activate.bat" (
        echo Then activate the virtual environment: "%projectPath%\.venv\Scripts\activate"
    ) else if exist ".venv\Scripts\activate" (
        echo Then activate the virtual environment: source "%projectPath%/.env/bin/activate"
    )
    echo and run the Django development server: python manage.py runserver
) else (
    echo Project setup had some errors. Please review the messages above.
)
echo.

popd

goto :eof

:error
echo.
echo An error occurred before project creation.
echo.
pause
exit /b 1

:eof
pause
endlocal