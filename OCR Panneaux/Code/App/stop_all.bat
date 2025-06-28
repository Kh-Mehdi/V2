@echo off
echo ================================================
echo    ARRET DE TOUS LES SERVEURS
echo ================================================

COLOR 0C
echo.
echo 🛑 Arret des serveurs en cours...

REM Arreter les processus Flask
echo Arret du serveur Flask...
taskkill /f /im python.exe >nul 2>&1

REM Arreter les processus Flutter
echo Arret de Flutter...
taskkill /f /im flutter.exe >nul 2>&1
taskkill /f /im dart.exe >nul 2>&1

REM Arreter les processus de developpement
taskkill /f /im "cmd.exe" /fi "WINDOWTITLE eq Serveur Flask*" >nul 2>&1
taskkill /f /im "cmd.exe" /fi "WINDOWTITLE eq Application Flutter*" >nul 2>&1

echo.
echo ✅ Tous les serveurs ont ete arretes
echo.
echo Liberation du port 5000...
netstat -ano | findstr :5000
echo.

REM Nettoyer les fichiers temporaires
if exist "logs_flask.txt" del "logs_flask.txt"

echo 🧹 Nettoyage termine
echo.
pause
