# HomeLab

A hands-on home lab documenting enterprise infrastructure, identity, and networking
projects — built on a single workstation with VMware Workstation Pro and an Azure
subscription.

## Lab host

| Component | Spec |
|---|---|
| CPU | AMD Ryzen 5 3600 (6 cores / 12 threads) |
| RAM | 16 GB |
| Storage | VMs live on the `D:` drive (1.8 TB) |
| Hypervisor | VMware Workstation Pro (type-2) |
| Cloud | Azure subscription with a Terraform-provisioned Site-to-Site (IPsec) VPN |

Because the host has 16 GB of RAM, projects are built and run in **phases** — only the
VMs needed for the current project are powered on at once. Windows Server roles use
**Server Core** wherever possible to keep memory use low.

## Projects

### Infrastructure, Identity & Access

| # | Project | Status |
|---|---|---|
| 01 | [SMB Active Directory Infrastructure — Part 1: Initial Setup](projects/smb-active-directory-infrastructure-pt-1/) | 🟡 In progress |
| 02 | SMB Active Directory Infrastructure — Part 2: Hybrid Identity | ⚪ Planned |
| 03 | Active Directory Forest Trust | ⚪ Planned |
| 04 | SMB Active Directory Infrastructure — Segmented | ⚪ Planned |

### Networking

| # | Project | Status |
|---|---|---|
| 05 | OpenVPN + RADIUS Authentication | ⚪ Planned |
| 06 | OpenVPN Split-Tunnel | ⚪ Planned |
| 07 | Azure Site-to-Site VPN (on-prem ↔ Azure) | ⚪ Planned |
