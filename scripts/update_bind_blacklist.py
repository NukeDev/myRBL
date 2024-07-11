import mysql.connector # type: ignore
import subprocess
import logging
import datetime
import os

logging.basicConfig(
    format='%(asctime)s - [update_bind_blacklist.py] %(message)s',
    level=logging.INFO 
)

db_config = {
    'user': os.getenv('DB_USER'),
    'password': os.getenv('DB_PASSWORD'),
    'host': os.getenv('DB_HOST'),
    'database': os.getenv('DB_NAME')
}

RBL_DOMAIN = os.getenv('RBL_DOMAIN')
NS_PUBLIC_IP_ADDRESS = os.getenv('NS_PUBLIC_IP_ADDRESS')


def restart_named():
    try:
        subprocess.run(['/usr/sbin/service', 'named', 'restart'], check=True)
        logging.info("Named service restarted successfully.")
    except subprocess.CalledProcessError as e:
        logging.info(f"Error restarting Named service: {e}")

def main():
    cnx = mysql.connector.connect(**db_config)
    cursor = cnx.cursor()

    query_domains = "SELECT domain FROM domain_blacklist UNION SELECT domain FROM domain_ext_blacklist"
    cursor.execute(query_domains)
    domains = cursor.fetchall()

    query_ips = "SELECT ip_address FROM ip_blacklist UNION SELECT ip_address FROM ip_ext_blacklist"
    cursor.execute(query_ips)
    ips = cursor.fetchall()

    bind_config_path = '/etc/bind/db.blacklist'

    config_content = f"""$TTL    86400
@       IN      SOA     ns1.rbl.{RBL_DOMAIN}. info.{RBL_DOMAIN}. (
                        2024071001 ; Serial
                        3600       ; Refresh
                        1800       ; Retry
                        1209600    ; Expire
                        86400 )    ; Minimum TTL
    IN      NS      ns1.rbl.{RBL_DOMAIN}.

ns1.rbl.{RBL_DOMAIN}.     IN      A       {NS_PUBLIC_IP_ADDRESS}
"""
    
    domainsAdded = 0
    ipAddressesAdded = 0

    for (domain,) in domains:
        config_content += f"{domain}       IN      A       127.0.0.2\n"
        domainsAdded += 1
    logging.info(f"Domains added to blacklist {domainsAdded}")

    for (ip_address,) in ips:
        config_content += f"{ip_address}       IN      A       127.0.0.2\n"
        ipAddressesAdded += 1
    logging.info(f"Ip Addresses added to blacklist {ipAddressesAdded}")

    with open(bind_config_path, 'w') as f:
        f.write(config_content)
    logging.info("db.blacklist saved!")

    restart_named()

    cursor.close()
    cnx.close()


if __name__ == "__main__":
    main()