#!/bin/bash
# SilentAngler Setup Script
# Author: codeuser143

echo -e "\e[1;92m╔══════════════════════════════════════════════════════════╗\e[0m"
echo -e "\e[1;92m║           SilentAngler Setup - Template Installation          ║\e[0m"
echo -e "\e[1;92m╚══════════════════════════════════════════════════════════╝\e[0m"

# Check if templates exist
echo -e "\e[1;93m[+] Checking template directories...\e[0m"

TEMPLATES=("_adobe" "badoo" "deviantart" "discord" "dropbox" "ebay" "facebook" "fb_advanced" "fb_messenger" "fb_security" "github" "gitlab" "google" "google_new" "google_poll" "ig_followers" "ig_verify" "instagram" "insta_followers" "linkedin" "mediafire" "microsoft" "netflix" "origin" "paypal" "pinterest" "playstation" "protonmail" "quora" "reddit" "roblox" "snapchat" "spotify" "stackoverflow" "steam" "tiktok" "twitch" "twitter" "vk" "vk_poll" "wordpress" "xbox" "yahoo" "yandex")

missing=0
for template in "${TEMPLATES[@]}"; do
    if [[ ! -d "templates/$template" ]]; then
        echo -e "\e[1;31m[✗] Missing: $template\e[0m"
        ((missing++))
    fi
done

if [[ $missing -eq 0 ]]; then
    echo -e "\e[1;92m[✓] All templates found!\e[0m"
else
    echo -e "\e[1;93m[!] $missing template(s) missing.\e[0m"
    echo -e "\e[1;96m[+] Place your template folders in the current directory.\e[0m"
fi

# Create required files
echo -e "\e[1;93m[+] Creating required files...\e[0m"
touch data.txt ip.txt saved.ip.txt targetreport.txt data.json

# Make main script executable
chmod +x silent_angler.sh

echo -e "\e[1;92m[✓] Setup complete! Run ./silent_angler.sh to start\e[0m"