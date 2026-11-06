# Django AutoML Studio

A local-first Django web application for uploading CSV/Excel datasets, cleaning data, creating EDA charts, training a baseline ML model, checking evaluation metrics, and making custom predictions.

## Quick start on Windows

### Option A — one-click launcher (requires Python 3.11 or 3.12)
1. Install Python 3.11 or 3.12 from https://www.python.org/downloads/windows/ and select **Add Python to PATH**.
2. Double-click `run_once_setup.bat`.
3. The first launch creates a local virtual environment, installs packages and opens the app in your browser. Later launches use the same setup.

### Option B — build one standalone EXE
1. Install Python 3.11 or 3.12 on a Windows PC.
2. Double-click `build_windows_exe.bat`.
3. When it completes, run `dist\DjangoAutoMLStudio.exe`. This EXE contains the app and Python dependencies; the browser opens automatically.

The EXE build must be run on Windows. PyInstaller does not cross-compile a Windows EXE from a Linux environment. The app data (uploads, saved models and local session database) is stored under `%LOCALAPPDATA%\DjangoAutoMLStudio` and remains separate from the EXE.

## Use the app
1. Download `train.csv` from Kaggle's official Titanic competition page: https://www.kaggle.com/competitions/titanic/data (sign in and accept the competition rules if prompted).
2. In AutoML Studio, upload the downloaded `train.csv` (891 rows).
3. Choose `Survived` as the target column and leave task type as **Auto detect** or choose **Classification**.
4. Click **Run analysis**. The app removes duplicate rows, removes empty columns and rows with missing target values, caps numeric outliers using the IQR rule, imputes missing numeric values with the median, imputes missing categorical values with the mode, scales numerical features, one-hot encodes categorical features, and trains a Random Forest model.
5. Review the EDA charts and held-out test metrics. Use the prediction form to enter a new passenger profile.

You can also upload your own `.csv`, `.xlsx` or `.xls` data. For the assignment requirement, use a real dataset with at least 500 rows and both numerical and categorical columns. The app accepts smaller datasets for experimentation but displays a warning because they do not meet that assignment criterion.

## Included workflow

- File upload: CSV and Excel, up to 25 MB.
- Data summary: rows, columns, missing values, duplicates, first 8 records.
- Cleaning: duplicate removal, all-empty column removal, missing-target row removal, numeric IQR capping.
- Transformation: median/mode imputation, StandardScaler, OneHotEncoder.
- Feature selection: identifier/high-cardinality text exclusion plus Random Forest feature importance.
- EDA: target distribution, feature distributions, box plots, scatter plot, correlation heatmap.
- ML: automatic or manual classification/regression task selection; Random Forest train/test evaluation.
- Prediction: dynamic form based on selected feature columns.

## Important notes

- The app is intended for localhost use on your own PC. It binds only to `127.0.0.1`; do not expose it directly to the public internet.
- Models and uploads are stored locally. Use the **Start over** button to clear the current browser session; files remain in the local app-data folder until you remove them.
- The Random Forest is a baseline model. Metrics depend on the dataset, target, leakage, class balance and split; they are not a guarantee of real-world performance.
- High-cardinality text fields and identifier-like columns are excluded automatically. The app lists excluded fields in the summary.
- It is not a production multi-user deployment and has no authentication because it is designed to run locally.

## Project structure

```text
DjangoAutoMLStudio/
├── automl_studio/       # Django settings, URLs and WSGI entry point
├── analyzer/            # Upload views, preprocessing, EDA, model training, prediction
├── templates/analyzer/  # Responsive dashboard UI
├── run_app.py           # Local desktop launcher
├── run_once_setup.bat   # First-run setup and launcher
├── build_windows_exe.bat# Builds a single-file Windows EXE
└── requirements.txt
```
