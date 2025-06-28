@echo off
echo ================================================
echo    LANCEMENT MODE HORS LIGNE - DETECTION PANNEAUX
echo ================================================

COLOR 0C
echo.
echo 🚀 Mode hors ligne - Plus besoin de Flask!

echo.
echo [ETAPE 1/3] Preparation Flutter...
cd /d "c:\Users\Mehdi\Desktop\AI\V2\projets-casablanca-nextgen\OCR Panneaux\Code\App\interfaces"

echo Installation des dependances Flutter...
flutter pub get
if errorlevel 1 (
    echo ❌ Erreur dependances Flutter
    pause
    exit /b 1
) else (
    echo ✅ Dependances Flutter installees
)

echo.
echo [ETAPE 2/3] Verification des assets...
if exist "assets\best_93.tflite" (
    echo ✅ Modele TensorFlow Lite trouve
) else (
    echo ⚠️  Modele TensorFlow Lite non trouve
    echo 💡 Executez convert_model.bat pour creer le modele
    echo    Ou continuez avec la simulation de detection
)

if exist "assets\labels.txt" (
    echo ✅ Fichier labels trouve
) else (
    echo ⚠️  Fichier labels non trouve - labels par defaut utilises
)

echo.
echo [ETAPE 3/3] Lancement de l'application Flutter...
echo.
echo ================================================
echo    APPLICATION EN MODE HORS LIGNE
echo ================================================
echo.
echo ✅ Avantages du mode hors ligne:
echo    • Fonctionne sans internet
echo    • Plus rapide (pas de reseau)
echo    • Plus simple (pas de serveur)
echo    • Plus sur (donnees locales)
echo.
echo 🚀 Lancement en cours...

flutter run

echo.
echo Application fermee.
pause
