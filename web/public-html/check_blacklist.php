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

?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Check Blacklist</title>
    <style>
        body {
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            font-family: Arial, sans-serif;
            margin: 0;
            overflow: hidden;
        }
        .container {
            text-align: center;
        }
        .result {
            margin-top: 20px;
            font-weight: bold;
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
        <h1>Check if IP/Domain is blacklisted</h1>
        <form id="checkForm">
            <input type="text" id="value" name="value" required>
            <button type="submit">Check</button>
        </form>
        <div id="message" class="result"></div>
        <a class="home-link" href="/">&larr; Go back to homepage</a>
    </div>
    <script>
        document.getElementById('checkForm').addEventListener('submit', function(event) {
            event.preventDefault();
            var value = document.getElementById('value').value;

            function reverseIP(ip) {
                return ip.split('.').reverse().join('.');
            }

            var isIP = /^(\d{1,3}\.){3}\d{1,3}$/.test(value);
            var queryName = isIP ? reverseIP(value) + '.rbl.<?php echo getenv('RBL_DOMAIN')?>' : value + '.rbl.<?php echo getenv('RBL_DOMAIN')?>';

            fetch('https://cloudflare-dns.com/dns-query?name=' + encodeURIComponent(queryName) + '&type=A', {
                headers: {
                    'Accept': 'application/dns-json'
                }
            })
                .then(response => response.json())
                .then(data => {
                    if (data.Status === 0 && data.Answer && data.Answer.length > 0 && data.Answer[0].data === '127.0.0.2') {
                        document.getElementById('message').innerText = "The IP/Domain '" + value + "' is blacklisted.";
                    } else {
                        document.getElementById('message').innerText = "The IP/Domain '" + value + "' is not blacklisted.";
                    }
                })
                .catch(error => {
                    console.error('Error checking blacklist:', error);
                    document.getElementById('message').innerText = "An error occurred while checking the blacklist.";
                });
        });
    </script>
    <?php include 'footer.php'; ?>
</body>
</html>
