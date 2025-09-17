@echo off
setlocal enabledelayedexpansion
title Script de build Flutter Web
chcp 65001 >nul

REM ====== CONFIG ======
set REPO_NAME=golieux_web
set BASE_HREF=/%REPO_NAME%/
set BRANCH=main
REM ====================

:menu
cls
echo ==================================================
echo  Script de build Flutter Web
echo ==================================================
echo.
echo  [1] Build pour GitHub Pages   (base-href %BASE_HREF%)
echo  [2] Build pour Localhost (test)
echo  [3] Build + Push sur %BRANCH% (deploiement via GitHub Actions)
echo  [Q] Quitter
echo.
set /p CHOIX=Ton choix :

if /I "%CHOIX%"=="1" goto opt1
if /I "%CHOIX%"=="2" goto opt2
if /I "%CHOIX%"=="3" goto opt3
if /I "%CHOIX%"=="Q" goto end
if /I "%CHOIX%"=="q" goto end
echo.
echo Choix inconnu. Appuie sur une touche...
pause >nul
goto menu


:check_flutter
where flutter >nul 2>nul
if errorlevel 1 (
  echo [ERREUR] Flutter n'est pas dans le PATH.
  echo - Ouvre un "Flutter Command Prompt" OU
  echo - Ajoute Flutter au PATH puis relance le script.
  echo.
  pause
  goto menu
)
REM Affiche la version pour debug
flutter --version
if errorlevel 1 (
  echo [ERREUR] Flutter semble indisponible.
  echo.
  pause
  goto menu
)
goto :eof


REM =========================
REM  [1] BUILD POUR GH-PAGES
REM =========================
:opt1
call :check_flutter
echo.
echo [1] flutter build web --release --base-href=%BASE_HREF%
flutter clean
if errorlevel 1 echo [WARN] flutter clean a renvoye une erreur (ignore) & echo.
flutter pub get || goto build_fail
flutter build web --release --base-href=%BASE_HREF%
if errorlevel 1 goto build_fail

echo.
echo [OK] Build termine : build\web
echo - Tu peux maintenant faire un git push sur %BRANCH% pour declencher le workflow.
echo.
pause
goto menu


REM =========================
REM  [2] BUILD POUR LOCALHOST
REM =========================
:opt2
call :check_flutter
echo.
echo [2] flutter build web --release --base-href=/
flutter clean
if errorlevel 1 echo [WARN] flutter clean a renvoye une erreur (ignore) & echo.
flutter pub get || goto build_fail
flutter build web --release --base-href=/
if errorlevel 1 goto build_fail

echo.
echo [OK] Build localhost termine : build\web
echo - Ouvre build\web\index.html avec un petit serveur local.
echo   Exemples :
echo     1^) python -m http.server 8080        (Python)
echo     2^) npx http-server -p 8080           (NodeJS)
echo     3^) "Live Server" dans VS Code
echo.
pause
goto menu


REM ================================================
REM  [3] BUILD + PUSH (DECLENCHE GITHUB ACTIONS)
REM ================================================
:opt3
call :check_flutter

echo.
echo [3] Build (optionnel) + Push sur %BRANCH% (declenche Actions)
set /p DO_BUILD=Refaire un build avant push ? (O/N) :
if /I "%DO_BUILD%"=="O" (
  echo.
  echo - flutter build web --release --base-href=%BASE_HREF%
  flutter clean
  if errorlevel 1 echo [WARN] flutter clean a renvoye une erreur (ignore) & echo.
  flutter pub get || goto build_fail
  flutter build web --release --base-href=%BASE_HREF%
  if errorlevel 1 goto build_fail
)

REM Verifie la remote
echo.
git remote -v
if errorlevel 1 (
  echo [ERREUR] Ce dossier n'est pas un repo Git valide.
  echo.
  pause
  goto menu
)

REM Ajoute et commit (ou commit vide si rien a commiter)
echo.
git add -A
git commit -m "trigger deploy"
if errorlevel 1 (
  echo [INFO] Aucun changement detecte. Creation d'un commit vide...
  git commit --allow-empty -m "trigger deploy (empty commit)"
)

REM Push
echo.
git push origin %BRANCH%
if errorlevel 1 (
  echo [ERREUR] Echec du push. Verifie ta connexion et tes droits.
  echo.
  pause
  goto menu
)

echo.
echo [OK] Push envoye. Le deploiement va se lancer sur GitHub Actions.
echo Ouvre: https://github.com/%USERNAME%/%REPO_NAME%/actions
echo.
pause
goto menu


:build_fail
echo.
echo [ERREUR] Le build a echoue (code %ERRORLEVEL%).
echo - Lis les messages ci-dessus pour identifier le package/probleme.
echo.
pause
goto menu


:end
echo.
echo Au revoir !
echo.
timeout /t 1 >nul
exit /b 0
