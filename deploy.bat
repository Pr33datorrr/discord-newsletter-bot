@echo off
echo ================================================
echo Automated GitHub Push and Secret Configuration
echo ================================================
echo.

REM Check if gh is installed
where gh >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] GitHub CLI not found!
    echo.
    echo Installing GitHub CLI...
    winget install GitHub.cli
    
    if %ERRORLEVEL% NEQ 0 (
        echo [ERROR] Failed to install GitHub CLI
        echo Please install manually: https://cli.github.com/
        pause
        exit /b 1
    )
    
    echo.
    echo GitHub CLI installed! Please close this window and run again.
    pause
    exit /b 0
)

echo [OK] GitHub CLI found
echo.

REM Check authentication
echo Checking GitHub authentication...
gh auth status >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo.
    echo You need to login to GitHub first.
    echo.
    gh auth login
    
    if %ERRORLEVEL% NEQ 0 (
        echo [ERROR] Authentication failed
        pause
        exit /b 1
    )
)

echo [OK] Authenticated
echo.

REM Push to GitHub
echo Pushing code to GitHub...
echo.

git push -u origin main

if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Push failed
    echo.
    echo Trying with gh auth setup-git...
    gh auth setup-git
    git push -u origin main
    
    if %ERRORLEVEL% NEQ 0 (
        echo [ERROR] Still failed. Please check your repository access.
        pause
        exit /b 1
    )
)

echo.
echo [OK] Code pushed successfully!
echo.

REM Set secrets
echo Configuring GitHub Secrets...
echo.


echo.
echo ----------------------------------------------------------------
echo Please enter your secrets for GitHub Actions.
echo These will be saved securely to your repository secrets.
echo ----------------------------------------------------------------
echo.

set /p DISCORD_WEBHOOK="Enter DISCORD_WEBHOOK_URL: "
gh secret set DISCORD_WEBHOOK_URL --body "%DISCORD_WEBHOOK%" --repo Pr33datorrr/discord-newsletter-bot

if %ERRORLEVEL% EQU 0 (
    echo [OK] DISCORD_WEBHOOK_URL set
) else (
    echo [WARNING] Failed to set DISCORD_WEBHOOK_URL
)

echo.
set /p GEMINI_KEY="Enter GEMINI_API_KEY: "
gh secret set GEMINI_API_KEY --body "%GEMINI_KEY%" --repo Pr33datorrr/discord-newsletter-bot

if %ERRORLEVEL% EQU 0 (
    echo [OK] GEMINI_API_KEY set
) else (
    echo [WARNING] Failed to set GEMINI_API_KEY
)

echo.
echo ================================================
echo Deployment Complete!
echo ================================================
echo.
echo Next steps:
echo 1. Go to: https://github.com/Pr33datorrr/discord-newsletter-bot/actions
echo 2. Click "Daily AI Newsletter Digest"
echo 3. Click "Run workflow"
echo 4. Check your Discord channel!
echo.
pause
