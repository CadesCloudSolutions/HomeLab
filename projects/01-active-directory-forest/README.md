# Project 01 — Active Directory Forest

Stand up a single Active Directory forest (`ad.cooklab.com`) behind a pfSense firewall,
with two domain controllers, an organizational-unit structure, department security
groups, a privileged-account model, and CSV-driven user provisioning.

This mirrors Michael Cook's `smb-active-directory-infrastructure-pt-1`, right-sized to
run on a 16 GB host under VMware Workstation Pro.

## Architecture

```mermaid
graph TD
    NET([Internet]) --- HOST["Host PC — VMware NAT (VMnet8)"]
    HOST --- FW["cooklab-fw1 · pfSense CE<br/>WAN: DHCP · LAN: 10.0.254.1"]
    FW --- LAN{{"Lab LAN — VMnet2 (isolated)<br/>10.0.254.0/24"}}
    LAN --- DC1["DC1 · Server 2022 Core<br/>10.0.254.2<br/>AD DS · DNS · DHCP"]
    LAN --- DC2["DC2 · Server 2022 Core<br/>10.0.254.3<br/>AD DS · DNS"]
    LAN --- CL1["CL1 · Windows 10/11<br/>DHCP · domain-joined test client"]
```

## Virtual machines

| VM | OS | Role | vCPU | RAM | Disk (on D:) | IP |
|---|---|---|---|---|---|---|
| `cooklab-fw1` | pfSense CE 2.7 | Firewall / NAT | 1 | 1 GB | 20 GB | WAN DHCP / LAN 10.0.254.1 |
| `DC1` | Server 2022 Core | Primary DC, DNS, DHCP | 2 | 2.5 GB | 40 GB | 10.0.254.2 |
| `DC2` | Server 2022 Core | Secondary DC, DNS | 2 | 2 GB | 40 GB | 10.0.254.3 |
| `CL1` | Windows 10/11 | Test client (optional) | 2 | 2 GB | 40 GB | DHCP |

**Concurrent RAM:** firewall + both DCs ≈ 5.5 GB; add the client ≈ 7.5 GB.

## Network

- **LAN subnet:** `10.0.254.0/24` (chosen to avoid home-router defaults and leave room
  for a future remote-access VPN pool).
- **VMware mapping:** pfSense WAN on **VMnet8 (NAT)** for internet; all lab machines on a
  custom **VMnet2 (host-only / isolated)** carrying `10.0.254.0/24`.
- **DNS/DHCP:** DHCP advertises both DC IPs as DNS servers.

## OU structure

```
ad.cooklab.com/
├── IT/
│   ├── Users/
│   │   └── Privileged Accounts/
│   └── Computers/
└── Employees/
    ├── Sales/        (Users/, Computers/)
    ├── Marketing/    (Users/, Computers/)
    ├── Finance/      (Users/, Computers/)
    ├── HR/           (Users/, Computers/)
    └── Engineering/  (Users/, Computers/)
```

## Privileged-account model

IT staff hold two accounts: a standard daily-use account and a privileged account
(`first.last.p`) used only for administrative tasks — never interactive logon, no
Microsoft 365 licensing.

## Build order

1. Create the **VMnet2** isolated network in VMware Virtual Network Editor.
2. Build and configure **pfSense** (`cooklab-fw1`) — WAN + LAN, NAT.
3. Build **DC1**, set static IP, promote to a new forest — `01-Deploy-Forest-DC1.ps1`.
4. Build **DC2**, join domain, promote as secondary DC — `02-Promote-DC2.ps1`.
5. Create the **OU structure** — `03-Create-OUs.ps1`.
6. Create **department security groups** — `04-Create-Groups.ps1`.
7. Create **IT users and privileged accounts** — `05-Create-IT-Users.ps1`.
8. Bulk-provision employees from CSV — `06-Provision-Users.ps1` + `data/users.csv`.
9. Build **CL1**, join to the domain, verify policy and DNS.

## Scripts

Scripts are added to [`scripts/`](scripts/) as each build step is completed, so every
commit reflects a working, reproducible stage.
