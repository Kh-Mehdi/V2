@echo off
echo ================================================
echo    CONVERSION YOLOV5 → TENSORFLOW LITE (V2)
echo ================================================

COLOR 0D
echo.
echo 🎯 Conversion amelioree avec verification des chemins

echo.
echo [ETAPE 1/4] Verification de l'emplacement du modele...
cd /d "c:\Users\Mehdi\Desktop\AI\V2\projets-casablanca-nextgen\OCR Panneaux\Code"

set MODEL_PATH="model\yolov5\best_93.pt"
if exist %MODEL_PATH% (
    echo ✅ Modele trouve: %MODEL_PATH%
) else (
    echo ❌ Modele non trouve dans: %MODEL_PATH%
    echo 🔍 Recherche du modele...
    dir /s /b best_93.pt
    pause
    exit /b 1
)

echo.
echo [ETAPE 2/4] Preparation de l'environnement...
cd /d "c:\Users\Mehdi\Desktop\AI\V2\projets-casablanca-nextgen\OCR Panneaux\Code\App\back_detection"

echo Installation des dependances...
python -m pip install torch torchvision ultralytics tensorflow --quiet

echo.
echo [ETAPE 3/4] Conversion...
echo 🔄 Lancement de la conversion avec le bon chemin...

python -c "
import os
import sys
sys.path.append('..')

# Chemin absolu du modele
model_path = r'c:\Users\Mehdi\Desktop\AI\V2\projets-casablanca-nextgen\OCR Panneaux\Code\model\yolov5\best_93.pt'
print(f'Verification du modele: {model_path}')
if os.path.exists(model_path):
    print('✅ Modele trouve!')
    
    # Import et conversion
    import torch
    from ultralytics import YOLO
    
    print('🔄 Chargement du modele...')
    model = YOLO(model_path)
    
    print('🔄 Export vers TensorFlow Lite...')
    model.export(format='tflite', imgsz=640)
    print('✅ Conversion terminee!')
else:
    print('❌ Modele non trouve')
    sys.exit(1)
"

echo.
echo [ETAPE 4/4] Copie vers Flutter...
if exist "..\model\yolov5\best_93.tflite" (
    echo 📁 Copie du modele vers l'app Flutter...
    copy "..\model\yolov5\best_93.tflite" "..\interfaces\assets\best_93.tflite"
    if exist "..\interfaces\assets\best_93.tflite" (
        echo ✅ Modele copie avec succes!
    ) else (
        echo ❌ Erreur lors de la copie
    )
) else (
    echo ❌ Fichier TFLite non genere
)

echo.
echo ================================================
echo    CONVERSION TERMINEE!
echo ================================================
echo.
if exist "..\interfaces\assets\best_93.tflite" (
    echo ✅ Succes! Le modele TFLite est pret pour Flutter
    echo 📱 Vous pouvez maintenant utiliser la vraie detection!
) else (
    echo ❌ Echec de la conversion
    echo 💡 Verifiez les erreurs ci-dessus
)

pause
