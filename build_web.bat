@echo off
REM ==============================
REM  Script de build Flutter Web
REM  (c) GoLieux - Windows .bat
REM ==============================

REM >>> À PERSONNALISER SI BESOIN <<<
set "REPO_SLUG=mahugnonelies/golieux_web"  REM owner/repo
set "PAGES_BASE=/golieux_web/"             REM base-href pour GitHub Pages
REM >>> FIN PERSONNALISATION <<<

cls
echo ==============================
echo  Script de build Flutter Web
echo ==============================
echo.
echo  [1] Build pour GitHub Pages (base-href %PAGES_BASE%)
echo  [2] Build pour Localhost (test)
echo  [3] Build + Push sur main  ^(deploie via GitHub Actions^)
echo.
set /p choix="Ton choix : "

if "%choix%"=="1" goto :build_pages
if "%choix%"=="2" goto :build_local
if "%choix%"=="3" goto :deploy
echo.
echo ❌ Mauvais choix, recommence.
pause
exit /b 1

:check_flutter
where flutter >nul 2>nul
if errorlevel 1 (
  echo ❌ Flutter n'est pas dans le PATH. Ouvre "Flutter Command Prompt" ou ajoute Flutter au PATH.
  pause
  exit /b 1
)
goto :eof

:build_pages
call :check_flutter
echo 🔨 Nettoyage...
flutter clean
echo 📦 pub get...
flutter pub get
echo 🔨 Build (release) pour GitHub Pages avec base-href %PAGES_BASE% ...
flutter build web --release --base-href=%PAGES_BASE%
if errorlevel 1 (
  echo ❌ Build echoue.
  pause
  exit /b 1
)
echo ✅ Build termine ! Fichiers: .\build\web
pause
exit /b 0

:build_local
call :check_flutter
echo 🔨 Nettoyage...
flutter clean
echo 📦 pub get...
flutter pub get
echo 🔨 Build (release) pour LOCAL (pas de base-href) ...
flutter build web --release
if errorlevel 1 (
  echo ❌ Build echoue.
  pause
  exit /b 1
)
echo ✅ Build termine ! Lancement serveur local...
pushd build\web

REM — Essaye Python d'abord, sinon npx http-server si Node est installe —
where python >nul 2>nul
if not errorlevel 1 (
  echo 🚀 python -m http.server 8080
  python -m http.server 8080
  popd
  exit /b 0
)

where npx >nul 2>nul
if not errorlevel 1 (
  echo 🚀 npx http-server -p 8080
  npx http-server -p 8080
  popd
  exit /b 0
)

echo ❌ Ni Python ni Node n'ont ete trouves.
echo    Installe Python (https://www.python.org) ou Node.js (https://nodejs.org)
popd
pause
exit /b 1

:deploy
call :check_flutter
echo 🔨 Nettoyage...
flutter clean
echo 📦 pub get...
flutter pub get
echo 🔨 Build (release) pour GitHub Pages avec base-href %PAGES_BASE% ...
flutter build web --release --base-href=%PAGES_BASE%
if errorlevel 1 (
  echo ❌ Build echoue — abandon du push.
  pause
  exit /b 1
)

echo.
echo 🗂  Etat Git courant:
git status
echo.
set "msg="
set /p msg="Message de commit (ex: ci: build web & deploy) : "
if "%msg%"=="" set "msg=ci: build web & deploy"

echo.
echo ➕ git add -A
git add -A

echo.
echo ✅ git commit -m "%msg%"
git commit -m "%msg%"
if errorlevel 1 (
  echo (ℹ️) Rien a commit (peut-etre deja a jour).
)

echo.
echo ⬆️  git push origin main
git push origin main
if errorlevel 1 (
  echo ❌ Echec du push. Verifie tes droits/connexion remote.
  pause
  exit /b 1
)

echo ✅ Push effectue ! GitHub Actions va lancer le deploiement automatiquement.
echo 🔍 Ouvrir la page des Actions ? (Y/N)
choice /c YN /n
if errorlevel 2 goto :end
start "" "https://github.com/%REPO_SLUG%/actions"
goto :end

:end
echo Fini.
pause
exit /b 0
