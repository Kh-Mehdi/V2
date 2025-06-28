@echo off
echo ================================================
echo    CONVERSION VERS TENSORFLOW LITE
echo ================================================

COLOR 0E
echo.
echo 🔄 Conversion du modele YOLOv5 vers TensorFlow Lite...
echo    (Plus besoin de Flask apres cette conversion!)

cd /d "c:\Users\Mehdi\Desktop\AI\V2\projets-casablanca-nextgen\OCR Panneaux\Code\App\back_detection"

echo.
echo 📦 Installation des dependances...
python -m pip install -q torch torchvision ultralytics tensorflow

echo.
echo 🔄 Lancement de la conversion...
python convert_to_tflite.py

if errorlevel 1 (
    echo ❌ Erreur lors de la conversion
    pause
    exit /b 1
)

echo.
echo ✅ Conversion terminee!
echo.
echo 📱 Prochaines etapes:
echo    1. Modifier pubspec.yaml (ajouter tflite_flutter)
echo    2. Utiliser TFLiteDetectionService au lieu de DetectionService
echo    3. Plus besoin de Flask!
echo.
echo 💡 Avantages:
echo    ✅ Fonctionne hors ligne
echo    ✅ Plus rapide (pas de reseau)
echo    ✅ Plus simple a deployer
echo    ✅ Meilleure securite

pause
