#!/bin/bash

# AI Newsletter Bot - GitHub Setup Script
# This script will help you push to GitHub and configure secrets

echo "=================================================="
echo "🤖 AI Newsletter Bot - GitHub Deployment"
echo "=================================================="
echo ""

# Step 1: Check if GitHub CLI is installed
if command -v gh &> /dev/null; then
    echo "✅ GitHub CLI (gh) is installed"
    echo ""
    
    # Check if authenticated
    if gh auth status &> /dev/null; then
        echo "✅ You are authenticated with GitHub"
        echo ""
        
        # Create repository
        echo "📦 Creating GitHub repository..."
        read -p "Enter repository name (default: discord-newsletter-bot): " REPO_NAME
        REPO_NAME=${REPO_NAME:-discord-newsletter-bot}
        
        read -p "Make repository private? (y/N): " PRIVATE
        if [[ $PRIVATE == "y" || $PRIVATE == "Y" ]]; then
            VISIBILITY="--private"
        else
            VISIBILITY="--public"
        fi
        
        gh repo create "$REPO_NAME" $VISIBILITY --source=. --remote=origin --push
        
        if [ $? -eq 0 ]; then
            echo "✅ Repository created and code pushed!"
            echo ""
            
            # Set secrets
            echo "🔐 Setting up GitHub Secrets..."
            
            read -p "Enter DISCORD_WEBHOOK_URL: " DISCORD_WEBHOOK
            read -p "Enter GEMINI_API_KEY: " GEMINI_KEY
            
            gh secret set DISCORD_WEBHOOK_URL --body "$DISCORD_WEBHOOK"
            gh secret set GEMINI_API_KEY --body "$GEMINI_KEY"
            
            echo "✅ Secrets configured!"
            echo ""
            echo "=================================================="
            echo "✅ Deployment Complete!"
            echo "=================================================="
            echo ""
            echo "Next steps:"
            echo "1. Go to: https://github.com/$(gh api user -q .login)/$REPO_NAME"
            echo "2. Navigate to Actions tab"
            echo "3. Click 'Daily AI Newsletter Digest'"
            echo "4. Click 'Run workflow' to test"
            echo ""
        else
            echo "❌ Failed to create repository"
        fi
    else
        echo "⚠️  Not authenticated with GitHub"
        echo "Run: gh auth login"
    fi
else
    echo "⚠️  GitHub CLI not installed"
    echo ""
    echo "Manual setup instructions:"
    echo "1. Go to https://github.com/new"
    echo "2. Name: discord-newsletter-bot"
    echo "3. Choose Public or Private"
    echo "4. DON'T initialize with README"
    echo "5. Click 'Create repository'"
    echo ""
    echo "Then run these commands:"
    echo "  git remote add origin https://github.com/YOUR_USERNAME/discord-newsletter-bot.git"
    echo "  git branch -M main"
    echo "  git push -u origin main"
fi
