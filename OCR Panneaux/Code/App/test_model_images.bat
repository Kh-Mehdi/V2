@echo off
echo ================================================
echo    TEST MODELE YOLOV5 - IMAGE FIXE
echo ================================================

COLOR 0B
echo.
echo 🖼️  Test du modele YOLOv5 sur images

echo.
echo [ETAPE 1/2] Preparation...
cd /d "c:\Users\Mehdi\Desktop\AI\V2\projets-casablanca-nextgen\OCR Panneaux\Code\model\yolov5"

echo Verification du modele...
if exist "best_93.pt" (
    echo ✅ Modele best_93.pt trouve
) else (
    echo ❌ Modele best_93.pt non trouve
    pause
    exit /b 1
)

echo.
echo [ETAPE 2/2] Test sur images d'exemple...
echo.
echo 📂 Sources de test disponibles:
echo    • data/images/ (si disponible)
echo    • Dossier courant
echo    • Ou drag-and-drop d'une image
echo.

echo 🚀 Test avec les images par defaut...
python detect.py --weights best_93.pt --source data/images --view-img --save-txt --conf 0.4

echo.
echo 📊 Pour tester avec vos propres images:
echo    python detect.py --weights best_93.pt --source "chemin/vers/votre/image.jpg" --view-img
echo.
echo Les resultats sont dans 'runs/detect/'
pause
