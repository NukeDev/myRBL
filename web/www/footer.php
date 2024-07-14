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
    <style>
        .footer {
            text-align: center;
            padding: 20px;
            background-color: #f1f1f1;
            position: fixed;
            left: 0;
            bottom: 0;
            width: 100%;
            font-family: Arial, sans-serif;
        }
        .footer p {
            margin: 5px 0;
            font-size: 14px;
        }
        .footer a {
            color: #333;
            text-decoration: none;
            font-weight: bold;
        }
        .footer a:hover {
            text-decoration: underline;
        }
        .footer .github-icon {
            width: 20px;
            vertical-align: middle;
            margin-right: 5px;
        }
    </style>
</head>
<body>
    <div class="footer">
        <p>
            <a href="https://github.com/NukeDev/MyRBL" target="_blank">
                <img src="https://cdn-icons-png.flaticon.com/512/25/25231.png" alt="GitHub" class="github-icon">
                NukeDev/MyRBL
            </a>
        </p>
        <p>
            This is a free and open source Realtime Blackhole List (RBL) project.
        </p>
        <p>
            &copy; <?php echo date("Y"); ?> MyRBL. All rights reserved.
        </p>
    </div>
</body>
</html>