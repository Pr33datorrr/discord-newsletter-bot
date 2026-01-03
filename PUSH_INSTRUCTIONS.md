# Push to GitHub - Simple Instructions

Since automated push had authentication issues, please run these commands:

1. **Set the remote (already done):**
   ```bash
   git remote add origin https://github.com/Pr33datorrr/discord-newsletter-bot.git
   git branch -M main
   ```

2. **Push the code:**
   ```bash
   git push -u origin main
   ```

If you get authentication errors, you have two options:

## Option A: Use GitHub CLI (Easiest)
```bash
# Install GitHub CLI if not installed
winget install GitHub.cli

# Login
gh auth login

# Push using GitHub CLI
gh repo set-default Pr33datorrr/discord-newsletter-bot
git push -u origin main
```

## Option B: Use Personal Access Token
1. Go to: https://github.com/settings/tokens
2. Click "Generate new token (classic)"
3. Name it: "Newsletter Bot"
4. Select scopes: `repo` (all sub-scopes)
5. Click "Generate token"
6. Copy the token
7. When git asks for password, paste the token (not your GitHub password)

## After Pushing Successfully:

Run this command to set up secrets automatically (if you have gh CLI):
```bash
gh secret set DISCORD_WEBHOOK_URL --body "<YOUR_WEBHOOK_URL>"

gh secret set GEMINI_API_KEY --body "<YOUR_GEMINI_API_KEY>"
```

Or manually add secrets:
1. Go to: https://github.com/Pr33datorrr/discord-newsletter-bot/settings/secrets/actions
2. Add `DISCORD_WEBHOOK_URL` = <YOUR_WEBHOOK_URL>
3. Add `GEMINI_API_KEY` = <YOUR_GEMINI_API_KEY>

Then test:
https://github.com/Pr33datorrr/discord-newsletter-bot/actions
