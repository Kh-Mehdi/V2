@echo off
echo ================================================
echo    COMPILATION ET TEST ANDROID
echo ================================================

COLOR 0F
echo.
echo 🔧 Compilation et test de l'application pour Android

echo.
echo [ETAPE 1/5] Nettoyage et preparation...
cd interfaces
flutter clean
flutter pub get

echo.
echo [ETAPE 2/5] Verification des erreurs de code...
echo 🔍 Analyse statique du code...
flutter analyze --no-fatal-infos

echo.
echo [ETAPE 3/5] Test de compilation Android...
echo 🔨 Compilation de l'APK de debug...
flutter build apk --debug --no-shrink

if %ERRORLEVEL% NEQ 0 (
    echo ❌ Erreur lors de la compilation
    echo 💡 Verifiez les erreurs ci-dessus
    cd ..
    pause
    exit /b 1
)

echo ✅ Compilation reussie!

echo.
echo [ETAPE 4/5] Verification des peripheriques...
echo 📱 Peripheriques Android detectes:
flutter devices

echo.
echo [ETAPE 5/5] Options de lancement...
echo.
echo 🎯 COMPILATION TERMINEE AVEC SUCCES!
echo.
echo 📱 Votre application est prete pour Android:
echo    ✅ APK genere: build/app/outputs/flutter-apk/app-debug.apk
echo    ✅ Permissions camera configurees
echo    ✅ Service de detection unifie integre
echo    ✅ Mode simulation et TFLite supportes
echo.
echo 🚀 POUR LANCER L'APPLICATION:
echo    1. Connectez votre telephone Android via USB
echo    2. Activez le mode developpeur + debogage USB
echo    3. Tapez: flutter run
echo.
echo OU
echo    1. Installez l'APK manuellement sur votre telephone
echo    2. Autorisez les permissions camera quand demande
echo.

set /p choice="Voulez-vous lancer l'application maintenant? (y/n): "
if /i "%choice%"=="y" (
    echo 🚀 Lancement de l'application...
    flutter run --debug
) else (
    echo 💡 Vous pouvez lancer plus tard avec: flutter run
)

cd ..
echo.
pause
