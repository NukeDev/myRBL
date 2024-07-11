import requests
import mysql.connector # type: ignore
from mysql.connector import errorcode # type: ignore
import subprocess
import logging
import datetime
import os

db_config = {
    'user': os.getenv('DB_USER'),
    'password': os.getenv('DB_PASSWORD'),
    'host': os.getenv('DB_HOST'),
    'database': os.getenv('DB_NAME')
}

URL_EXT_IP_ADDRESSES_BLACKLIST = os.getenv('URL_EXT_IP_ADDRESSES_BLACKLIST')
URL_EXT_DOMAINS_BLACKLIST = os.getenv('URL_EXT_DOMAINS_BLACKLIST')


logging.basicConfig(
    format='%(asctime)s - [update_db_ext_blacklist.py] %(message)s',
    level=logging.INFO 
)

create_ip_blacklist_table = """
CREATE TABLE IF NOT EXISTS ip_ext_blacklist (
    ip_address VARCHAR(45) PRIMARY KEY,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
)
"""

create_domain_blacklist_table = """
CREATE TABLE IF NOT EXISTS domain_ext_blacklist (
    domain VARCHAR(255) PRIMARY KEY,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
)
"""

def restart_named():
    try:
        subprocess.run(['/usr/sbin/service', 'named', 'restart'], check=True)
        logging.info("Named service restarted successfully.")
    except subprocess.CalledProcessError as e:
        logging.info(f"Error restarting Named service: {e}")

def create_tables_if_not_exists():
    try:

        connection = mysql.connector.connect(**db_config)
        cursor = connection.cursor()
        cursor.execute("USE rbl")
        cursor.execute(create_domain_blacklist_table)
        cursor.execute(create_ip_blacklist_table)
        cursor.execute("DELETE FROM domain_ext_blacklist")
        cursor.execute("DELETE FROM ip_ext_blacklist")
        connection.commit()

    except mysql.connector.Error as error:
        logging.info(f"Error while creating Ext tables: {error}")

    finally:
        if 'connection' in locals() and connection.is_connected():
            cursor.close()
            connection.close()
            logging.info("Connection db closed.")

def fetch_and_process_file_ip(url):
    try:
        response = requests.get(url)
        response.raise_for_status()  
        file_content = response.text

        inverted_ips = []
        for line in file_content.splitlines():
            if not line.startswith('#'):
                parts = line.split()
                if len(parts) > 0:
                    ip = parts[0]
                    inverted_ip = '.'.join(ip.split('.')[::-1])
                    inverted_ips.append(inverted_ip)  
        return inverted_ips
    except requests.RequestException as e:
        logging.info(f"Error while downloading data: {e}")
        return []
    
def fetch_and_process_file_domains(url):
    try:
        response = requests.get(url)
        response.raise_for_status()  
        file_content = response.text
        domains = []
        for line in file_content.splitlines():
               domains.append(line)  
        return domains
    except requests.RequestException as e:
        logging.info(f"Error while downloading data: {e}")
        return []


def insert_domains_to_mysql(domains):
    try:
        conn = mysql.connector.connect(**db_config)
        cursor = conn.cursor()
        insert_query = "INSERT INTO domain_ext_blacklist (domain) VALUES (%s)"
        for dom in list(dict.fromkeys(domains)):
            cursor.execute(insert_query, (dom.strip(),))
        conn.commit()

    except mysql.connector.Error as err:
        if err.errno == errorcode.ER_ACCESS_DENIED_ERROR:
            logging.info("Error login access")
        elif err.errno == errorcode.ER_BAD_DB_ERROR:
            logging.info("Db not exists")
        else:
            logging.info(err)
    finally:
        cursor.close()
        conn.close()

def insert_ips_to_mysql(inverted_ips):
    try:
        conn = mysql.connector.connect(**db_config)
        cursor = conn.cursor()
        insert_query = "INSERT INTO ip_ext_blacklist (ip_address) VALUES (%s)"
        for ip in list(dict.fromkeys(inverted_ips)):
            cursor.execute(insert_query, (ip.strip(),))
        conn.commit()

    except mysql.connector.Error as err:
        if err.errno == errorcode.ER_ACCESS_DENIED_ERROR:
            logging.info("Error login access")
        elif err.errno == errorcode.ER_BAD_DB_ERROR:
            logging.info("Db not exists")
        else:
            logging.info(err)
    finally:
        cursor.close()
        conn.close()

def main():
    timestamp = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    logging.info(f'Exec update_db_ext_blacklist.py started {timestamp}')
    create_tables_if_not_exists()
    logging.info("Tables data deleted! Fetching data...")
    domains = fetch_and_process_file_domains(URL_EXT_DOMAINS_BLACKLIST)
    ips = fetch_and_process_file_ip(URL_EXT_IP_ADDRESSES_BLACKLIST)
    logging.info("Data downloaded! Updating database...")
    insert_ips_to_mysql(ips)
    insert_domains_to_mysql(domains)
    logging.info("Data updated!")

if __name__ == "__main__":
    main()