@echo off
echo ================================================
echo    LANCEMENT APPLICATION ANDROID
echo ================================================

COLOR 0F
echo.
echo 📱 Lancement rapide de l'application sur Android

echo.
echo [VERIFICATION] Preparation...
cd interfaces

echo ✅ Verification des dependances...
flutter pub get --quiet

echo ✅ Verification des peripheriques...
flutter devices

echo.
echo 🚀 LANCEMENT DE L'APPLICATION...
echo.
echo 📱 Instructions:
echo    1. Votre telephone Android doit etre connecte via USB
echo    2. Mode developpeur + debogage USB actives
echo    3. Autorisez le debogage USB si demande
echo.
echo 🎯 L'application va demarrer avec:
echo    ✅ Service de detection unifie
echo    ✅ Mode simulation intelligente (puis TensorFlow Lite si disponible)
echo    ✅ Detection automatique toutes les 2 secondes
echo    ✅ Interface camera complete
echo.

flutter run --debug

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ✅ APPLICATION LANCEE AVEC SUCCES!
    echo 📱 Testez la detection en pointant la camera vers des objets
) else (
    echo.
    echo ❌ Erreur lors du lancement
    echo.
    echo 💡 SOLUTIONS POSSIBLES:
    echo    - Verifiez que votre telephone est connecte
    echo    - Executez: flutter devices
    echo    - Autorisez le debogage USB sur votre telephone
    echo    - Redemarrez votre telephone et reconnectez
)

cd ..
echo.
pause
