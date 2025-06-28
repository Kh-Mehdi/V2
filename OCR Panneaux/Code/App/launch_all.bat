@echo off
echo ================================================
echo    LANCEMENT COMPLET - DETECTION PANNEAUX
echo ================================================
echo.

REM Couleurs pour les messages
COLOR 0A

echo [ETAPE 1/4] Verification de l'environnement...
echo.

REM Verification Python
python --version >nul 2>&1
if errorlevel 1 (
    echo ❌ ERREUR: Python non installe
    echo 💡 Installez Python depuis https://python.org
    pause
    exit /b 1
) else (
    echo ✓ Python detecte
)

REM Verification Flutter
flutter --version >nul 2>&1
if errorlevel 1 (
    echo ⚠️  Flutter non detecte - seulement le serveur Flask sera lance
    set FLUTTER_AVAILABLE=0
) else (
    echo ✓ Flutter detecte
    set FLUTTER_AVAILABLE=1
)

echo.
echo [ETAPE 2/4] Installation des dependances Python...
cd /d "c:\Users\Mehdi\Desktop\AI\V2\projets-casablanca-nextgen\OCR Panneaux\Code\App\back_detection"

REM Installation silencieuse des dependances
python -m pip install -q flask flask-cors torch torchvision opencv-python pillow numpy ultralytics requests
if errorlevel 1 (
    echo ❌ Erreur installation dependances Python
    pause
    exit /b 1
) else (
    echo ✓ Dependances Python installees
)

echo.
echo [ETAPE 3/4] Preparation Flutter...
if %FLUTTER_AVAILABLE%==1 (
    cd /d "c:\Users\Mehdi\Desktop\AI\V2\projets-casablanca-nextgen\OCR Panneaux\Code\App\interfaces"
    echo Installation des dependances Flutter...
    flutter pub get >nul 2>&1
    if errorlevel 1 (
        echo ⚠️  Erreur dependances Flutter - continuons quand meme
    ) else (
        echo ✓ Dependances Flutter installees
    )
) else (
    echo ⚠️  Flutter non disponible - seulement le serveur sera lance
)

echo.
echo [ETAPE 4/4] Lancement des serveurs...
echo.
echo ================================================
echo    DEMARRAGE EN COURS
echo ================================================

REM Creer un fichier temporaire pour controler les processus
set TEMP_DIR=%TEMP%\panneau_detection
if not exist "%TEMP_DIR%" mkdir "%TEMP_DIR%"

echo.
echo 🚀 Lancement du serveur Flask (Backend)...
echo    URL: http://localhost:5000
echo    Logs dans: logs_flask.txt

REM Demarrer le serveur Flask en arriere-plan
cd /d "c:\Users\Mehdi\Desktop\AI\V2\projets-casablanca-nextgen\OCR Panneaux\Code\App\back_detection"
start "Serveur Flask - Detection" /MIN cmd /c "python app.py > logs_flask.txt 2>&1"

REM Attendre que le serveur demarre
echo    Attente du demarrage du serveur...
timeout /t 5 /nobreak >nul

REM Tester la connexion au serveur
echo    Test de connexion...
python -c "import requests; requests.get('http://localhost:5000/health', timeout=3)" >nul 2>&1
if errorlevel 1 (
    echo ⚠️  Serveur en cours de demarrage...
    timeout /t 5 /nobreak >nul
) else (
    echo ✓ Serveur Flask operationnel
)

if %FLUTTER_AVAILABLE%==1 (
    echo.
    echo 📱 Lancement de l'application Flutter...
    echo    L'application va s'ouvrir dans un nouvel emulateur/appareil
    
    cd /d "c:\Users\Mehdi\Desktop\AI\V2\projets-casablanca-nextgen\OCR Panneaux\Code\App\interfaces"
    start "Application Flutter" cmd /c "flutter run"
    
    echo ✓ Application Flutter lancee
) else (
    echo.
    echo 📱 Pour lancer l'application Flutter manuellement:
    echo    1. Ouvrez un nouveau terminal
    echo    2. cd "c:\Users\Mehdi\Desktop\AI\V2\projets-casablanca-nextgen\OCR Panneaux\Code\App\interfaces"
    echo    3. flutter run
)

echo.
echo ================================================
echo    SYSTEME OPERATIONNEL
echo ================================================
echo.
echo ✅ Serveur Flask: http://localhost:5000
if %FLUTTER_AVAILABLE%==1 (
    echo ✅ Application Flutter: En cours d'ouverture
) else (
    echo ⚠️  Application Flutter: A lancer manuellement
)
echo.
echo 🛠️  CONTROLES:
echo    - Pour arreter: Fermez cette fenetre
echo    - Logs Flask: logs_flask.txt
echo    - Test serveur: http://localhost:5000/health
echo.
echo 💡 IMPORTANT: Gardez cette fenetre ouverte!
echo    Les serveurs s'arreteront si vous fermez cette fenetre.
echo.

REM Boucle pour maintenir le script actif
:LOOP
echo [%TIME%] Systeme actif - Appuyez sur Ctrl+C pour arreter
timeout /t 30 /nobreak >nul
goto LOOP
