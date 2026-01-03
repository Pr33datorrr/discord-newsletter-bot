# AI Newsletter Bot - GitHub Setup (PowerShell)
# Run this script to automate GitHub setup

Write-Host "==================================================" -ForegroundColor Cyan
Write-Host "🤖 AI Newsletter Bot - GitHub Deployment" -ForegroundColor Cyan
Write-Host "==================================================" -ForegroundColor Cyan
Write-Host ""

# Configuration
$DISCORD_WEBHOOK = Read-Host "Enter DISCORD_WEBHOOK_URL"
$GEMINI_KEY = Read-Host "Enter GEMINI_API_KEY"

Write-Host "MANUAL SETUP INSTRUCTIONS:" -ForegroundColor Yellow
Write-Host ""
Write-Host "STEP 1: Create GitHub Repository" -ForegroundColor Green
Write-Host "  1. Go to: https://github.com/new" -ForegroundColor White
Write-Host "  2. Repository name: discord-newsletter-bot" -ForegroundColor White
Write-Host "  3. Choose Public or Private" -ForegroundColor White
Write-Host "  4. ⚠️  DON'T initialize with README, .gitignore, or license" -ForegroundColor Red
Write-Host "  5. Click 'Create repository'" -ForegroundColor White
Write-Host ""

Read-Host "Press Enter after creating the repository on GitHub..."

Write-Host ""
Write-Host "STEP 2: Enter Your GitHub Username" -ForegroundColor Green
$GITHUB_USER = Read-Host "GitHub Username"

Write-Host ""
Write-Host "STEP 3: Enter Repository Name (or press Enter for default)" -ForegroundColor Green
$REPO_NAME = Read-Host "Repository Name (default: discord-newsletter-bot)"
if ([string]::IsNullOrWhiteSpace($REPO_NAME)) {
    $REPO_NAME = "discord-newsletter-bot"
}

Write-Host ""
Write-Host "📤 Pushing code to GitHub..." -ForegroundColor Yellow

# Set git remote
$REMOTE_URL = "https://github.com/$GITHUB_USER/$REPO_NAME.git"

git remote add origin $REMOTE_URL
git branch -M main
git push -u origin main

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Code pushed successfully!" -ForegroundColor Green
    Write-Host ""
    
    Write-Host "==================================================" -ForegroundColor Cyan
    Write-Host "STEP 4: Configure GitHub Secrets" -ForegroundColor Green
    Write-Host "==================================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Go to your repository settings and add these secrets:"
    Write-Host ""
    Write-Host "1. Go to: https://github.com/$GITHUB_USER/$REPO_NAME/settings/secrets/actions" -ForegroundColor White
    Write-Host ""
    Write-Host "2. Click 'New repository secret' and add:" -ForegroundColor White
    Write-Host ""
    Write-Host "   Secret 1:" -ForegroundColor Yellow
    Write-Host "   Name: DISCORD_WEBHOOK_URL" -ForegroundColor Cyan
    Write-Host "   Value: $DISCORD_WEBHOOK" -ForegroundColor Gray
    Write-Host ""
    Write-Host "   Secret 2:" -ForegroundColor Yellow
    Write-Host "   Name: GEMINI_API_KEY" -ForegroundColor Cyan
    Write-Host "   Value: $GEMINI_KEY" -ForegroundColor Gray
    Write-Host ""
    Write-Host "==================================================" -ForegroundColor Cyan
    Write-Host "STEP 5: Test the Automation" -ForegroundColor Green
    Write-Host "==================================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "1. Go to: https://github.com/$GITHUB_USER/$REPO_NAME/actions" -ForegroundColor White
    Write-Host "2. Click 'Daily AI Newsletter Digest' workflow" -ForegroundColor White
    Write-Host "3. Click 'Run workflow' → 'Run workflow'" -ForegroundColor White
    Write-Host "4. Check your Discord channel for messages!" -ForegroundColor White
    Write-Host ""
    Write-Host "✅ Setup Complete!" -ForegroundColor Green
}
else {
    Write-Host "❌ Failed to push to GitHub" -ForegroundColor Red
    Write-Host ""
    Write-Host "If you got an authentication error, you need to set up credentials:" -ForegroundColor Yellow
    Write-Host "Option 1 (Recommended): Use GitHub CLI" -ForegroundColor White
    Write-Host "  - Install: winget install GitHub.cli" -ForegroundColor Gray
    Write-Host "  - Login: gh auth login" -ForegroundColor Gray
    Write-Host ""
    Write-Host "Option 2: Use Personal Access Token" -ForegroundColor White
    Write-Host "  1. Go to: https://github.com/settings/tokens" -ForegroundColor Gray
    Write-Host "  2. Generate new token (classic)" -ForegroundColor Gray
    Write-Host "  3. Use token as password when pushing" -ForegroundColor Gray
}
