# Module 6 — Okta Integration (AD Connect)

Connect your on-premises Active Directory to Okta so that AD users can log into cloud apps using their domain credentials. This is called **hybrid identity** and is used in almost every enterprise.

---

## How It Works

```
User logs into       Okta checks        Okta grants
cloud app     ──►   AD credentials  ──► access token
(e.g. Gmail)        via AD Agent
```

Okta installs a lightweight **AD Agent** on your Domain Controller. This agent syncs users from AD to Okta and validates passwords against AD when users sign in.

---

## Step 1 — Set Up Your Okta Developer Tenant

If you haven't already:
1. Go to **https://developer.okta.com/signup/**
2. Create a free account
3. Your Okta domain will be: `https://dev-XXXXXXX.okta.com`

---

## Step 2 — Add Active Directory in Okta

1. Log into your **Okta Admin Console**
2. Go to **Directory → Directory Integrations**
3. Click **Add Directory → Add Active Directory**
4. Click **Set Up Active Directory**
5. You'll see instructions to download the **Okta AD Agent** — keep this page open

---

## Step 3 — Install the Okta AD Agent on DC01

On your **DC01 VM**:

1. Download the Okta AD Agent installer from the Okta console (Step 2)
2. Run the installer
3. When prompted, enter your **Okta domain**: `dev-XXXXXXX.okta.com`
4. Sign in with your Okta admin credentials
5. Select your **Active Directory domain**: `lab.local`
6. Select which **Domain Controller** to use: `DC01.lab.local`
7. Click **Finish**

The agent installs as a Windows Service and begins syncing.

---

## Step 4 — Configure Import Settings

Back in the Okta Admin Console:

1. Go to **Directory → Directory Integrations → lab.local**
2. Click the **Provisioning** tab
3. Under **To Okta**, configure:
   - **Schedule imports**: Every hour
   - **Okta username format**: `Email Address` (uses the AD email attribute)
4. Click **Save**

---

## Step 5 — Import AD Users into Okta

1. Click the **Import** tab
2. Click **Import Now** → **Full Import**
3. Wait for the import to complete
4. You'll see your AD users listed — they'll show as **Pending**
5. Select all users → click **Confirm Assignments**
6. Users are now in Okta, linked to their AD accounts

---

## Step 6 — Configure Delegated Authentication

This makes Okta validate passwords against AD (instead of storing them in Okta):

1. Go to **Directory → Directory Integrations → lab.local**
2. Click **Settings**
3. Under **Active Directory Settings**, enable **Delegated Authentication**
4. Click **Save**

> Now when a user logs into Okta, Okta asks AD "is this password correct?" — AD is the single source of truth.

---

## Step 7 — Test the Integration

1. Go to **Okta Admin Console → Directory → People**
2. Find one of your AD users (e.g. `jsmith`)
3. Click their name → you should see their AD attributes (department, manager, etc.)

**Test login:**
1. Open a private/incognito browser window
2. Go to your Okta tenant: `https://dev-XXXXXXX.okta.com`
3. Log in with an AD user's credentials (`jsmith` / `P@ssw0rd123!`)
4. The user should land on the Okta dashboard ✅

---

## Step 8 — Sync AD Groups to Okta

1. Go to **Directory → Directory Integrations → lab.local**
2. Click the **Provisioning** tab → **To Okta**
3. Under **Group sync**, enable **Sync AD Groups**
4. Add your groups: `GRP_IT_Admins`, `GRP_HR`, `GRP_Finance`, `GRP_Sales`
5. Click **Save** → **Import Now**

Your AD security groups now appear in Okta and can be used to assign app access.

---

## Step 9 — Assign an App Based on AD Group

1. In Okta, go to **Applications → Browse App Catalog**
2. Add a sample app (e.g. **Salesforce** or any app)
3. Go to the app's **Assignments** tab
4. Click **Assign → Assign to Groups**
5. Assign it to `GRP_Sales`

Now everyone in the `GRP_Sales` AD group automatically gets access to that app in Okta. When someone is removed from the AD group, they lose access automatically.

---

## ✅ Final Checkpoint

- [ ] Okta AD Agent installed on DC01
- [ ] AD users imported into Okta
- [ ] Delegated authentication enabled
- [ ] AD user can log into Okta with their domain password
- [ ] AD groups synced to Okta
- [ ] App assigned to an AD group

---

## 🎉 Lab Complete!

You've built a full hybrid IAM environment demonstrating:
- On-premises AD with OUs, users, and groups
- Security enforcement via Group Policy
- Cloud identity integration with Okta
- Delegated authentication
- Group-based app access control

**Take screenshots of each step and add them to the `screenshots/` folder in this repo!**
