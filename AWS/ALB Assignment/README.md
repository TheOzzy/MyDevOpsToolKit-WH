# AWS Application Load Balancer Assignment

## Overview

This project demonstrates a common AWS and DevOps architecture: **multiple EC2 instances behind an Application Load Balancer (ALB)**.

The aim of the assignment was to understand how an ALB distributes HTTP traffic, performs health checks, and works with Security Groups to ensure that users access the application **through the load balancer rather than directly through the EC2 instances**.

The project also helped reinforce AWS networking concepts including:

- VPCs
- Subnets
- Availability Zones
- Internet Gateways
- Route Tables
- Security Groups
- EC2
- Application Load Balancers
- Target Groups
- Health Checks

---

## Architecture

![AWS Application Load Balancer with Two EC2 Instances](media/Adobe%20Express%20-%200915.gif)


> The EC2 instances were placed in separate Availability Zones to improve resilience.  
> For this learning lab, the instances were launched in public subnets so that software could be installed easily, but their Security Group prevents direct HTTP access from the internet.

---

## Traffic Flow

The request flow is:

```text
User
  |
  v
Application Load Balancer
  |
  v
Target Group
  |
  +------> EC2 Instance 1
  |
  +------> EC2 Instance 2
```

The ALB receives HTTP requests on port `80` and forwards them to healthy instances registered in the Target Group.

The end user does not need to know which EC2 instance handles the request.

---

## AWS Resources Used

| Resource | Purpose |
|---|---|
| VPC | Provides an isolated AWS network |
| 2 Public Subnets | Provide networking across two Availability Zones |
| Internet Gateway | Allows internet connectivity for the VPC |
| Route Table | Routes `0.0.0.0/0` traffic through the Internet Gateway |
| 2 EC2 Instances | Host two versions of the test web application |
| EC2 Security Group | Allows HTTP only from the ALB Security Group |
| ALB Security Group | Allows HTTP from the internet |
| Application Load Balancer | Receives and distributes incoming HTTP requests |
| Target Group | Groups the EC2 instances behind the ALB |
| Health Checks | Determines whether an EC2 target is healthy |

---

# Build Process

## 1. Create the VPC

A custom VPC was used:

```text
10.0.0.0/24
```

This provides the private IPv4 address space used by the subnets and EC2 instances.

---

## 2. Create Two Public Subnets

Two `/27` subnets were created in different Availability Zones.

Example:

```text
Public Subnet A
CIDR: 10.0.0.0/27
AZ: eu-west-2a
```

```text
Public Subnet B
CIDR: 10.0.0.32/27
AZ: eu-west-2b
```

Using separate Availability Zones improves resilience because the architecture does not rely on a single AZ.

---

## 3. Attach an Internet Gateway

An Internet Gateway was created and attached to the VPC.

The public subnet Route Table was then updated with:

```text
Destination: 0.0.0.0/0
Target: Internet Gateway
```

This is what makes the subnets internet-routable.

---

## 4. Create the Security Groups

Two Security Groups were used.

### ALB Security Group

Inbound:

```text
Type: HTTP
Protocol: TCP
Port: 80
Source: 0.0.0.0/0
```

This allows users on the internet to access the Application Load Balancer.

### EC2 Security Group

Inbound:

```text
Type: HTTP
Protocol: TCP
Port: 80
Source: ALB Security Group
```

This is one of the most important parts of the architecture.

The EC2 instances do **not** accept HTTP traffic directly from the internet. They only accept HTTP requests that originate from the ALB Security Group.

---

## 5. Launch Two EC2 Instances

Two EC2 instances were launched:

```text
EC2 Instance 1 -> Availability Zone A
EC2 Instance 2 -> Availability Zone B
```

Both instances use the same EC2 Security Group.

The instances were configured to serve HTTP traffic on port `80`.

---

# Web Application

A lightweight Python HTTP server was used for the test application.

Each EC2 instance returned different content so that load balancing could be demonstrated visually.

Example Python application:

```python
import http.server
import socketserver

PORT = 80

class EC2WebServerHandler(http.server.SimpleHTTPRequestHandler):
    def do_GET(self):
        if self.path == "/":
            self.send_response(200)
            self.send_header("Content-type", "text/html; charset=utf-8")
            self.end_headers()

            html_content = """
            <!DOCTYPE html>
            <html>
            <head>
                <title>EC2 Instance 1</title>
            </head>
            <body>
                <h1>AWS EC2 Instance 1</h1>
                <p>Application is running successfully.</p>
            </body>
            </html>
            """

            self.wfile.write(html_content.encode("utf-8"))
        else:
            super().do_GET()

with socketserver.TCPServer(("", PORT), EC2WebServerHandler) as httpd:
    print(f"Listening on port {PORT}")
    httpd.serve_forever()
```

The second server used the same application but displayed:

```text
AWS EC2 Instance 2
```

This made it easy to see which backend instance handled each request.

---

## 6. Create the Target Group

A Target Group was created with:

```text
Target type: Instances
Protocol: HTTP
Port: 80
IP version: IPv4
```

Both EC2 instances were registered as targets.

---

## 7. Configure Health Checks

The Target Group health check was configured with:

