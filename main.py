"""
AI Newsletter Automation
Fetches, summarizes, and sends AI newsletters to Discord
"""

import os
import sys
import feedparser
import requests
from datetime import datetime, timedelta
from typing import List, Dict, Optional
import json
from google import genai
from google.genai import types
from bs4 import BeautifulSoup
import re

# Configuration
DISCORD_WEBHOOK_URL = os.getenv('DISCORD_WEBHOOK_URL')
GEMINI_API_KEY = os.getenv('GEMINI_API_KEY')


# Newsletter Sources
NEWSLETTER_SOURCES = {
    'TLDR AI': {
        'url': 'https://tldr.tech/api/rss/ai',
        'type': 'rss'
    },
    'The Rundown AI': {
        'url': 'https://rss.beehiiv.com/feeds/2R3C6Bt5wj.xml',
        'type': 'rss'
    },
    'AI Search': {
        'url': 'https://aisearch.substack.com/feed',
        'type': 'rss'
    }
}

def setup_gemini():
    """Initialize Gemini API"""
    if not GEMINI_API_KEY:
        raise ValueError("GEMINI_API_KEY not found in environment variables")
    
    client = genai.Client(api_key=GEMINI_API_KEY)
    return client

def fetch_rss_feed(url: str, newsletter_name: str) -> Optional[Dict]:
    """Fetch and parse RSS feed using requests (bypassing Cloudflare often)"""
    try:
        print(f"Fetching RSS feed for {newsletter_name}...")
        
        headers = {
            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36',
            'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8',
            'Upgrade-Insecure-Requests': '1',
            'Referer': 'https://www.google.com/'
        }
        
        response = requests.get(url, headers=headers, timeout=15)
        response.raise_for_status()
        
        # Parse content
        feed = feedparser.parse(response.content)
        
        if not feed.entries:
            print(f"No entries found in {newsletter_name}")
            return None
        
        # Get the latest entry
        latest = feed.entries[0]
        
        # Extract content - prefer full content over summary
        content_data = latest.get('content', [{}])[0].get('value', '')
        summary_data = latest.get('summary', '') or latest.get('description', '')
        
        # Use content if available and longer than summary, else fallback to summary
        content = content_data if content_data and len(content_data) > len(summary_data) else summary_data
        
        # Clean HTML tags
        soup = BeautifulSoup(content, 'html.parser')
        clean_content = soup.get_text(separator='\n', strip=True)
        
        return {
            'title': latest.get('title', 'No Title'),
            'link': latest.get('link', ''),
            'content': clean_content[:5000],  # Limit content length
            'published': latest.get('published', 'Unknown date'),
            'source': newsletter_name
        }
    except Exception as e:
        print(f"Error fetching {newsletter_name}: {str(e)}")
        return None



def summarize_with_gemini(client, article: Dict) -> str:
    """Generate a concise summary using Gemini API"""
    try:
        prompt = f"""You are an expert at creating concise, actionable summaries of AI newsletters for busy professionals.

ARTICLE TITLE: {article['title']}
SOURCE: {article['source']}
PUBLISHED: {article['published']}

ARTICLE CONTENT:
{article['content']}

INSTRUCTIONS:
Create a summary that can be read in 5 minutes or less. Format your response EXACTLY as follows:

🔑 KEY HIGHLIGHTS (3-5 bullet points)
• [Most important news/development]
• [Second key point]
• [Third key point]

💡 MAIN TAKEAWAYS (2-3 bullet points)
• [What this means for AI practitioners/enthusiasts]
• [Practical implications]

🔗 NOTABLE MENTIONS (if applicable)
• [Any significant tools, companies, or research mentioned]

📺 YOUTUBE LINKS (if applicable)
• [Link to video] - [Brief description]

Keep it sharp, skip the fluff, and focus on what matters. Use emojis sparingly for visual appeal.
"""
        
        print(f"Generating summary for {article['source']}...")
        
        response = client.models.generate_content(
            model='gemma-3-27b-it',  # Updated model as per user request
            contents=prompt
        )
        return response.text
        
    except Exception as e:
        print(f"Error generating summary: {str(e)}")
        return f"**Error generating summary for {article['source']}**\n\nOriginal title: {article['title']}\nLink: {article['link']}"

def send_to_discord(content: str, article: Dict):
    """Send summary to Discord via webhook"""
    try:
        if not DISCORD_WEBHOOK_URL:
            raise ValueError("DISCORD_WEBHOOK_URL not found")
        
        # Create Discord embed
        embed = {
            "title": f"📰 {article['source']}",
            "description": article['title'],
            "url": article['link'],
            "color": 5814783,  # Blue color
            "fields": [
                {
                    "name": "Summary",
                    "value": content[:1024],  # Discord field limit
                    "inline": False
                }
            ],
            "footer": {
                "text": f"Published: {article['published']} • Automated by AI Newsletter Bot"
            },
            "timestamp": datetime.utcnow().isoformat()
        }
        
        # If summary is too long, split it
        if len(content) > 1024:
            remaining_content = content[1024:]
            chunks = [remaining_content[i:i+1024] for i in range(0, len(remaining_content), 1024)]
            
            for i, chunk in enumerate(chunks[:5]):  # Limit to 6 fields total
                embed["fields"].append({
                    "name": f"Summary (continued {i+1})",
                    "value": chunk,
                    "inline": False
                })
        
        payload = {
            "username": "AI Newsletter Digest",
            "embeds": [embed]
        }
        
        response = requests.post(DISCORD_WEBHOOK_URL, json=payload)
        response.raise_for_status()
        print(f"Sent {article['source']} to Discord")
        
    except Exception as e:
        print(f"Error sending to Discord: {str(e)}")

def main():
    """Main execution function"""
    print("Starting AI Newsletter Automation...")
    # Security Verified: No hardcoded keys present...
    print(f"Run time: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
    
    # Validate environment variables
    if not DISCORD_WEBHOOK_URL:
        print("DISCORD_WEBHOOK_URL not set!")
        sys.exit(1)
    
    if not GEMINI_API_KEY:
        print("GEMINI_API_KEY not set!")
        sys.exit(1)
    
    # Initialize Gemini
    try:
        model = setup_gemini()
    except Exception as e:
        print(f"Failed to initialize Gemini: {str(e)}")
        sys.exit(1)
    
    # Fetch and process newsletters
    articles_processed = 0
    
    for name, config in NEWSLETTER_SOURCES.items():
        print(f"\n{'='*50}")
        print(f"Processing: {name}")
        print(f"{'='*50}")
        
        # Fetch article
        if config['type'] == 'rss':
            article = fetch_rss_feed(config['url'], name)
        else:
            print(f"Unknown source type for {name}")
            continue

        if not article:
            print(f"Skipping {name} - no content retrieved")
            continue
        
        # Generate summary
        summary = summarize_with_gemini(model, article)
        
        # Send to Discord
        send_to_discord(summary, article)
        
        articles_processed += 1
        
        # Be nice to APIs - small delay between requests
        import time
        time.sleep(2)
    
    print(f"\n{'='*50}")
    print(f"Automation complete!")
    print(f"Processed {articles_processed}/{len(NEWSLETTER_SOURCES)} newsletters")
    print(f"{'='*50}")

if __name__ == "__main__":
    main()
