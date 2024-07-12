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

import mysql.connector # type: ignore
import logging
import os


db_config = {
    'user': os.getenv('DB_USER'),
    'password': os.getenv('DB_PASSWORD'),
    'host': os.getenv('DB_HOST'),
    'database': os.getenv('DB_NAME')
}


logging.basicConfig(
    format='%(asctime)s - [create_database.py] %(message)s',
    level=logging.INFO 
)
create_domain_blacklist_table = """
CREATE TABLE IF NOT EXISTS domain_blacklist (
    domain VARCHAR(255) PRIMARY KEY,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
)
"""

create_ip_blacklist_table = """
CREATE TABLE IF NOT EXISTS ip_blacklist (
    ip_address VARCHAR(45) PRIMARY KEY,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
)
"""

def create_database_and_tables():
    try:
        connection = mysql.connector.connect(**db_config)
        cursor = connection.cursor()

        cursor.execute("CREATE DATABASE IF NOT EXISTS rbl")
        cursor.execute("USE rbl")

        cursor.execute(create_domain_blacklist_table)
        cursor.execute(create_ip_blacklist_table)

        connection.commit()
        logging.info("Tables created/checked.")

    except mysql.connector.Error as error:
        logging.info(f"Error while creating/checking tables: {error}")

    finally:
        if 'connection' in locals() and connection.is_connected():
            cursor.close()
            connection.close()
            logging.info("Connection db closed.")

if __name__ == "__main__":
    create_database_and_tables()