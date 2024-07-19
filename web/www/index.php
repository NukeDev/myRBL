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
<html>
<head>
    <title>MyRBL - <?php echo getenv('RBL_DOMAIN')?> Dashboard</title>
    <link rel="stylesheet" href="https://cdn.simplecss.org/simple.min.css">

    <!--style>
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
    </style-->
</head>
<header>
<h1>MyRBL - rbl.<?php echo getenv('RBL_DOMAIN')?></h1>
</header>
<body>
    
    <ul>
        <li><a href="check_blacklist.php">Check if IP/Domain is blacklisted</a></li>
        <li><a href="report_spam.php">Report IP/Domain as spam</a></li>
        <!--li><a href="/">View Statistics</a></li-->
    </ul>
</body>
<footer>
<?php include 'footer.php'; ?>
</footer>

</html>