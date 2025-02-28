@echo off
setlocal

set "projectName=app"
set "projectRoot=C:\"
set "projectPath=%projectRoot%%projectName%"

echo Navigating to project directory: cd "%projectPath%"
cd "%projectPath%"

echo Activating virtual environment...
if exist ".venv\Scripts\activate.bat" (
    call .venv\Scripts\activate.bat
) else if exist ".venv\Scripts\activate" (
    call .venv\Scripts\activate
) else (
    echo Error: Could not find activation script.
    goto :error
)

echo Running development server...
python manage.py runserver 10.167.47.154:9000

:end
echo.
echo Press any key to exit...
pause

goto :eof

:error
echo.
echo An error occurred while activating the virtual environment.
echo.
pause
exit /b 1

:eof
endlocal
