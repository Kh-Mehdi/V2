@echo off
echo ================================================
echo    SERVEUR DE DETECTION YOLOV5 - DEMARRAGE
echo ================================================

echo Deplacement vers le dossier back_detection...
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
echo Verification de l'existence du modele...
if exist "..\..\model\yolov5\best_93.pt" (
    echo ✓ Modele best_93.pt trouve
) else (
    echo ERREUR: Le fichier best_93.pt n'est pas trouve
    echo Verification des chemins alternatifs...
    if exist "..\model\yolov5\best_93.pt" (
        echo ✓ Modele trouve dans ..\model\yolov5\best_93.pt
    ) else (
        echo ❌ Modele non trouve dans les emplacements standard
        echo Veuillez placer best_93.pt dans le dossier model/yolov5/
        pause
        exit /b 1
    )
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
echo 4. Demarrage du serveur Flask...
echo Le serveur va demarrer sur http://localhost:5000
echo Appuyez sur Ctrl+C pour arreter le serveur
echo ================================================
python app.py

pause
