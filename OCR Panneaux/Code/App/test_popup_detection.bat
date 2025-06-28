@echo off
echo ========================================
echo    TEST DETECTION POPUP - V1.0
echo ========================================
echo.
echo Ce script teste les popups de detection de panneaux
echo.

cd /d "%~dp0interfaces"

echo [1/3] Nettoyage du cache...
call flutter clean > nul 2>&1

echo [2/3] Récupération des dépendances...
call flutter pub get

echo [3/3] Compilation et lancement en mode debug...
echo.
echo Instructions de test:
echo - Appuyez sur l'icone diagnostic (en haut à droite)
echo - Cliquez sur "Test Popup" pour voir le popup de detection
echo - Testez aussi "Relancer le diagnostic" pour voir les detections automatiques
echo - Si une detection apparait, elle s'affichera en popup
echo.

call flutter run

echo.
echo Test terminé.
pause
