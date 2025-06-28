@echo off
echo ================================================
echo    CONVERSION DIRECTE YOLOV5 → TFLITE
echo ================================================

COLOR 0C
echo.
echo 🚀 Conversion directe avec export.py de YOLOv5

echo.
echo [ETAPE 1/3] Navigation vers YOLOv5...
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
echo [ETAPE 2/3] Installation des dependances...
pip install ultralytics tensorflow --quiet

echo.
echo [ETAPE 3/3] Export TensorFlow Lite...
echo 🔄 Utilisation du script export.py officiel...

python export.py --weights best_93.pt --include tflite --img 640

if exist "best_93.tflite" (
    echo ✅ Conversion reussie!
    echo 📁 Copie vers Flutter...
    copy "best_93.tflite" "..\..\App\interfaces\assets\best_93.tflite"
    
    if exist "..\..\App\interfaces\assets\best_93.tflite" (
        echo ✅ Modele installe dans Flutter!
    ) else (
        echo ❌ Erreur lors de la copie vers Flutter
    )
) else (
    echo ❌ Echec de la conversion
)

echo.
echo ================================================
echo    CONVERSION TERMINEE
echo ================================================
pause
