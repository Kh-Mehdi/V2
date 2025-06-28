@echo off
echo ================================================
echo    LANCEMENT APPLICATION DETECTION PANNEAUX
echo ================================================

COLOR 0F
echo.
echo 🚀 Lancement de l'application avec detection intelligente

echo.
echo [ETAPE 1/3] Verification des composants...

:: Verifier si le modele TFLite existe
if exist "interfaces\assets\best_93.tflite" (
    echo ✅ Modele TensorFlow Lite trouve - Mode IA avance active
) else (
    echo ⚠️ Modele TFLite manquant - Mode simulation active
    echo 💡 Le modele sera automatiquement utilise une fois disponible
    
    :: Verifier si on peut le copier depuis model/yolov5
    if exist "..\model\yolov5\best_93.tflite" (
        echo 🔄 Copie du modele depuis yolov5...
        copy "..\model\yolov5\best_93.tflite" "interfaces\assets\"
        if exist "interfaces\assets\best_93.tflite" (
            echo ✅ Modele TFLite installe!
        )
    )
)

:: Verifier les labels
if exist "interfaces\assets\labels.txt" (
    echo ✅ Fichier labels.txt trouve
) else (
    echo ❌ Fichier labels.txt manquant
)

echo.
echo [ETAPE 2/3] Preparation de l'environnement Flutter...
cd interfaces

:: Mettre a jour les dependances
flutter pub get

echo.
echo [ETAPE 3/3] Lancement de l'application...
echo.
echo 📱 INSTRUCTIONS:
echo    1. Connectez votre telephone Android via USB
echo    2. Activez le mode developpeur sur Android
echo    3. Activez le debogage USB
echo    4. Autorisez le debogage USB sur votre telephone
echo.
echo 🎯 L'application va demarrer avec:
if exist "assets\best_93.tflite" (
    echo    ✅ Detection TensorFlow Lite (IA reelle)
) else (
    echo    ⚠️ Mode simulation (en attendant le modele TFLite)
)
echo    ✅ Interface utilisateur complete
echo    ✅ Detection automatique toutes les 2 secondes
echo    ✅ Bouton de test manuel
echo.
echo 🚀 Lancement en cours...

:: Lancer l'application
flutter run --debug

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ✅ Application lancee avec succes!
) else (
    echo.
    echo ❌ Erreur lors du lancement
    echo 💡 Verifiez que votre telephone est bien connecte
    echo 💡 Essayez: flutter devices
)

cd ..
echo.
pause
