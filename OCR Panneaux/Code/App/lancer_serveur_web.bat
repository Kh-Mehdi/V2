@echo off
echo ================================================
echo     Serveur Web Local - Detection Panneaux
echo ================================================
echo.

cd /d "%~dp0"

REM Vérifier si Python est installé
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Python n'est pas installé ou pas dans le PATH
    echo Veuillez installer Python depuis https://python.org
    pause
    exit /b 1
)

echo ✅ Python détecté

REM Installer Flask si nécessaire
python -c "import flask" >nul 2>&1
if %errorlevel% neq 0 (
    echo 📦 Installation de Flask...
    pip install flask
)

REM Vérifier les autres dépendances
python -c "import cv2, numpy, PIL" >nul 2>&1
if %errorlevel% neq 0 (
    echo 📦 Installation des dépendances manquantes...
    pip install opencv-python numpy pillow
)

REM Vérifier si le modèle existe
if not exist "model\yolov5\best_93.pt" (
    echo ❌ Le modèle best_93.pt n'est pas trouvé dans model\yolov5\
    echo Assurez-vous que le modèle est présent
    pause
    exit /b 1
)

echo ✅ Dépendances vérifiées
echo ✅ Modèle trouvé
echo.
echo 🌐 Lancement du serveur web local...
echo 📍 Le serveur sera accessible sur: http://localhost:5000
echo 🛑 Appuyez sur Ctrl+C pour arrêter le serveur
echo.

python serveur_web_local.py

pause
