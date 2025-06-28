@echo off
echo ================================================
echo    SERVEUR DE DETECTION YOLOV5 - DEMARRAGE
echo ================================================

echo Navigation vers le dossier...
cd /d "c:\Users\Mehdi\Desktop\AI\V2\projets-casablanca-nextgen\OCR Panneaux\Code\App\back_detection"

echo Dossier actuel: %cd%

echo.
echo Installation des dependances Python...
python -m pip install flask flask-cors torch torchvision opencv-python pillow numpy ultralytics requests

echo.
echo Demarrage du serveur Flask...
echo ================================================
python app.py

pause
