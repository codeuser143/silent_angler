<?php
function escape($value) {
    return htmlspecialchars((string)$value, ENT_QUOTES, 'UTF-8');
}

$data_file = __DIR__ . '/data.json';
$entries = [];

if (is_readable($data_file)) {
    $handle = fopen($data_file, 'r');
    if ($handle) {
        while (($line = fgets($handle)) !== false) {
            $item = json_decode(trim($line), true);
            if (!$item || !isset($item['data']) || !is_array($item['data'])) {
                continue;
            }
            $data = $item['data'];
            if (isset($data['latitude']) && isset($data['longitude'])) {
                $entries[] = [
                    'timestamp' => $item['timestamp'] ?? '',
                    'latitude' => $data['latitude'],
                    'longitude' => $data['longitude'],
                    'mapLink' => $data['mapLink'] ?? "https://maps.google.com/?q=" . $data['latitude'] . "," . $data['longitude'],
                    'accuracy' => $data['accuracy'] ?? '',
                    'altitude' => $data['altitude'] ?? '',
                    'speed' => $data['speed'] ?? '',
                    'heading' => $data['heading'] ?? '',
                    'ip' => $item['ip'] ?? '',
                    'userAgent' => $item['user_agent'] ?? '',
                    'raw' => $item['raw_input'] ?? '',
                ];
            }
        }
        fclose($handle);
    }
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>LocateX Report</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 0; padding: 20px; background: #f7f7f7; color: #222; }
        h1 { margin-top: 0; }
        table { width: 100%; border-collapse: collapse; margin-top: 16px; }
        th, td { border: 1px solid #ddd; padding: 10px; text-align: left; }
        th { background: #222; color: #fff; }
        tr:nth-child(even) { background: #fafafa; }
        .nowrap { white-space: nowrap; }
        .small { font-size: 0.9em; color: #555; }
        a.button { display: inline-block; padding: 8px 12px; background: #007bff; color: #fff; text-decoration: none; border-radius: 4px; }
    </style>
</head>
<body>
    <h1>LocateX GPS Report</h1>
    <p>Showing captured device coordinates and map links from <code>data.json</code>.</p>
    <p><a class="button" href="data.json" target="_blank">View raw JSON</a></p>
    <?php if (count($entries) === 0): ?>
        <p>No GPS entries found yet.</p>
    <?php else: ?>
        <table>
            <thead>
                <tr>
                    <th>Timestamp</th>
                    <th>Latitude</th>
                    <th>Longitude</th>
                    <th>Map Link</th>
                    <th>Accuracy</th>
                    <th>IP</th>
                    <th>User Agent</th>
                </tr>
            </thead>
            <tbody>
                <?php foreach (array_reverse($entries) as $entry): ?>
                    <tr>
                        <td class="nowrap"><?php echo escape($entry['timestamp']); ?></td>
                        <td><?php echo escape($entry['latitude']); ?></td>
                        <td><?php echo escape($entry['longitude']); ?></td>
                        <td><a href="<?php echo escape($entry['mapLink']); ?>" target="_blank">Open map</a></td>
                        <td><?php echo escape($entry['accuracy']); ?></td>
                        <td><?php echo escape($entry['ip']); ?></td>
                        <td class="small"><?php echo escape($entry['userAgent']); ?></td>
                    </tr>
                <?php endforeach; ?>
            </tbody>
        </table>
    <?php endif; ?>
</body>
</html>
