# Cloud-Hosted Web Server Showcase

A professional demonstration of cloud infrastructure, networking, and web orchestration. This project showcases the end-to-end process of deploying a web server on **AWS EC2**, configuring a **high-performance NGINX** environment, and managing global **DNS routing** via a custom domain.

## 🏗️ Architecture Overview

The project integrates three primary layers of web infrastructure:

*   **Compute Layer:** An Amazon EC2 instance running a Linux distribution, optimised for hosting.
*   **Web Layer:** NGINX acting as the primary web server to handle HTTP requests.
*   **Networking Layer:** Custom DNS records (A Records) mapping a personal domain to a static cloud IP.

## 🔗 Live Demo
The project is live and accessible via the custom domain:  
**Visit Website - http://www.fiftyfour.click**

## 🛠️ Tech Stack

*   **Cloud Provider:** AWS (EC2, Security Groups)
*   **Web Server:** NGINX
*   **DNS Management:** Route53 / Cloudflare
*   **OS:** Amazon Linux 2 / Ubuntu

## 🚀 Key Features

*   **Custom Domain Integration:** Seamlessly routes traffic from a personalized domain directly to the cloud instance.
*   **Secure Networking:** Configured Security Groups to allow specific inbound traffic on Port 80 (HTTP).
*   **Automated Service Management:** NGINX is configured to boot on system startup, ensuring 24/7 availability.

## 📖 Deployment Summary

1.  **Provisioning:** Launched a scalable EC2 instance with tailored security rules.
2.  **Server Setup:** Installed and initialised NGINX to serve as the gateway for web traffic.
3.  **DNS Configuration:** Established an **A Record** within the domain registrar to point the human-readable URL to the server's Public IPv4 address.
4.  **Verification:** Validated end-to-end connectivity via browser testing and DNS propagation checks.

5.  
