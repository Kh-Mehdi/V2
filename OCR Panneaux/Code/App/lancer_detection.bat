@echo off
echo ================================================
echo    Systeme de Detection Locale - Panneaux
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

REM Vérifier si le modèle existe
if not exist "model\yolov5\best_93.pt" (
    echo ❌ Le modèle best_93.pt n'est pas trouvé dans model\yolov5\
    echo Assurez-vous que le modèle est présent
    pause
    exit /b 1
)

echo ✅ Python détecté
echo ✅ Modèle trouvé

echo.
echo Choisissez une option:
echo 1. Détection sur une image
echo 2. Détection webcam en temps réel
echo 3. Test du modèle
echo 4. Installer les dépendances
echo 5. Quitter
echo.

set /p choice="Votre choix (1-5): "

if "%choice%"=="1" goto detect_image
if "%choice%"=="2" goto detect_webcam
if "%choice%"=="3" goto test_model
if "%choice%"=="4" goto install_deps
if "%choice%"=="5" goto end

echo Choix invalide
goto end

:detect_image
echo.
set /p image_path="Entrez le chemin vers l'image: "
if not exist "%image_path%" (
    echo ❌ Image non trouvée: %image_path%
    pause
    goto end
)
echo.
echo 🔍 Détection en cours...
python detection_locale.py --source "%image_path%" --save --conf 0.25
echo.
echo ✅ Détection terminée! Image annotée sauvegardée.
pause
goto end

:detect_webcam
echo.
echo 🎥 Lancement de la détection webcam...
echo Appuyez sur 'q' dans la fenêtre vidéo pour quitter
python detection_locale.py --source 0 --conf 0.25
goto end

:test_model
echo.
echo 🧪 Test du modèle...
python -c "
from detection_locale import DetectionLocale
try:
    detector = DetectionLocale()
    print('✅ Modèle chargé avec succès!')
    print(f'Classes détectées: {len(detector.classes)}')
    for i, cls in enumerate(detector.classes):
        print(f'  {i}: {cls}')
except Exception as e:
    print(f'❌ Erreur: {e}')
"
pause
goto end

:install_deps
echo.
echo 📦 Installation des dépendances...
echo.
pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cpu
pip install opencv-python
pip install numpy
pip install pathlib
pip install ultralytics

echo.
echo Dépendances YOLOv5...
cd model\yolov5
pip install -r requirements.txt
cd ..\..

echo ✅ Installation terminée!
pause
goto end

:end
echo.
echo Au revoir!
pause
