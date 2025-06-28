@echo off
echo ================================================
echo    TEST RAPIDE - DETECTION AMELIOREE
echo ================================================

COLOR 0E
echo.
echo 🔧 Test de la detection amelioree

echo.
echo [1/2] Preparation...
cd /d "c:\Users\Mehdi\Desktop\AI\V2\projets-casablanca-nextgen\OCR Panneaux\Code\App\interfaces"

echo Installation rapide des dependances...
flutter pub get > nul 2>&1

echo.
echo [2/2] Lancement test...
echo.
echo ================================================
echo    NOUVELLE VERSION AVEC DEBUG
echo ================================================
echo.
echo ✅ Modifications apportees:
echo    • Detection plus frequente (80%% de chances)
echo    • Confiance amelioree (70-95%%)
echo    • Logs de debug ajoutes
echo    • Labels realistes de panneaux
echo.
echo 🔍 Regardez la console pour les logs de debug!
echo.
echo 🚀 Lancement en cours...

flutter run

echo.
echo Test termine.
pause
