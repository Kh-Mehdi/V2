@echo off
echo ================================================
echo         Test du Système de Détection
echo ================================================
echo.

cd /d "%~dp0"

REM Vérifier si Python est installé
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Python n'est pas installé ou pas dans le PATH
    echo Veuillez installer Python depuis https://python.org
    pause
    exit /b 1
)

echo 🧪 Lancement des tests...
echo.

python test_systeme.py

echo.
echo ================================================
echo                Tests terminés
echo ================================================

pause
