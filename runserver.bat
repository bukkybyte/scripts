@echo off
timeout /t 300 /nobreak  >nul  :: Waits 300 seconds (5 minutes)
start "" "C:\app\server.bat"
