<?php
// Enhanced IP capture for LocateX
if (!empty($_SERVER['HTTP_CLIENT_IP'])) {
    $ipaddress = $_SERVER['HTTP_CLIENT_IP'];
} elseif (!empty($_SERVER['HTTP_X_FORWARDED_FOR'])) {
    $ipaddress = $_SERVER['HTTP_X_FORWARDED_FOR'];
} else {
    $ipaddress = $_SERVER['REMOTE_ADDR'];
}

$useragent = $_SERVER['HTTP_USER_AGENT'];
$timestamp = date('Y-m-d H:i:s');

// Write to ip.txt
$log = "Timestamp: $timestamp\n";
$log .= "IP: $ipaddress\n";
$log .= "User-Agent: $useragent\n";
$log .= "----------------------------------------\n";

file_put_contents('ip.txt', $log, FILE_APPEND);
?>