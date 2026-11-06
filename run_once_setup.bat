@echo off
setlocal
cd /d "%~dp0"
where py >nul 2>nul
if errorlevel 1 (
  echo Python launcher was not found. Install Python 3.11 or 3.12 and enable Add Python to PATH.
  pause
  exit /b 1
)
if not exist ".venv\Scripts\python.exe" (
  echo Creating a private Python environment for this project...
  py -3.12 -m venv .venv >nul 2>nul
  if errorlevel 1 py -3.11 -m venv .venv
  if errorlevel 1 goto failed
)
echo Installing or checking required packages...
".venv\Scripts\python.exe" -m pip install --upgrade pip
".venv\Scripts\python.exe" -m pip install -r requirements.txt
if errorlevel 1 goto failed
echo Starting Django AutoML Studio...
".venv\Scripts\python.exe" run_app.py
exit /b 0
:failed
echo Setup failed. Check your internet connection and Python installation, then run this file again.
pause
exit /b 1
