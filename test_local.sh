#!/bin/bash

# Quick Test Script - Run this to test locally before GitHub deployment

echo "🧪 Testing AI Newsletter Bot Locally..."
echo "========================================"
echo ""

# Check if .env file exists
if [ ! -f .env ]; then
    echo "❌ .env file not found!"
    echo "Creating .env from your credentials..."
    
    echo "Creating template .env file..."
    
    cat > .env << 'EOL'
DISCORD_WEBHOOK_URL=<YOUR_WEBHOOK_URL>
GEMINI_API_KEY=<YOUR_GEMINI_API_KEY>
EOL
    
    echo "⚠️  .env file created with placeholders."
    echo "Please edit .env and add your actual API keys before running."
    exit 1
fi
    
    echo "✅ .env file created!"
fi

echo ""
echo "📦 Installing dependencies..."
pip3 install -q -r requirements.txt

if [ $? -eq 0 ]; then
    echo "✅ Dependencies installed!"
    echo ""
    echo "🚀 Running newsletter bot..."
    echo "========================================"
    echo ""
    
    python3 main.py
    
    echo ""
    echo "========================================"
    if [ $? -eq 0 ]; then
        echo "✅ Test completed! Check your Discord channel!"
    else
        echo "❌ Test failed. Check the error messages above."
    fi
else
    echo "❌ Failed to install dependencies"
    exit 1
fi
