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