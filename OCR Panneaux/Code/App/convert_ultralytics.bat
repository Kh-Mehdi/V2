@echo off
echo ================================================
echo    CONVERSION ULTRALYTICS YOLO → TFLITE
echo ================================================

COLOR 0F
echo.
echo 🎯 Conversion avec Ultralytics YOLO moderne

echo.
echo [ETAPE 1/3] Navigation vers le modele...
cd /d "c:\Users\Mehdi\Desktop\AI\V2\projets-casablanca-nextgen\OCR Panneaux\Code\model\yolov5"

if exist "best_93.pt" (
    echo ✅ Modele best_93.pt trouve
) else (
    echo ❌ Modele best_93.pt non trouve
    pause
    exit /b 1
)

echo.
echo [ETAPE 2/3] Installation Ultralytics...
pip install ultralytics --upgrade --quiet

echo.
echo [ETAPE 3/3] Conversion directe...
echo 🔄 Utilisation de l'API Ultralytics moderne...

python -c "
from ultralytics import YOLO
import os

try:
    print('📁 Chargement du modele...')
    model = YOLO('best_93.pt')
    
    print('🔄 Export vers TensorFlow Lite...')
    results = model.export(format='tflite', imgsz=640, int8=False)
    
    print('✅ Conversion reussie!')
    print(f'📁 Fichier genere: {results}')
    
    # Verification
    if os.path.exists('best_93.tflite'):
        print('✅ Fichier TFLite confirme!')
        
        # Copie vers Flutter
        import shutil
        flutter_path = r'..\..\App\interfaces\assets\best_93.tflite'
        shutil.copy2('best_93.tflite', flutter_path)
        print(f'📱 Copie vers Flutter: {flutter_path}')
        
        if os.path.exists(flutter_path):
            print('✅ Installation Flutter reussie!')
        else:
            print('❌ Erreur copie Flutter')
    else:
        print('❌ Fichier TFLite non trouve')
        
except Exception as e:
    print(f'❌ Erreur: {e}')
    import traceback
    traceback.print_exc()
"

echo.
echo ================================================
echo    VERIFICATION FINALE
echo ================================================

if exist "best_93.tflite" (
    echo ✅ Fichier TFLite genere!
    dir best_93.tflite
) else (
    echo ❌ Fichier TFLite non genere
)

if exist "..\..\App\interfaces\assets\best_93.tflite" (
    echo ✅ Modele installe dans Flutter!
    echo.
    echo 🎉 SUCCES! Votre modele est pret pour Flutter!
    echo 📱 Vous pouvez maintenant utiliser la vraie detection TFLite!
) else (
    echo ❌ Modele non installe dans Flutter
)

pause
