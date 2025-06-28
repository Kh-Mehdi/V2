@echo off
echo ================================================
echo    LANCEMENT RAPIDE - MODE SIMULATION
echo ================================================

COLOR 0A
echo.
echo 🚀 Demarrage en mode simulation (sans modele TFLite)

cd /d "c:\Users\Mehdi\Desktop\AI\V2\projets-casablanca-nextgen\OCR Panneaux\Code\App\interfaces"

echo.
echo 📦 Installation des dependances...
flutter pub get

echo.
echo ✅ Pret! L'application va demarrer avec:
echo    • Detection simulee (pour tester l'interface)
echo    • Mode hors ligne
echo    • Aucun serveur requis
echo.
echo 💡 Pour utiliser votre vrai modele plus tard:
echo    1. Executez convert_model.bat
echo    2. Decommentez best_93.tflite dans pubspec.yaml
echo    3. Relancez l'app
echo.
echo 🚀 Lancement...

flutter run

pause
