@echo off
echo ================================================
echo    TEST MODELE YOLOV5 - WEBCAM EN TEMPS REEL
echo ================================================

COLOR 0A
echo.
echo 🎯 Test du modele YOLOv5 avec webcam

echo.
echo [ETAPE 1/3] Preparation de l'environnement Python...
cd /d "c:\Users\Mehdi\Desktop\AI\V2\projets-casablanca-nextgen\OCR Panneaux\Code\model\yolov5"

echo Verification des dependances...
pip install -r requirements.txt --quiet
if errorlevel 1 (
    echo ❌ Erreur installation dependances
    echo 💡 Essayez: pip install torch torchvision opencv-python
    pause
    exit /b 1
) else (
    echo ✅ Dependances installees
)

echo.
echo [ETAPE 2/3] Verification du modele...
if exist "best_93.pt" (
    echo ✅ Modele best_93.pt trouve
) else (
    echo ❌ Modele best_93.pt non trouve
    echo 💡 Verifiez que le fichier existe dans ce dossier
    pause
    exit /b 1
)

echo.
echo [ETAPE 3/3] Lancement de la detection webcam...
echo.
echo ================================================
echo    DETECTION EN TEMPS REEL ACTIVEE
echo ================================================
echo.
echo 📸 Instructions:
echo    • La webcam va s'ouvrir automatiquement
echo    • Pointez vers des panneaux de signalisation
echo    • Les detections apparaitront en temps reel
echo    • Appuyez sur 'q' pour quitter
echo.
echo 🚀 Lancement en cours...

python detect.py --weights best_93.pt --source 0 --view-img --save-txt --conf 0.4

echo.
echo 📊 Les resultats sont sauvegardes dans le dossier 'runs/detect/'
echo Test termine.
pause
