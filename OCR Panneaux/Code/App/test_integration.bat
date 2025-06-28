@echo off
echo ================================================
echo    TEST INTEGRATION MODELE TFLITE
echo ================================================

COLOR 0F
echo.
echo 🎯 Verification de l'integration du modele dans l'application

echo.
echo [ETAPE 1/4] Verification du modele TFLite...
if exist "interfaces\assets\best_93.tflite" (
    echo ✅ Modele TFLite trouve dans assets
    dir "interfaces\assets\best_93.tflite"
) else (
    echo ❌ Modele TFLite manquant dans assets
    echo 🔄 Tentative de copie depuis le dossier model...
    
    if exist "..\model\yolov5\best_93.tflite" (
        copy "..\model\yolov5\best_93.tflite" "interfaces\assets\"
        echo ✅ Modele copie avec succes!
    ) else (
        echo ❌ Aucun modele TFLite trouve
        echo 💡 Executez convert_ultralytics.bat d'abord
        pause
        exit /b 1
    )
)

echo.
echo [ETAPE 2/4] Verification des dependances Flutter...
cd interfaces
flutter doctor --android-licenses > nul 2>&1
flutter pub get

echo.
echo [ETAPE 3/4] Verification de la configuration...
if exist "pubspec.yaml" (
    findstr "tflite_flutter" pubspec.yaml > nul && (
        echo ✅ Dependance TensorFlow Lite configuree
    ) || (
        echo ❌ Dependance TensorFlow Lite manquante
    )
)

if exist "assets\labels.txt" (
    echo ✅ Fichier labels.txt trouve
) else (
    echo ❌ Fichier labels.txt manquant
)

echo.
echo [ETAPE 4/4] Compilation et test...
echo 🔄 Compilation de l'application...
flutter build apk --debug --no-shrink

if %ERRORLEVEL% EQU 0 (
    echo ✅ Compilation reussie!
    echo.
    echo 🎉 INTEGRATION TERMINEE AVEC SUCCES!
    echo.
    echo 📱 Votre application avec detection TensorFlow Lite est prete!
    echo.
    echo 🚀 Pour tester:
    echo    1. Connectez votre telephone Android
    echo    2. Activez le mode developpeur
    echo    3. Executez: flutter run
    echo.
) else (
    echo ❌ Erreur lors de la compilation
    echo 💡 Verifiez les logs ci-dessus pour plus de details
)

cd ..
pause
