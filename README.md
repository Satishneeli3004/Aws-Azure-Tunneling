# Azure VM ↔ AWS EC2 Site-to-Site VPN Setup Guide

## Overview

This document describes the process of establishing a secure Site-to-Site VPN connection between an Azure Virtual Network (VNet) and an AWS Virtual Private Cloud (VPC). Once the VPN tunnel is established, resources in both clouds can communicate using private IP addresses.

---

# Architecture

```text
                   +--------------------------------+
                   |            Azure               |
                   |                                |
                   |   VNet: 10.0.0.0/16            |
                   |   VM:   10.0.1.4               |
                   |                                |
                   |  +-------------------------+   |
                   |  | Azure VPN Gateway      |    |
                   |  | Public IP: xx.xx.xx.xx |    |
                   |  +-------------------------+   |
                   +--------------+-----------------+
                                  |
                           IPsec VPN Tunnel
                                  |
                   +--------------+-----------------+
                   |  +-------------------------+   |
                   |  | AWS Virtual Private     |   |
                   |  | Gateway (VGW)           |   |
                   |  +-------------------------+   |
                   |                                |
                   |   VPC: 172.31.0.0/16           |
                   |   EC2: 172.31.10.100           |
                   |                                |
                   +--------------------------------+
```

---

# Prerequisites

## Azure

* Azure Subscription.
* Resource Group.
* Virtual Network (VNet).
* Azure VM.
* GatewaySubnet created inside the VNet.
* Virtual Network Gateway.

## AWS

* AWS Account.
* VPC.
* EC2 Instance.
* Virtual Private Gateway (VGW).
* Customer Gateway (CGW).
* Site-to-Site VPN Connection.

---

# Network Planning

| Component       | CIDR           |
| --------------- | -------------- |
| Azure VNet      | 10.0.0.0/16    |
| Azure VM Subnet | 10.0.1.0/24    |
| GatewaySubnet   | 10.0.25.0/27   |
| AWS VPC         | 172.31.0.0/16  |
| AWS EC2 Subnet  | 172.31.10.0/24 |

> **Important:** Azure and AWS CIDR ranges must not overlap.

---

# Azure Configuration

## Step 1: Create GatewaySubnet

Create a dedicated subnet named:

```
GatewaySubnet
```

Example:

```
10.0.25.0/27
```

No VMs should be deployed into this subnet.

---

## Step 2: Create Virtual Network Gateway

Navigate to:

```
Azure Portal
→ Virtual Network Gateway
→ Create
```

Use the following settings:

| Parameter            | Value         |
| -------------------- | ------------- |
| Gateway Type         | VPN           |
| VPN Type             | Route-based   |
| SKU                  | VpnGw1AZ      |
| Generation           | Generation1   |
| Active-Active        | Disabled      |
| BGP                  | Disabled      |
| Public IP SKU        | Standard      |
| Public IP Assignment | Static        |
| Virtual Network      | Existing VNet |
| GatewaySubnet        | GatewaySubnet |

Wait 30-45 minutes for deployment.

---

## Step 3: Note the Azure VPN Gateway Public IP

After deployment, copy:

```
Azure VPN Gateway Public IP
```

This IP will be used while creating the AWS Customer Gateway.

---

# AWS Configuration

## Step 1: Create Virtual Private Gateway (VGW)

Navigate:

```
AWS Console
→ VPC
→ Virtual Private Gateways
→ Create Virtual Private Gateway
```

Attach the VGW to your target VPC.

---

## Step 2: Create Customer Gateway (CGW)

Navigate:

```
VPC
→ Customer Gateways
→ Create Customer Gateway
```

| Parameter  | Value                       |
| ---------- | --------------------------- |
| Routing    | Static                      |
| IP Address | Azure VPN Gateway Public IP |
| BGP ASN    | Default                     |

---

## Step 3: Create Site-to-Site VPN Connection

Navigate:

```
VPC
→ Site-to-Site VPN Connections
→ Create VPN Connection
```

Settings:

| Parameter        | Value                         |
| ---------------- | ----------------------------- |
| Target Gateway   | Virtual Private Gateway       |
| Customer Gateway | Existing CGW                  |
| Routing          | Static                        |
| Static Route     | Azure VNet CIDR (10.0.0.0/16) |

After creation, AWS provides two VPN tunnel endpoints.

---

# Azure Local Network Gateway

Create a Local Network Gateway:

```
Azure Portal
→ Local Network Gateway
→ Create
```

Use:

* Public IP = AWS Tunnel Outside IP (Tunnel 1).
* Address Space = AWS VPC CIDR (e.g., 172.31.0.0/16).

---

# Azure VPN Connection

Navigate:

```
Azure Virtual Network Gateway
→ Connections
→ Add
```

