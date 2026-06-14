# Active Directory Forest — Part 1: Initial Setup

## Introduction

This project stands up a single Active Directory forest (`ad.adeslab.com`) behind a
pfSense firewall, with two domain controllers, an organizational-unit structure,
department security groups, a privileged-account model, and CSV-driven user
provisioning. It is built on VMware Workstation Pro and right-sized to run on a 16 GB
host, with Windows Server roles deployed as Server Core to conserve memory.

## Table of Contents

- [Basic Network Setup](#basic-network-setup)
- [Server Configuration and Forest Creation](#server-configuration-and-forest-creation)
- [Creating Organizational Units, Groups and Users](#creating-organizational-units-groups-and-users)
- [Next Steps](#next-steps)

## Basic Network Setup

The lab runs on an isolated `10.0.254.0/24` network, separated from the home LAN. In
VMware Workstation this isolation is provided by a custom virtual network (VMnet2),
the equivalent of an Open vSwitch bridge on Proxmox. The pfSense firewall provides NAT
and outbound access, with its WAN connected to VMware's NAT network (VMnet8).

```mermaid
graph TD
    NET([Internet]) --- HOST["Host PC — VMware NAT (VMnet8)"]
    HOST --- FW["adeslab-fw1 · pfSense CE<br/>WAN: DHCP · LAN: 10.0.254.1"]
    FW --- LAN{{"Lab LAN — VMnet2 (isolated)<br/>10.0.254.0/24"}}
    LAN --- DC1["DC1 · Server 2022 Core<br/>10.0.254.2<br/>AD DS · DNS · DHCP"]
    LAN --- DC2["DC2 · Server 2022 Core<br/>10.0.254.3<br/>AD DS · DNS"]
    LAN --- CL1["CL1 · Windows 10/11<br/>DHCP · domain-joined test client"]
```

| VM | OS | Role | vCPU | RAM | Disk (on D:) | IP |
|---|---|---|---|---|---|---|
| `adeslab-fw1` | pfSense CE 2.7 | Firewall / NAT | 1 | 1 GB | 20 GB | WAN DHCP / LAN 10.0.254.1 |
| `DC1` | Server 2022 Core | Primary DC, DNS, DHCP | 2 | 2.5 GB | 40 GB | 10.0.254.2 |
| `DC2` | Server 2022 Core | Secondary DC, DNS | 2 | 2 GB | 40 GB | 10.0.254.3 |
| `CL1` | Windows 10/11 | Test client (optional) | 2 | 2 GB | 40 GB | DHCP |

pfSense performs NAT and allows outbound traffic. DNS is set to forward mode so queries
are passed to the primary domain controller, and DHCP is later configured to advertise
both domain controllers as DNS servers.

## Server Configuration and Forest Creation

1. Build `DC1` (Server 2022 Core), set a static IP of `10.0.254.2`, and rename the host.
2. Install the AD DS role and promote `DC1` to a new forest, `ad.adeslab.com`.
3. Build `DC2` (Server 2022 Core), set `10.0.254.3`, join the domain, and promote it as
   a secondary domain controller and DNS server for redundancy.
4. Configure DHCP on `DC1` to serve the `10.0.254.0/24` range and advertise both DCs as
   DNS servers.

## Creating Organizational Units, Groups and Users

The forest uses the following organizational-unit structure:

```
ad.adeslab.com/
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

Department security groups (global scope) are created for each department, along with IT
support groups. IT staff follow a privileged-account model: a standard daily-use account
plus a separate privileged account (`first.last.p`) used only for administrative tasks —
never interactive logon, no Microsoft 365 licensing. Employee accounts are bulk-created
from `data/users.csv` and placed in the correct OUs with department group membership.

## Next Steps

With the forest established, the next project builds a second forest (`corp.cyrlab.com`)
and configures an Active Directory forest trust between the two.