```text
Protocol: HTTP
Path: /
Port: Traffic Port
```

The ALB periodically sends HTTP requests to `/`.

If the server returns a successful response, the target becomes:

```text
Healthy
```

If a target stops responding, the ALB can remove it from normal request routing until it becomes healthy again.

---

## 8. Create the Application Load Balancer

The ALB was configured as:

```text
Scheme: Internet-facing
IP address type: IPv4
Listener: HTTP : 80
```

It was deployed across both public subnets.

The listener forwards requests to the Target Group containing the two EC2 instances.

---

# Testing

After both instances became healthy, the ALB DNS name was opened in a browser.

Example:

```text
http://<ALB-DNS-NAME>
```

Refreshing the page resulted in responses from both backend instances:

```text
AWS EC2 Instance 1
AWS EC2 Instance 2
AWS EC2 Instance 1
AWS EC2 Instance 2
```

This demonstrated that requests were being distributed between the two registered targets.

---

## Demo

A GIF can be added here to demonstrate the load balancer switching between both instances:

```md
![ALB Load Balancing Demo](docs/alb-demo.gif)
```

Recommended repository structure:

```text
.
├── README.md
├── docs/
│   ├── architecture.png
│   └── alb-demo.gif
└── app/
    ├── instance-1.py
    └── instance-2.py
```

---

# Troubleshooting and Lessons Learned

A large part of this lab involved troubleshooting the architecture rather than simply creating resources.

## ALB VPC was unavailable

When creating the ALB, the custom VPC initially appeared unavailable.

### Cause

The VPC did not have an Internet Gateway attached.

### Fix

An Internet Gateway was created and attached to the VPC.

---

## Public subnet warning

The ALB reported that the selected subnets did not have an Internet Gateway route.

### Cause

The Route Table only contained the local VPC route.

### Fix

The following route was added:

```text
0.0.0.0/0 -> Internet Gateway
```

---

## EC2 instances could not download packages

Package installation initially failed.

### Cause

The EC2 Security Group had no outbound rule.

### Fix

Outbound connectivity was restored so the instance could initiate connections to the internet.

This reinforced an important concept:

> A route provides the network path, while the Security Group determines whether traffic is permitted.

---

## Target Group showed "Request timed out"

Both EC2 targets initially appeared as unhealthy even though the web application worked with:

```bash
curl localhost
```

### Cause

The Application Load Balancer had been attached to the wrong Security Group.

The EC2 Security Group allowed HTTP from the intended ALB Security Group, but the ALB was actually using a different Security Group.

### Fix

The correct ALB Security Group was attached to the Application Load Balancer.

After the next health checks completed, both targets changed to:

```text
Healthy
```

This was one of the most useful lessons from the project because it demonstrated how Security Groups can reference other Security Groups instead of relying on IP addresses.

---

# Key Concepts Learned

## Security Groups

The ALB and EC2 instances use separate Security Groups.

```text
Internet
    |
    | HTTP 80
    v
ALB Security Group
    |
    | HTTP 80
    v
EC2 Security Group
```

The EC2 instances trust the **ALB Security Group**, not the entire internet.

---

## Health Checks

A running EC2 instance does not automatically mean the application is healthy.

For example:

```text
EC2 = Running
Python Web Server = Stopped
```

The ALB health check would fail because nothing is responding on port `80`.

The ALB therefore checks the **application**, not simply whether the EC2 instance exists.

---

## High Availability

The EC2 instances were spread across different Availability Zones.

```text
AZ-A -> EC2 Instance 1
AZ-B -> EC2 Instance 2
```

If one target becomes unavailable, the ALB can continue sending traffic to another healthy target.

---

## Load Balancing vs Self-Healing

The Application Load Balancer distributes traffic, but it does not recreate failed EC2 instances.

A future improvement would be to add an:

```text
Auto Scaling Group
```

This could automatically replace unhealthy instances or increase capacity when demand grows.

---

# Possible Improvements

Future versions of this project could include:

- Auto Scaling Groups
- HTTPS using AWS Certificate Manager
- Route 53 custom DNS
- Private EC2 subnets
- NAT Gateway or VPC endpoints
- AWS Systems Manager Session Manager
- CloudWatch monitoring and alarms
- Infrastructure as Code using Terraform
- Automated deployment using GitHub Actions

A more production-oriented architecture would normally keep application EC2 instances in **private subnets**, with only the ALB exposed publicly.

---

# Cleanup

To avoid unnecessary AWS charges after completing the lab, the following resources should be removed when no longer required:

1. Application Load Balancer
2. Target Group
3. EC2 Instances
4. Security Groups
5. Internet Gateway
6. Custom Route Tables
7. Subnets
8. VPC

---

# Outcome

The final architecture successfully:

- Served HTTP traffic through an AWS Application Load Balancer
- Distributed requests between two EC2 instances
- Used two Availability Zones
- Performed HTTP health checks
- Prevented direct HTTP access to the EC2 instances
- Used Security Group referencing between the ALB and EC2 instances
- Demonstrated resilience when multiple backend servers are available

This project provided hands-on experience with one of the most common AWS application architectures and strengthened my understanding of how networking, security, health checks, and load balancing work together.
