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
In addition to providing the open-source code for everyone, our goal is to host this RBL accessible to anyone (Rspamd, Spamassassin...).

## Using  MyRBL at rbl.l2m.io
The RBL (Real-time Blackhole List) at rbl.l2m.io allows you to check whether a domain or IP address is listed as malicious or spammy. This service can be integrated into your applications or scripts to enhance security measures.

### How to Use
To query the RBL, you need to perform DNS lookups against rbl.l2m.io by appending the domain or IP address you want to check.

### Querying Domains
To check if a domain is listed:

```bash
$ dig example.com.rbl.l2m.io A +short
```
If the domain example.com is blacklisted, this query will return an IP address (**127.0.0.2**). If not blacklisted, it returns nothing.

### Querying IP Addresses
For IP addresses, you first need to reverse the octets and append .rbl.l2m.io:

```bash
$ dig 1.2.0.192.rbl.l2m.io A +short
```
This will return **127.0.0.2** if the IP 192.0.2.1 is blacklisted.

## Integration
Integrate these queries into your application or script to automatically block or flag malicious domains or IPs based on their status in the RBL.

## Getting Started
- Clone the Repository: Download the source code from the GitHub repository.
- Setup the config file: Rename the file "config.ini.template" in "config.ini" and set the requested infos.
- Build the Containers: Use the Makefile to build and start the required containers.
- COMING SOON: Monitor and Manage: Use the web interface and log tools to monitor and manage blacklists.

## Contribution
As an open-source project, contributions are welcome. You can participate by reporting bugs, suggesting new features, or submitting pull requests.

## License
myRBL Dockerized is licensed under the GNU General Public License Version 3 (GPL-3.0), dated 29 June 2007, allowing users to freely use, modify, and distribute the software while ensuring that any modifications made to the software remain open-source.
