# 🚀 Quick Deployment Guide

## Current Status: ✅ Code is Ready!

Your AI Newsletter Bot is committed to git and ready to deploy. Follow these steps:

---

## Option 1: Using the PowerShell Script (EASIEST)

The script `setup_github.ps1` is currently running and will guide you through:

1. **Create GitHub Repository:**
   - Open: https://github.com/new
   - Name: `discord-newsletter-bot`
   - Visibility: Public or Private (your choice)
   - **IMPORTANT:** DON'T check "Add README" or "Add .gitignore"
   - Click "Create repository"

2. **Enter Your Info:**
   - The script will ask for your GitHub username
   - It will push the code automatically

3. **Add Secrets:**
   - Go to: `https://github.com/YOUR_USERNAME/discord-newsletter-bot/settings/secrets/actions`
   - Add these two secrets:

   **Secret 1:**
   - Name: `DISCORD_WEBHOOK_URL`
   **Secret 1:**
   - Name: `DISCORD_WEBHOOK_URL`
   - Value: `<YOUR_WEBHOOK_URL>`

   **Secret 2:**
   - Name: `GEMINI_API_KEY`
   - Value: `<YOUR_GEMINI_API_KEY>`

4. **Test It:**
   - Go to Actions tab: `https://github.com/YOUR_USERNAME/discord-newsletter-bot/actions`
   - Click "Daily AI Newsletter Digest"
   - Click "Run workflow" → "Run workflow"
   - Check your Discord in ~1 minute!

---

## Option 2: Manual Setup (If Script Doesn't Work)

### Step 1: Create GitHub Repository

1. Go to https://github.com/new
2. Repository name: `discord-newsletter-bot`
3. Choose Public or Private
4. DON'T initialize with README
5. Click "Create repository"

### Step 2: Push Code

You'll see commands like this on GitHub:

```bash
git remote add origin https://github.com/YOUR_USERNAME/discord-newsletter-bot.git
git branch -M main
git push -u origin main
```

Run these commands in the `Discord_Newsletter_Bot` directory.

**If you get authentication errors:**

Option A: Install GitHub CLI
```powershell
winget install GitHub.cli
gh auth login
```

Option B: Use Personal Access Token
1. Go to https://github.com/settings/tokens
2. Click "Generate new token (classic)"
3. Give it a name: "Newsletter Bot"
4. Check scopes: `repo` (all sub-scopes)
5. Click "Generate token"
6. Copy the token
7. When git asks for password, paste the token

### Step 3: Add GitHub Secrets

1. Go to your repo: `https://github.com/YOUR_USERNAME/discord-newsletter-bot`
2. Click **Settings** → **Secrets and variables** → **Actions**
3. Click **New repository secret**

Add these two secrets:

**Secret 1:**
- Name: `DISCORD_WEBHOOK_URL`
- Value: `<YOUR_WEBHOOK_URL>`

**Secret 2:**
- Name: `GEMINI_API_KEY`
- Value: `<YOUR_GEMINI_API_KEY>`

### Step 4: Test the Automation

1. Go to **Actions** tab
2. Click **Daily AI Newsletter Digest** workflow
3. Click **Run workflow** dropdown
4. Click **Run workflow** button
5. Wait 30-60 seconds
6. Click on the running workflow to see logs
7. Check your Discord channel!

---

## 🎯 What Happens Next?

Once deployed:
- ✅ Runs automatically every day at 8:00 AM UTC
- ✅ Fetches latest from TLDR AI, Ben's Bites, The Rundown AI
- ✅ Generates AI summaries using Gemini
- ✅ Sends to your Discord channel
- ✅ Completely free!

---

## 🔧 Troubleshooting

### "error: remote origin already exists"
```bash
git remote remove origin
git remote add origin https://github.com/YOUR_USERNAME/discord-newsletter-bot.git
```

### "Authentication failed"
- Use GitHub CLI: `gh auth login`
- Or use Personal Access Token (see instructions above)

### Workflow not appearing in Actions tab
- Make sure `.github/workflows/daily.yml` was pushed
- Check repository Settings → Actions → Allow all actions

### No messages in Discord
- Verify secrets are set correctly (no extra spaces)
- Check workflow logs in Actions tab for errors
- Test Discord webhook manually:
  ```powershell
  $webhook = "<YOUR_WEBHOOK_URL>"
  $body = @{content="Test message from PowerShell"} | ConvertTo-Json
  Invoke-RestMethod -Uri $webhook -Method Post -Body $body -ContentType 'application/json'
  ```

---

## 📊 Files in Your Repository

```
discord-newsletter-bot/
├── .github/
│   └── workflows/
│       └── daily.yml          ← GitHub Actions automation
├── .gitignore                 ← Protects .env file
├── .env.example              ← Template for local testing
├── main.py                   ← Main automation script
├── requirements.txt          ← Python dependencies
├── README.md                 ← Full documentation
├── setup_github.ps1          ← This PowerShell script
└── setup_github.sh           ← Bash script (for Linux/Mac)
```

---

## ✅ Success Checklist

- [ ] GitHub repository created
- [ ] Code pushed to GitHub
- [ ] `DISCORD_WEBHOOK_URL` secret added
- [ ] `GEMINI_API_KEY` secret added
- [ ] Workflow manually triggered
- [ ] Received test messages in Discord
- [ ] Automation running daily

---

**Need Help?** Check the full README.md for detailed troubleshooting!
