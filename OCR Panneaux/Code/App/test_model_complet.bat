@echo off
echo ================================================
echo    TEST COMPLET MODELE YOLOV5
echo ================================================

COLOR 0E
echo.
echo 🧪 Test complet du modele de detection

echo.
echo [ETAPE 1/4] Verification de l'environnement...
cd /d "c:\Users\Mehdi\Desktop\AI\V2\projets-casablanca-nextgen\OCR Panneaux\Code\model\yolov5"

echo Verification Python...
python --version
if errorlevel 1 (
    echo ❌ Python non trouve
    echo 💡 Installez Python depuis python.org
    pause
    exit /b 1
)

echo.
echo [ETAPE 2/4] Installation des dependances...
echo Installation en cours (peut prendre quelques minutes)...
pip install -r requirements.txt
if errorlevel 1 (
    echo ❌ Erreur installation
    echo 💡 Verifiez votre connexion internet
    pause
    exit /b 1
) else (
    echo ✅ Dependances installees
)

echo.
echo [ETAPE 3/4] Verification du modele...
if exist "best_93.pt" (
    echo ✅ Modele best_93.pt trouve (%.0f Ko)" $(du -k best_93.pt | cut -f1)
    echo 📊 Informations du modele:
    python -c "import torch; model=torch.load('best_93.pt', map_location='cpu'); print(f'Classes: {model.get(\"model\", {}).get(\"nc\", \"N/A\")}'); print(f'Taille: {len(str(model))} caracteres')"
) else (
    echo ❌ Modele best_93.pt non trouve
    echo 💡 Verifiez le chemin du fichier
    pause
    exit /b 1
)

echo.
echo [ETAPE 4/4] Test de detection...
echo.
echo ================================================
echo    CHOISISSEZ VOTRE TEST
echo ================================================
echo.
echo 1. Test webcam temps reel (recommande)
echo 2. Test sur images d'exemple
echo 3. Test sur image personnalisee
echo 4. Annuler
echo.
set /p choice="Votre choix (1-4): "

if "%choice%"=="1" goto webcam
if "%choice%"=="2" goto images
if "%choice%"=="3" goto custom
if "%choice%"=="4" goto end
goto invalid

:webcam
echo.
echo 🎥 Test webcam en cours...
echo Appuyez sur 'q' dans la fenetre video pour quitter
python detect.py --weights best_93.pt --source 0 --view-img --conf 0.4
goto end

:images
echo.
echo 🖼️ Test sur images d'exemple...
python detect.py --weights best_93.pt --source data/images --view-img --conf 0.4
goto end

:custom
echo.
set /p imgpath="Entrez le chemin de votre image: "
python detect.py --weights best_93.pt --source "%imgpath%" --view-img --conf 0.4
goto end

:invalid
echo Choix invalide
goto end

:end
echo.
echo ✅ Test termine!
echo 📂 Resultats sauvegardes dans: runs/detect/
pause
