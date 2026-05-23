# Module 3 — Active Directory Setup

Install Active Directory Domain Services (AD DS) and promote your server to a Domain Controller.

---

## Step 1 — Install the AD DS Role

1. Open **Server Manager** (it opens automatically on login)
2. Click **Add roles and features**
3. Click **Next** → **Next** → **Next** (keep defaults)
4. On **Select server roles**, check **Active Directory Domain Services**
5. Click **Add Features** when prompted
6. Click **Next** → **Next** → **Next** → **Install**
7. Wait for installation to complete (~5 minutes)
8. **Do not restart yet**

---

## Step 2 — Promote to Domain Controller

1. In Server Manager, click the **flag icon** with the yellow warning ⚠️ (top right)
2. Click **Promote this server to a domain controller**
3. Select **Add a new forest**
4. Enter your **Root domain name**: `lab.local`
   > This is your internal domain. `lab.local` is standard for home labs.
5. Click **Next**
6. On **Domain Controller Options**:
   - Forest functional level: **Windows Server 2016**
   - Domain functional level: **Windows Server 2016**
   - Leave **DNS server** checked ✅
   - Enter a **DSRM password** (Directory Services Restore Mode): `P@ssw0rd123!`
7. Click **Next** through the DNS delegation warning (expected in a lab)
8. **NetBIOS name**: leave as `LAB` (auto-filled)
9. Keep default paths → **Next** → **Next**
10. Click **Install**
11. The server will **automatically restart**

---

## Step 3 — Log In to the Domain

After restart, log in as:
```
Username: LAB\Administrator
Password: P@ssw0rd123!
```

> Notice the domain prefix `LAB\` — you're now logging into the domain, not just the local machine.

---

## Step 4 — Verify AD is Working

1. Open **Server Manager → Tools → Active Directory Users and Computers (ADUC)**
2. You should see your domain `lab.local` in the left panel
3. Expand it — you'll see default containers like `Computers`, `Users`, `Domain Controllers`

Also verify DNS:
1. **Server Manager → Tools → DNS**
2. Expand your server → **Forward Lookup Zones** → you should see `lab.local`

---

## Step 5 — Join the Windows 10 Client to the Domain

Switch to your `CLIENT01` VM:

1. First set its DNS to point to the DC:
   - Network adapter → IPv4 Properties
   - Preferred DNS: `192.168.56.10` (your DC's IP)

2. Join the domain:
   - Right-click **Start** → **System**
   - Click **Rename this PC (advanced)**
   - Click **Change**
   - Select **Domain** → enter `lab.local`
   - Click **OK**
   - Enter credentials: `LAB\Administrator` / `P@ssw0rd123!`
   - Click **OK** → **Restart**

3. After restart, log in with a domain account:
   ```
   Username: LAB\Administrator
   Password: P@ssw0rd123!
   ```

---

## ✅ Checkpoint

- [ ] AD DS role installed
- [ ] Server promoted to Domain Controller for `lab.local`
- [ ] Can open Active Directory Users and Computers
- [ ] Windows 10 client joined to the domain

**Next:** [Module 4 — Users & Groups](./04-users-and-groups.md)
