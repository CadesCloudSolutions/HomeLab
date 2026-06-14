# HomeLab

A hands-on home lab documenting enterprise infrastructure, identity, and networking
projects — built on a single workstation with VMware Workstation Pro and an Azure
subscription. Inspired by [michaelacook/home-lab](https://github.com/michaelacook/home-lab),
rebuilt and right-sized for my own hardware.

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

| # | Project | Status |
|---|---|---|
| 01 | [Active Directory Forest](projects/01-active-directory-forest/) | 🟡 In progress |
| 02 | Active Directory Forest Trust | ⚪ Planned |
| 03 | SMB AD Infrastructure (segmented) | ⚪ Planned |
| 04 | OpenVPN + RADIUS Authentication | ⚪ Planned |
| 05 | OpenVPN Split-Tunnel | ⚪ Planned |
| 06 | Hybrid Identity (Entra Connect over Azure S2S) | ⚪ Planned |

## Conventions

- **Network:** the primary lab LAN is `10.0.254.0/24`, isolated from the home network.
- **Naming:** domain `ad.cooklab.com`; servers `DC1`, `DC2`, `cooklab-fw1`.
- **Automation:** all build steps are captured as PowerShell scripts under each
  project's `scripts/` folder so the lab is reproducible.
