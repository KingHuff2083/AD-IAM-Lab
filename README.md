# 🏢 Active Directory IAM Home Lab

A beginner-friendly, fully documented **Active Directory home lab** demonstrating enterprise Identity & Access Management concepts including user lifecycle management, Group Policy, and Okta integration via AD Connect.

> ✅ Built to showcase IAM skills to IT recruiters and hiring managers.

---

## 📚 What You'll Learn

- Setting up Windows Server and promoting it to a Domain Controller
- Creating and managing users, groups, and Organizational Units (OUs)
- Enforcing security policies with Group Policy Objects (GPOs)
- Connecting Active Directory to Okta for hybrid SSO
- Automating user provisioning with PowerShell

---

## 🏗 Lab Architecture

```
┌─────────────────────────────────────────────────┐
│                  Home Lab Network               │
│                                                 │
│  ┌─────────────────┐     ┌──────────────────┐  │
│  │  Windows Server │     │   Windows 10     │  │
│  │  2022 (DC)      │────►│   Client VM      │  │
│  │                 │     │  (Domain joined) │  │
│  │  - AD DS        │     └──────────────────┘  │
│  │  - DNS          │                           │
│  │  - AD Connect   │                           │
│  └────────┬────────┘                           │
└───────────┼─────────────────────────────────────┘
            │ LDAPS / AD Connect Sync
            ▼
┌─────────────────────┐
│    Okta Tenant      │
│  (Cloud IdP)        │
│  - Universal Dir    │
│  - SSO Policies     │
│  - MFA              │
└─────────────────────┘
```

---

## 🖥 Requirements

| Component | Recommendation | Cost |
|---|---|---|
| Virtualization | VirtualBox or VMware Workstation Player | Free |
| Windows Server 2022 | Microsoft Evaluation Center (180-day trial) | Free |
| Windows 10 Client | Microsoft Evaluation Center | Free |
| Okta Tenant | Okta Developer Account | Free |
| RAM | 8GB minimum (16GB recommended) | — |
| Storage | 60GB free disk space | — |

---

## 📁 Project Structure

```
ad-iam-lab/
├── docs/
│   ├── 01-virtualbox-setup.md       # VM setup guide
│   ├── 02-windows-server-setup.md   # Install & configure Windows Server
│   ├── 03-active-directory-setup.md # Promote to Domain Controller
│   ├── 04-users-and-groups.md       # Create OUs, users, and groups
│   ├── 05-group-policy.md           # Configure GPOs
│   └── 06-okta-integration.md       # Connect AD to Okta
├── scripts/
│   ├── users/
│   │   ├── New-BulkUsers.ps1        # Bulk create users from CSV
│   │   ├── Disable-InactiveUsers.ps1# Offboarding automation
│   │   └── sample-users.csv         # Sample user data
│   ├── gpo/
│   │   └── Export-GPOReport.ps1     # Export GPO settings to HTML
│   └── okta/
│       └── Sync-OktaGroups.ps1      # Sync AD groups to Okta
├── screenshots/                     # Add your lab screenshots here
└── README.md
```

---

## 🚀 Lab Modules

### Module 1 — Environment Setup
Install VirtualBox, create VMs, configure networking.
👉 [View Guide](./docs/01-virtualbox-setup.md)

### Module 2 — Windows Server Setup
Install Windows Server 2022 and configure basic settings.
👉 [View Guide](./docs/02-windows-server-setup.md)

### Module 3 — Active Directory Setup
Install AD DS, promote to Domain Controller, configure DNS.
👉 [View Guide](./docs/03-active-directory-setup.md)

### Module 4 — Users & Groups
Create Organizational Units, user accounts, and security groups.
👉 [View Guide](./docs/04-users-and-groups.md)

### Module 5 — Group Policy
Enforce password policies, lock screens, software restrictions.
👉 [View Guide](./docs/05-group-policy.md)

### Module 6 — Okta Integration
Connect AD to Okta using AD Connect for hybrid SSO.
👉 [View Guide](./docs/06-okta-integration.md)

---

## 🔑 Key IAM Concepts Demonstrated

| Concept | Implementation |
|---|---|
| **Identity Lifecycle** | User creation, modification, and deactivation via PowerShell |
| **Least Privilege** | Role-based group membership and OU delegation |
| **Password Policy** | GPO-enforced complexity, length, and expiration |
| **MFA** | Okta-enforced MFA for cloud app access |
| **SSO** | Okta as IdP with AD as the source of truth |
| **Audit Logging** | AD event logs + Okta System Log |
| **Offboarding** | Automated account disable script |

---

## 📸 Screenshots

> Add screenshots of your completed lab here to show recruiters your hands-on work.
> Suggested screenshots:
> - Active Directory Users and Computers (ADUC) showing your OU structure
> - Group Policy Management Console showing your GPOs
> - Okta Admin Console showing synced users from AD
> - A user successfully logging into a domain-joined PC

---

## 📄 License

MIT
