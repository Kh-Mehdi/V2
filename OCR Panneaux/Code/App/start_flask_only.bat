@echo off
echo ================================================
echo    SERVEUR FLASK SEULEMENT - DETECTION PANNEAUX
echo ================================================

COLOR 0B
echo.
echo 🚀 Demarrage du serveur de detection...

REM Navigation vers le dossier
cd /d "c:\Users\Mehdi\Desktop\AI\V2\projets-casablanca-nextgen\OCR Panneaux\Code\App\back_detection"

REM Installation rapide des dependances
echo 📦 Installation dependances...
python -m pip install -q flask flask-cors torch torchvision opencv-python pillow numpy ultralytics requests

echo.
echo ⚡ Lancement du serveur Flask...
echo    URL: http://localhost:5000
echo    Pour arreter: Ctrl+C
echo ================================================

REM Lancement du serveur
python app.py

echo.
echo Serveur arrete.
pause