| Parameter             | Value                |
| --------------------- | -------------------- |
| Connection Type       | Site-to-Site (IPsec) |
| Local Network Gateway | AWS LNG              |
| Shared Key (PSK)      | MyAzureAWS@123       |

---

# AWS Tunnel Configuration

Modify the VPN tunnel options and configure the same Pre-Shared Key:

```
MyAzureAWS@123
```

The PSK must match on both Azure and AWS.

---

# Route Table Configuration

## AWS Route Table

Edit the route table associated with the EC2 subnet.

Add:

| Destination | Target                        |
| ----------- | ----------------------------- |
| 10.0.0.0/16 | Virtual Private Gateway (VGW) |

Verify that the EC2 subnet uses this route table.

---

## Azure

The Local Network Gateway already contains the AWS VPC CIDR. Azure will route traffic through the VPN connection.

---

# Security Group Configuration

## AWS EC2 Security Group

Add inbound rules:

| Type                     | Port | Source      |
| ------------------------ | ---- | ----------- |
| SSH                      | 22   | 10.0.0.0/16 |
| HTTP                     | 80   | 10.0.0.0/16 |
| Custom TCP               | 8080 | 10.0.0.0/16 |
| All ICMP IPv4 (Optional) | All  | 10.0.0.0/16 |

> ICMP is only required for ping/troubleshooting.

---

## Azure NSG

Allow inbound traffic from AWS VPC CIDR:

| Source        | Protocol | Port |
| ------------- | -------- | ---- |
| 172.31.0.0/16 | Any      | Any  |

For production, restrict to required ports only.

---

# Docker Test Service

## Install Docker on Azure VM

```bash
sudo apt update
sudo apt install -y docker.io
sudo systemctl enable docker
sudo systemctl start docker
```

## Run Nginx Container

```bash
docker run -d --name nginx-test -p 8080:80 nginx
```

Verify:

```bash
docker ps
curl http://localhost:8080
```

---

# Connectivity Testing

## From AWS EC2

Test Docker service:

```bash
curl http://<Azure-VM-Private-IP>:8080
```

Example:

```bash
curl http://10.0.1.4:8080
```

Expected output:

```
Welcome to nginx!
```

Optional connectivity tests:

```bash
ping <Azure-VM-Private-IP>

nc -zv <Azure-VM-Private-IP> 8080

ssh azureuser@<Azure-VM-Private-IP>
```

---

# Troubleshooting Checklist

## Verify VPN Tunnel

AWS:

```
VPC → Site-to-Site VPN Connections
```

Tunnel State should be:

```
UP
```

---

## Verify Route Tables

### AWS

```
10.0.0.0/16 → Virtual Private Gateway
```

### Azure

Local Network Gateway should contain:

```
172.31.0.0/16
```

---

## Verify Security

* AWS Security Group allows Azure CIDR.
* Azure NSG allows AWS CIDR.
* Linux firewall (ufw/firewalld) is not blocking traffic.

---

## Verify Docker

```bash
docker ps
curl http://localhost:8080
```

---

# Resource Cleanup

## Azure

Delete the Resource Group containing:

* Virtual Network Gateway.
* Local Network Gateway.
* Connection.
* Public IP.
* GatewaySubnet.
* VM (if not required).

## AWS

Delete resources in the following order:

1. Delete Site-to-Site VPN Connection.
2. Detach Virtual Private Gateway from VPC.
3. Delete Virtual Private Gateway.
4. Delete Customer Gateway.
5. Remove Route Table entry:

   ```
   10.0.0.0/16 → VGW
   ```
6. Remove temporary Security Group rules.

---

# Useful AWS Navigation Paths

```
VPC → Virtual Private Gateways
VPC → Customer Gateways
VPC → Site-to-Site VPN Connections
VPC → Route Tables
EC2 → Security Groups
```

# Useful Azure Navigation Paths

```
Virtual Network
GatewaySubnet
Virtual Network Gateway
Local Network Gateway
Connections
Network Security Groups
Virtual Machines
```

---

# Validation Checklist

* [ ] Azure VPN Gateway deployed.
* [ ] AWS VGW attached to VPC.
* [ ] AWS Customer Gateway created.
* [ ] Site-to-Site VPN created.
* [ ] Azure Local Network Gateway created.
* [ ] Azure VPN Connection created.
* [ ] Shared Key configured identically on both sides.
* [ ] AWS Route Table updated.
* [ ] Security Groups and NSGs configured.
* [ ] Docker service running on Azure VM.
* [ ] `curl http://<Azure-VM-Private-IP>:8080` works from AWS EC2.
* [ ] VPN Tunnel status is `UP`.

---

# Notes

* Prefer **Static Routing** for lab environments.
* Keep **BGP Disabled** unless dynamic routing is required.
* Keep **Active-Active Disabled** for a simple single-tunnel setup.
* Use **Static Public IP** for the Azure VPN Gateway.
* Remove temporary firewall rules after testing.
