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
  echo Creating a private Python environment for the EXE build...
  py -3.12 -m venv .venv >nul 2>nul
  if errorlevel 1 py -3.11 -m venv .venv
  if errorlevel 1 goto failed
)
echo Installing build dependencies...
".venv\Scripts\python.exe" -m pip install --upgrade pip
".venv\Scripts\python.exe" -m pip install -r requirements.txt
if errorlevel 1 goto failed
echo Building a standalone one-file Windows application. This can take several minutes.
".venv\Scripts\python.exe" -m PyInstaller --noconfirm --clean --onefile --windowed --name DjangoAutoMLStudio --add-data "templates;templates" --collect-all django --collect-all sklearn --collect-all pandas --collect-all numpy --collect-all matplotlib --collect-all seaborn --collect-all scipy --collect-all threadpoolctl --collect-all joblib --hidden-import django.contrib.sessions --hidden-import django.contrib.messages --hidden-import django.contrib.staticfiles --hidden-import analyzer.apps --hidden-import analyzer.views --hidden-import automl_studio.settings --hidden-import automl_studio.urls --hidden-import automl_studio.wsgi --hidden-import sklearn.ensemble._forest --hidden-import sklearn.preprocessing._encoders --hidden-import sklearn.compose._column_transformer --hidden-import openpyxl --collect-all openpyxl --hidden-import xlrd --collect-all xlrd run_app.py
if errorlevel 1 goto failed
echo.
echo BUILD COMPLETE: dist\DjangoAutoMLStudio.exe
echo Copy this single EXE anywhere on your Windows PC and double-click it.
pause
exit /b 0
:failed
echo Build failed. Read the error above, then try again.
pause
exit /b 1
