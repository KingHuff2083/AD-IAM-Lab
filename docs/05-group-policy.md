# Module 5 — Group Policy Objects (GPOs)

Group Policy lets you enforce security settings across all computers and users in your domain from one central place. This is one of the most important AD skills for an IAM role.

---

## GPOs We'll Create

| GPO Name | Applies To | Purpose |
|---|---|---|
| `Password Policy` | Domain | Enforce strong passwords |
| `Account Lockout Policy` | Domain | Lock accounts after failed logins |
| `Screen Lock Policy` | All users | Auto-lock after 10 minutes |
| `Disable USB Storage` | Finance OU | Prevent data exfiltration |
| `Desktop Wallpaper` | ACME Corp | Branding / awareness |

---

## Step 1 — Open Group Policy Management

1. On DC01: **Server Manager → Tools → Group Policy Management**
2. Expand: `Forest: lab.local → Domains → lab.local`
3. You'll see the **Default Domain Policy** already exists

---

## Step 2 — Password Policy GPO

**Edit the Default Domain Policy** (password policies must be at domain level):

1. Right-click **Default Domain Policy** → **Edit**
2. Navigate to:
   `Computer Configuration → Policies → Windows Settings → Security Settings → Account Policies → Password Policy`
3. Configure:

| Setting | Value |
|---|---|
| Enforce password history | 10 passwords |
| Maximum password age | 90 days |
| Minimum password age | 1 day |
| Minimum password length | 12 characters |
| Password must meet complexity requirements | Enabled |

4. Close the editor

---

## Step 3 — Account Lockout Policy

Still in **Default Domain Policy → Account Policies → Account Lockout Policy**:

| Setting | Value |
|---|---|
| Account lockout threshold | 5 invalid attempts |
| Account lockout duration | 30 minutes |
| Reset account lockout counter after | 30 minutes |

> This prevents brute-force attacks. After 5 wrong passwords, the account locks for 30 minutes.

---

## Step 4 — Screen Lock Policy

1. Right-click `ACME Corp` OU → **Create a GPO in this domain and link it here**
2. Name it `Screen Lock Policy` → **OK**
3. Right-click it → **Edit**
4. Navigate to:
   `User Configuration → Policies → Administrative Templates → Control Panel → Personalization`
5. Double-click **Screen saver timeout** → **Enabled** → set to `600` seconds (10 min)
6. Double-click **Password protect the screen saver** → **Enabled**
7. Double-click **Enable screen saver** → **Enabled**
8. Close the editor

---

## Step 5 — Disable USB Storage (Finance Only)

1. Right-click the `Finance` OU → **Create a GPO** → name it `Disable USB Storage`
2. Edit it → navigate to:
   `Computer Configuration → Policies → Administrative Templates → System → Removable Storage Access`
3. Double-click **All Removable Storage classes: Deny all access** → **Enabled**
4. Close

> This GPO only applies to computers in the Finance OU — not the whole company. This is **scoped** policy enforcement.

---

## Step 6 — Force a GPO Update

By default, GPOs apply every 90 minutes. Force it immediately:

```powershell
# Run on the client VM to apply all GPOs immediately
gpupdate /force

# Verify which GPOs are applied
gpresult /r
```

---

## Step 7 — Verify Policies Are Working

**Test password policy:**
1. Try to set a user's password to something simple like `password` — it should be rejected

**Test account lockout:**
1. Try logging in with a wrong password 5 times
2. The account should lock — verify in ADUC (locked accounts show a padlock icon)
3. Unlock it: right-click the user → **Unlock account**

**Test screen lock:**
1. Log into the CLIENT01 VM as a domain user
2. Run `gpupdate /force` in Command Prompt
3. Leave it idle for 10 minutes — it should lock automatically

---

## ✅ Checkpoint

- [ ] Password policy configured (12 chars, complexity, 90-day expiry)
- [ ] Account lockout configured (5 attempts, 30-minute lockout)
- [ ] Screen lock GPO linked to ACME Corp OU
- [ ] USB storage disabled for Finance OU
- [ ] Tested `gpupdate /force` and `gpresult /r`

**Next:** [Module 6 — Okta Integration](./06-okta-integration.md)
