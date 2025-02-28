@echo off
setlocal

set "projectName=app"
set "repoUrl=https://github.com/bukkybyte/library-app.git"
set "projectRoot=C:\"
set "projectPath=%projectRoot%%projectName%"
set "new_allowed_host=10.167.47.154"

echo Step 1: Checking for Git...
where git >nul 2>&1
if errorlevel 1 (
    echo Git is not installed.
    echo Please download and install Git from: https://git-scm.com/downloads
    pause
    goto :error
)

echo Step 2: Checking for Python...
where python >nul 2>&1
if errorlevel 1 (
    echo Python is not installed.
    echo Please download and install Python from: https://www.python.org/downloads/
    pause
    goto :error
)

echo Step 3: Checking project folder...
if exist "%projectPath%" (
    echo Project folder "%projectPath%" already exists. Assuming update mode.
    goto :update
) else (
    echo Creating project folder: %projectPath%
    mkdir "%projectPath%" || (
        echo Error: Failed to create folder "%projectPath%".
        goto :error
    )
)

:clone
pushd "%projectPath%"

echo Step 4: Cloning repository...
git clone "%repoUrl%" . || (
    echo Error: Failed to clone repository. Check the URL and your internet connection.
    goto :error
)
goto :post_clone

:update
pushd "%projectPath%"

echo Step 4: Updating repository...
git pull || (
    echo Error: Failed to pull latest changes. Check your internet connection.
    goto :error
)

:post_clone

echo Step 5: Editing .env file...
if exist .env (
    echo .env file exists. Removing existing ALLOWED_HOSTS line...
    findstr /v /i "ALLOWED_HOSTS" .env > .env.temp
    move /y .env.temp .env >nul
) else (
    echo Creating .env file...
)

echo Adding new ALLOWED_HOSTS line...
echo ALLOWED_HOSTS=localhost,127.0.0.1,%new_allowed_host% >> .env

echo Step 6: Creating or updating virtual environment...
if exist ".venv" (
    echo Virtual environment already exists. Skipping creation.
) else (
    echo Creating virtual environment...
    python -m venv .venv || (
        echo Error: Failed to create virtual environment. Ensure Python is installed and in your PATH.
        goto :error
    )
)

echo Step 7: Activating virtual environment...
if exist ".venv\Scripts\activate.bat" (
    call .venv\Scripts\activate.bat
) else if exist ".venv\Scripts\activate" (
    call .venv\Scripts\activate
) else (
    echo Error: Could not find activation script.
    goto :error
)

echo Step 8: Installing or updating requirements...
if not exist requirements.txt (
    echo Error: requirements.txt not found.
    goto :error
)
pip install -r requirements.txt || (
    echo Error: Failed to install requirements. Check your requirements.txt file.
    goto :error
)

:end
echo.
if exist manage.py (
    echo Project setup/update complete!
    echo You can now navigate to the project directory: cd "%projectPath%"
    if exist ".venv\Scripts\activate.bat" (
        echo Then activate the virtual environment: "%projectPath%\.venv\Scripts\activate"
    ) else if exist ".venv\Scripts\activate" (
        echo Then activate the virtual environment: source "%projectPath%/.env/bin/activate"
    )
    echo and run the Django development server: python manage.py runserver
) else (
    echo Project setup/update had some errors. Please review the messages above.
)
echo.

popd

goto :eof

:error
echo.
echo An error occurred during project setup/update.
echo.
pause
exit /b 1

:eof
pause
endlocal
