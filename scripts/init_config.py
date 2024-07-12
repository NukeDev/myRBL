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

import os

def main():
    file_path = '/etc/bind/named.conf.local'

    with open(file_path, 'r') as file:
        file_content = file.read()

    new_file_content = file_content.replace('RBL_DOMAIN_PLACEHOLDER', os.getenv('RBL_DOMAIN'))

    with open(file_path, 'w') as file:
        file.write(new_file_content)
        
if __name__ == "__main__":
    main()