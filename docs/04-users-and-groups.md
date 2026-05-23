# Module 4 — Users, Groups & Organizational Units

Create a realistic company structure in Active Directory with Organizational Units (OUs), security groups, and user accounts.

---

## The Company Structure We'll Build

```
lab.local
└── ACME Corp (OU)
    ├── IT (OU)
    │   ├── Helpdesk (OU)
    │   └── SysAdmins (OU)
    ├── HR (OU)
    ├── Finance (OU)
    └── Sales (OU)
```

Security Groups:
- `GRP_IT_Admins` — Full admin rights
- `GRP_IT_Helpdesk` — Limited support rights
- `GRP_HR` — HR department
- `GRP_Finance` — Finance department
- `GRP_Sales` — Sales department

---

## Step 1 — Create Organizational Units (OUs)

OUs are like folders that organize your users and computers.

1. Open **Active Directory Users and Computers (ADUC)**
2. Right-click `lab.local` → **New → Organizational Unit**
3. Name it `ACME Corp` → uncheck **Protect container** → **OK**
4. Right-click `ACME Corp` → **New → Organizational Unit** → name it `IT`
5. Repeat to create: `HR`, `Finance`, `Sales` under `ACME Corp`
6. Right-click `IT` → create sub-OUs: `Helpdesk` and `SysAdmins`

---

## Step 2 — Create Security Groups

1. Right-click the `IT` OU → **New → Group**
2. Settings:
   - **Group name**: `GRP_IT_Admins`
   - **Group scope**: Global
   - **Group type**: Security
3. Click **OK**
4. Repeat for all groups:

| Group Name | OU Location |
|---|---|
| `GRP_IT_Admins` | IT |
| `GRP_IT_Helpdesk` | IT\Helpdesk |
| `GRP_HR` | HR |
| `GRP_Finance` | Finance |
| `GRP_Sales` | Sales |

---

## Step 3 — Create User Accounts Manually

Let's create a few users by hand first so you understand the process.

1. Right-click the `IT\SysAdmins` OU → **New → User**
2. Fill in:
   - First name: `John`
   - Last name: `Smith`
   - User logon name: `jsmith`
3. Click **Next**
4. Password: `P@ssw0rd123!`
5. Uncheck **User must change password at next logon** (for lab purposes)
6. Check **Password never expires** (for lab purposes)
7. Click **Next** → **Finish**

Create a few more users across different OUs. Or use the bulk script below.

---

## Step 4 — Bulk Create Users with PowerShell

This script reads from a CSV and creates all users automatically. This is how it's done in the real world.

**Run this on your DC01:**

1. Open **PowerShell ISE** as Administrator
2. Open the script: `scripts/users/New-BulkUsers.ps1`
3. Make sure `sample-users.csv` is in the same folder
4. Press **F5** to run

You'll see users created across all your OUs automatically.

---

## Step 5 — Add Users to Groups

1. In ADUC, find user `jsmith`
2. Double-click → go to **Member Of** tab
3. Click **Add** → type `GRP_IT_Admins` → **Check Names** → **OK**
4. Click **Apply** → **OK**

Or use PowerShell (much faster for bulk operations):

```powershell
# Add a single user to a group
Add-ADGroupMember -Identity "GRP_IT_Admins" -Members "jsmith"

# Add multiple users to a group
$users = @("jsmith", "mjones", "bwilliams")
foreach ($user in $users) {
    Add-ADGroupMember -Identity "GRP_IT_Admins" -Members $user
}
```

---

## Step 6 — Delegate Control (Least Privilege)

Give the Helpdesk group permission to reset passwords — but nothing else.

1. Right-click the `ACME Corp` OU → **Delegate Control**
2. Click **Next** → **Add** → type `GRP_IT_Helpdesk` → **OK** → **Next**
3. Select **Reset user passwords and force password change at next logon**
4. Click **Next** → **Finish**

> This is a key IAM concept: **least privilege**. Helpdesk can reset passwords but can't create or delete accounts.

---

## ✅ Checkpoint

- [ ] OU structure created matching the company hierarchy
- [ ] Security groups created in each OU
- [ ] User accounts created manually and/or via bulk script
- [ ] Users added to appropriate groups
- [ ] Helpdesk delegation configured

**Next:** [Module 5 — Group Policy](./05-group-policy.md)
