 # myRBL Dockerized

<a href="https://discord.gg/MYpbmNrvgc"><img src="https://img.shields.io/badge/Discord-5865F2?style=for-the-badge&logo=discord&logoColor=white" alt="Discord"></a>

## Project Description
myRBL Dockerized is an open-source project that enables the creation and management of a DNS RBL (Realtime Blackhole List) server to identify and block IP addresses and domains associated with spam and other malicious activities. Leveraging Docker, myRBL Dockerized provides a scalable and easy-to-deploy solution for system administrators and developers, offering an efficient way to secure email infrastructures and enhance network security.

## Key Features

- Easy Configuration: Utilizes Docker containers for simple and fast setup.
- Support for IPs and Domains: Manages blacklists for both IP addresses and domain names.
- COMING SOON: Web Interface: Includes a web interface for blacklist management and monitoring.
- Compatibility: Easily integrates with other security tools and mail servers.
- Open Source: Source code available to the community, promoting collaboration and continuous project improvement.

## Additional Objective
In addition to providing the open-source code for everyone, our goal is to host this RBL accessible to anyone (Rspamd, Spamassassin...), which will happen as soon as we release the first stable version.

## Getting Started
- Clone the Repository: Download the source code from the GitHub repository.
- Setup the config file: Rename the file "config.ini.template" in "config.ini" and set the requested infos.
- Build the Containers: Use the Makefile to build and start the required containers.
- COMING SOON: Monitor and Manage: Use the web interface and log tools to monitor and manage blacklists.

## Contribution
As an open-source project, contributions are welcome. You can participate by reporting bugs, suggesting new features, or submitting pull requests.

## License
myRBL Dockerized is licensed under the GNU General Public License Version 3 (GPL-3.0), dated 29 June 2007, allowing users to freely use, modify, and distribute the software while ensuring that any modifications made to the software remain open-source.
