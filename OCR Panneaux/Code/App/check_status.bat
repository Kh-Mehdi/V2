@echo off
echo ================================================
echo    STATUS INTEGRATION MODELE TFLITE
echo ================================================

COLOR 0F
echo.
echo 🔍 Verification rapide de l'etat de l'integration

echo.
echo [COMPOSANTS REQUIS]

:: Modele YOLOv5 source
if exist "..\model\yolov5\best_93.pt" (
    echo ✅ Modele YOLOv5 source (.pt) : PRESENT
) else (
    echo ❌ Modele YOLOv5 source (.pt) : MANQUANT
)

:: Modele TFLite converti
if exist "..\model\yolov5\best_93.tflite" (
    echo ✅ Modele TFLite converti     : PRESENT
) else (
    echo ❌ Modele TFLite converti     : MANQUANT
    echo 💡 Executez convert_ultralytics.bat pour le generer
)

:: Modele dans assets Flutter
if exist "interfaces\assets\best_93.tflite" (
    echo ✅ Modele dans assets Flutter : PRESENT
    for %%A in ("interfaces\assets\best_93.tflite") do echo    Taille: %%~zA bytes
) else (
    echo ❌ Modele dans assets Flutter : MANQUANT
    echo 💡 Le modele sera copie automatiquement si disponible
)

:: Labels
if exist "interfaces\assets\labels.txt" (
    echo ✅ Fichier labels.txt        : PRESENT
    for /f %%i in ('type "interfaces\assets\labels.txt" ^| find /c /v ""') do echo    Classes: %%i panneaux
) else (
    echo ❌ Fichier labels.txt        : MANQUANT
)

:: Dependances Flutter
echo.
echo [DEPENDANCES FLUTTER]
cd interfaces
if exist "pubspec.yaml" (
    findstr /C:"tflite_flutter" pubspec.yaml >nul && (
        echo ✅ TensorFlow Lite Flutter : CONFIGURE
    ) || (
        echo ❌ TensorFlow Lite Flutter : NON CONFIGURE
    )
    
    findstr /C:"camera:" pubspec.yaml >nul && (
        echo ✅ Plugin Camera           : CONFIGURE
    ) || (
        echo ❌ Plugin Camera           : NON CONFIGURE
    )
)

echo.
echo [SERVICES DE DETECTION]
if exist "lib\services\tflite_detection_service.dart" (
    echo ✅ Service TensorFlow Lite   : PRESENT
) else (
    echo ❌ Service TensorFlow Lite   : MANQUANT
)

if exist "lib\services\offline_detection_service.dart" (
    echo ✅ Service simulation       : PRESENT
) else (
    echo ❌ Service simulation       : MANQUANT
)

echo.
echo [RESUME]
if exist "assets\best_93.tflite" (
    echo 🎯 ETAT: DETECTION IA AVANCEE PRETE
    echo 📱 L'application utilisera TensorFlow Lite pour la vraie detection
) else (
    echo ⚠️ ETAT: MODE SIMULATION ACTIF
    echo 📱 L'application fonctionnera en mode demo en attendant le modele
)

echo.
echo 💡 PROCHAINES ETAPES:
if not exist "..\model\yolov5\best_93.tflite" (
    echo    1. Executez convert_ultralytics.bat pour convertir le modele
)
echo    2. Executez launch_app_smart.bat pour lancer l'application
echo    3. Testez la detection avec votre telephone

cd ..
echo.
pause
