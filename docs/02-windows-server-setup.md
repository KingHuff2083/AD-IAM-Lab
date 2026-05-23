# Module 2 — Windows Server 2022 Setup

Install and configure Windows Server 2022 on your DC01 virtual machine.

---

## Step 1 — Install Windows Server 2022

1. Start the `DC01` VM in VirtualBox
2. Press any key when prompted to boot from the ISO
3. Select:
   - Language: **English**
   - Time: your timezone
   - Keyboard: your layout
4. Click **Install Now**
5. Select **Windows Server 2022 Standard Evaluation (Desktop Experience)**
   > ⚠️ Make sure you pick **Desktop Experience** — otherwise you get no GUI
6. Accept the license → click **Next**
7. Choose **Custom: Install Windows only**
8. Select the unallocated disk → click **Next**
9. Wait for installation (~15 minutes)

---

## Step 2 — Initial Configuration

After the VM restarts:

1. Set the **Administrator password** when prompted
   - Use something you'll remember: e.g. `P@ssw0rd123!`
   - (This is a lab — don't use this in production!)
2. Press **Ctrl+Alt+Delete** to log in (in VirtualBox: Input menu → Insert Ctrl+Alt+Del)
3. Log in as `Administrator`

---

## Step 3 — Set a Static IP Address

Domain Controllers must have a static IP.

1. Right-click the network icon in the taskbar → **Open Network & Internet Settings**
2. Click **Change adapter options**
3. Right-click your network adapter → **Properties**
4. Double-click **Internet Protocol Version 4 (TCP/IPv4)**
5. Select **Use the following IP address** and enter:

```
IP Address:      192.168.56.10
Subnet Mask:     255.255.255.0
Default Gateway: 192.168.56.1
Preferred DNS:   127.0.0.1   ← points to itself (it will BE the DNS server)
```

6. Click **OK** → **Close**

---

## Step 4 — Rename the Server

1. Right-click **Start** → **System**
2. Click **Rename this PC**
3. Enter `DC01`
4. Click **Next** → **Restart Now**

---

## Step 5 — Install Windows Updates

1. Open **Start → Settings → Windows Update**
2. Click **Check for updates**
3. Install all updates and restart as needed
4. Repeat until no more updates are pending

> This can take 30-60 minutes. Go grab a coffee ☕

---

## Step 6 — Disable IE Enhanced Security (Quality of Life)

This makes browsing inside the VM easier for downloading tools later.

1. Open **Server Manager**
2. Click **Local Server** in the left panel
3. Find **IE Enhanced Security Configuration** → click **On**
4. Set both **Administrators** and **Users** to **Off**
5. Click **OK**

---

## ✅ Checkpoint

- [ ] Windows Server 2022 installed with Desktop Experience
- [ ] Static IP set to `192.168.56.10`
- [ ] Server renamed to `DC01`
- [ ] Windows updates installed

**Next:** [Module 3 — Active Directory Setup](./03-active-directory-setup.md)
