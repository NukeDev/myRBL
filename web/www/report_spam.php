<?php

# =============================================================================
# myRBL Dockerized
# 
# Copyright (C) 2024 [NukeDev - Gianmarco Varriale]
# 
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program. If not, see <https://www.gnu.org/licenses/>.
# =============================================================================

$conn = new mysqli(getenv('DB_HOST'), getenv('DB_USER'), getenv('DB_PASSWORD'), getenv('DB_NAME'));

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

$message = '';
$report_count = 0;
$invalidFormat = false;

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $value = $_POST['value'];
    $motivation = $_POST['motivation'];

    if (filter_var($value, FILTER_VALIDATE_IP)) {
        $inverted_ip = implode('.', array_reverse(explode('.', $value)));
        $table = 'ip_reports';
        $column = 'ip_address';
        $value_to_check = $inverted_ip;
    } elseif (preg_match('/^(?!\-)(?:[a-zA-Z0-9\-]{0,62}[a-zA-Z0-9]\.){1,126}[a-zA-Z]{2,6}$/', $value)) {
        $table = 'domain_reports';
        $column = 'domain';
        $value_to_check = $value;
    } else {
        $invalidFormat = true;
        $message = "Invalid IP/Domain format.";
    }
    if (!$invalidFormat) {
        $stmt = $conn->prepare("INSERT INTO $table ($column, motivation) VALUES (?, ?)");
        $stmt->bind_param("ss", $value_to_check, $motivation);
        $stmt->execute();
    
        if ($stmt->affected_rows > 0) {
            $message = "The IP/Domain '$value' has been reported successfully.";
        } else {
            $message = "There was an error reporting the IP/Domain '$value'.";
        }
    
        $stmt->close();
    
        $stmt = $conn->prepare("SELECT COUNT(*) AS report_count FROM $table WHERE $column = ?");
        $stmt->bind_param("s", $value_to_check);
        $stmt->execute();
        $result = $stmt->get_result();
        $row = $result->fetch_assoc();
        $report_count = $row['report_count'];
    
        $stmt->close();
    }
    
}

$conn->close();
?>

<!DOCTYPE html>
<html>
<head>
    <title>Report IP/Domain Spam</title>
    <style>
        body {
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            font-family: Arial, sans-serif;
            margin: 0;
        }
        .container {
            text-align: center;
        }
        .result {
            margin-top: 20px;
            font-weight: bold;
        }
        .form-group {
            margin-bottom: 15px;
        }
        .home-link {
            display: inline-block;
            margin-top: 10px;
            font-size: 14px;
            text-decoration: none;
            color: #000;
        }
        .home-link:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Report IP/Domain Spam</h1>
        <form method="post">
            <div class="form-group">
                <label for="value">IP/Domain:</label>
                <input type="text" id="value" name="value" required>
            </div>
            <div class="form-group">
                <label for="motivation">Motivation (max 255 chars):</label>
                <input type="text" id="motivation" name="motivation" maxlength="255" required>
            </div>
            <button type="submit">Report</button>
        </form>
        <?php if ($message): ?>
            <div class="result">
                <?php echo $message; ?>
                <?php if ($report_count > 0): ?>
                    <p>This IP/Domain has been reported <?php echo $report_count; ?> times.</p>
                <?php endif; ?>
            </div>
        <?php endif; ?>
        <a class="home-link" href="/">&larr; Go back to homepage</a>
    </div>
</body>
<?php include 'footer.php'; ?>
</html>
