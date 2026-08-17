<?php
// Advanced webhook for LocateX
header('Content-type: application/json');

// Receive JSON data
$data = json_decode(file_get_contents('php://input'), true);

// Log timestamp
$timestamp = date('Y-m-d H:i:s');

// Format for data.txt (plain text)
$log_entry = "\n[" . $timestamp . "]\n";
if ($data) {
    foreach ($data as $key => $value) {
        if (is_array($value) || is_object($value)) {
            $value = json_encode($value);
        }
        $log_entry .= "$key: $value\n";
    }
} else {
    // Fallback for IP capture
    $log_entry .= "IP: " . $_SERVER['REMOTE_ADDR'] . "\n";
    $log_entry .= "User-Agent: " . $_SERVER['HTTP_USER_AGENT'] . "\n";
}

// Append to data.txt
file_put_contents('data.txt', $log_entry, FILE_APPEND);

// Fallback logging for raw input if JSON parsing fails
if (!$data) {
    $raw_input = file_get_contents('php://input');
    if ($raw_input) {
        file_put_contents('data.txt', "Raw input: " . $raw_input . "\n", FILE_APPEND);
    }
}

// Also save as JSON for structured data
$json_entry = json_encode([
    'timestamp' => $timestamp,
    'data' => $data,
    'raw_input' => $raw_input ?? null,
    'ip' => $_SERVER['REMOTE_ADDR'],
    'user_agent' => $_SERVER['HTTP_USER_AGENT']
]) . "\n";

file_put_contents('data.json', $json_entry, FILE_APPEND);

// Return success response
echo json_encode(['status' => 'success', 'message' => 'Data received']);
?>