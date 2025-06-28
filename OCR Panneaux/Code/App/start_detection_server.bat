@echo off
echo ================================================
echo    SERVEUR DE DETECTION YOLOV5 - DEMARRAGE
echo ================================================

cd /d "c:\Users\Mehdi\Desktop\AI\V2\projets-casablanca-nextgen\OCR Panneaux\Code\App\back_detection"

echo.
echo 1. Verification de Python...
python --version
if errorlevel 1 (
    echo ERREUR: Python n'est pas installe ou non dans le PATH
    pause
    exit /b 1
)

echo.
echo 2. Verification du fichier modele...
if not exist "..\..\model\yolov5\best_93.pt" (
    echo ERREUR: Le fichier best_93.pt n'est pas trouve
    echo Chemin attendu: ..\..\model\yolov5\best_93.pt
    echo Chemin actuel: %cd%
    dir ..\..\model\yolov5\best_93.pt
    pause
    exit /b 1
) else (
    echo ✓ Modele best_93.pt trouve
)

echo.
echo 3. Installation des dependances...
python -m pip install -q flask flask-cors torch torchvision opencv-python pillow numpy ultralytics requests
if errorlevel 1 (
    echo ERREUR: Impossible d'installer les dependances
    pause
    exit /b 1
)

echo.
echo 4. Test rapide du serveur...
python test_server.py
if errorlevel 1 (
    echo Test du serveur en cours...
)

echo.
echo 5. Demarrage du serveur Flask...
echo Le serveur va demarrer sur http://localhost:5000
echo Appuyez sur Ctrl+C pour arreter le serveur
echo ================================================
python app.py

pause
