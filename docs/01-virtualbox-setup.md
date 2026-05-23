# Module 1 — VirtualBox & VM Setup

This guide walks you through installing VirtualBox and creating the two virtual machines needed for the lab: a Windows Server 2022 Domain Controller and a Windows 10 client.

---

## Step 1 — Download VirtualBox

1. Go to **https://www.virtualbox.org/wiki/Downloads**
2. Click **Windows hosts** to download the installer
3. Run the installer and click **Next** through all defaults
4. Click **Yes** on the network warning (this is expected)
5. Click **Install** then **Finish**

---

## Step 2 — Download Windows Server 2022 (Free 180-day Trial)

1. Go to **https://www.microsoft.com/en-us/evalcenter/evaluate-windows-server-2022**
2. Click **Download the ISO**
3. Fill in the registration form (use any details)
4. Select **ISO** format → **64-bit edition**
5. Download the ISO (~5GB) — this may take a while

---

## Step 3 — Download Windows 10 Client (Free Trial)

1. Go to **https://www.microsoft.com/en-us/evalcenter/evaluate-windows-10-enterprise**
2. Download the **ISO** (64-bit)

---

## Step 4 — Create the Domain Controller VM

1. Open **VirtualBox** → click **New**
2. Settings:
   - **Name**: `DC01`
   - **Type**: Microsoft Windows
   - **Version**: Windows 2022 (64-bit)
3. Click **Next**
4. **Memory**: Set to `2048 MB` (2GB) minimum, `4096 MB` recommended
5. **Hard disk**: Create a virtual hard disk → `VDI` → Dynamically allocated → `50 GB`
6. Click **Create**

**Attach the ISO:**
1. Click your new `DC01` VM → click **Settings**
2. Go to **Storage** → click the empty CD icon
3. Click the CD icon on the right → **Choose a disk file**
4. Select your Windows Server 2022 ISO
5. Click **OK**

**Network settings:**
1. Still in Settings → go to **Network**
2. Adapter 1: **NAT** (for internet access)
3. Click **OK**

---

## Step 5 — Create the Windows 10 Client VM

1. Click **New** again
2. Settings:
   - **Name**: `CLIENT01`
   - **Type**: Microsoft Windows
   - **Version**: Windows 10 (64-bit)
3. Memory: `2048 MB`
4. Hard disk: `40 GB` dynamically allocated
5. Attach the Windows 10 ISO the same way as above

**Network — important:**
1. Settings → Network → Adapter 1
2. Change from **NAT** to **Internal Network**
3. Name: `lab-network`
4. Click **OK**

> ⚠️ The client VM uses Internal Network so it can talk to the DC but not the internet directly. The DC uses NAT so it can reach the internet for updates.

---

## Step 6 — Configure a Host-Only Network (so VMs can talk to each other)

1. In VirtualBox top menu: **File → Host Network Manager**
2. Click **Create** — a `vboxnet0` network is created
3. Set the IP to `192.168.56.1` with mask `255.255.255.0`
4. Disable DHCP (we'll assign static IPs manually)

Now add a second adapter to the DC:
1. DC01 → Settings → Network → **Adapter 2**
2. Enable it → **Host-only Adapter** → `vboxnet0`

---

## ✅ Checkpoint

You should now have:
- [ ] VirtualBox installed
- [ ] `DC01` VM created with Windows Server 2022 ISO attached
- [ ] `CLIENT01` VM created with Windows 10 ISO attached
- [ ] Network configured

**Next:** [Module 2 — Windows Server Setup](./02-windows-server-setup.md)
