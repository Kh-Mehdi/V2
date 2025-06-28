@echo off
echo ================================================
echo    VERIFICATION MODELE TENSORFLOW LITE
echo ================================================

COLOR 0A
echo.
echo 🔍 Verification du modele TFLite pour Flutter

echo.
echo [VERIFICATION 1/3] Fichier TFLite dans YOLOv5...
cd /d "c:\Users\Mehdi\Desktop\AI\V2\projets-casablanca-nextgen\OCR Panneaux\Code\model\yolov5"

if exist "best_93.tflite" (
    echo ✅ Fichier TFLite trouve dans YOLOv5
    dir best_93.tflite
) else (
    echo ❌ Fichier TFLite non trouve dans YOLOv5
)

echo.
echo [VERIFICATION 2/3] Fichier TFLite dans Flutter...
cd /d "c:\Users\Mehdi\Desktop\AI\V2\projets-casablanca-nextgen\OCR Panneaux\Code\App\interfaces"

if exist "assets\best_93.tflite" (
    echo ✅ Fichier TFLite trouve dans Flutter
    dir assets\best_93.tflite
) else (
    echo ❌ Fichier TFLite non trouve dans Flutter
    echo 💡 Executez convert_ultralytics.bat pour le creer
)

echo.
echo [VERIFICATION 3/3] Test de chargement TFLite...
if exist "assets\best_93.tflite" (
    echo 🧪 Test de chargement du modele TFLite...
    python -c "
try:
    import tensorflow as tf
    print('✅ TensorFlow disponible')
    
    # Charger le modele TFLite
    interpreter = tf.lite.Interpreter(model_path='assets/best_93.tflite')
    interpreter.allocate_tensors()
    
    # Informations du modele
    input_details = interpreter.get_input_details()
    output_details = interpreter.get_output_details()
    
    print('✅ Modele TFLite charge avec succes!')
    print(f'📊 Entree: {input_details[0][\"shape\"]}')
    print(f'📊 Sortie: {len(output_details)} tenseurs')
    print('🎉 Le modele est pret pour Flutter!')
    
except ImportError:
    print('❌ TensorFlow non installe')
    print('💡 Installez avec: pip install tensorflow')
except Exception as e:
    print(f'❌ Erreur: {e}')
    print('💡 Le fichier TFLite pourrait etre corrompu')
"
) else (
    echo ⚠️ Aucun fichier TFLite a tester
)

echo.
echo ================================================
echo    RESUME
echo ================================================
echo.

if exist "assets\best_93.tflite" (
    echo ✅ PRET! Votre modele TFLite est installe
    echo 📱 L'application Flutter peut utiliser la vraie detection
    echo.
    echo 🚀 Prochaines etapes:
    echo    1. Modifier TFLiteDetectionService pour utiliser le vrai modele
    echo    2. Remplacer la simulation par la vraie detection
    echo    3. Tester sur telephone!
) else (
    echo ❌ Modele TFLite manquant
    echo 💡 Executez convert_ultralytics.bat pour le generer
)

pause
