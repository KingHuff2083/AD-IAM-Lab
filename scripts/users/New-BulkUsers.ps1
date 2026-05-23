# scripts/users/New-BulkUsers.ps1
# Bulk creates Active Directory users from a CSV file.
# Run this on the Domain Controller as Administrator.
#
# Usage:
#   .\New-BulkUsers.ps1
#   .\New-BulkUsers.ps1 -CsvPath "C:\path\to\users.csv" -DefaultPassword "P@ssw0rd123!"

param(
    [string]$CsvPath = ".\sample-users.csv",
    [string]$DefaultPassword = "P@ssw0rd123!",
    [string]$Domain = "lab.local",
    [string]$BaseOU = "OU=ACME Corp,DC=lab,DC=local"
)

# ── Import required module ────────────────────────────────────────
Import-Module ActiveDirectory -ErrorAction Stop

# ── Verify CSV exists ─────────────────────────────────────────────
if (-not (Test-Path $CsvPath)) {
    Write-Error "CSV file not found at: $CsvPath"
    exit 1
}

$users = Import-Csv $CsvPath
$successCount = 0
$errorCount = 0

Write-Host "`n=== Bulk User Creation ===" -ForegroundColor Cyan
Write-Host "Processing $($users.Count) users from $CsvPath`n"

foreach ($user in $users) {

    # Build the full Distinguished Name for the target OU
    $ouPath = "OU=$($user.Department),$BaseOU"

    # Build UPN (User Principal Name): jsmith@lab.local
    $upn = "$($user.Username)@$Domain"

    # Check if user already exists
    if (Get-ADUser -Filter { SamAccountName -eq $user.Username } -ErrorAction SilentlyContinue) {
        Write-Warning "User '$($user.Username)' already exists — skipping."
        continue
    }

    # Verify the target OU exists
    try {
        Get-ADOrganizationalUnit -Identity $ouPath -ErrorAction Stop | Out-Null
    } catch {
        Write-Warning "OU not found: $ouPath — creating it."
        New-ADOrganizationalUnit -Name $user.Department -Path $BaseOU
    }

    try {
        # Create the user
        New-ADUser `
            -SamAccountName       $user.Username `
            -UserPrincipalName    $upn `
            -GivenName            $user.FirstName `
            -Surname              $user.LastName `
            -DisplayName          "$($user.FirstName) $($user.LastName)" `
            -EmailAddress         $user.Email `
            -Title                $user.JobTitle `
            -Department           $user.Department `
            -Company              "ACME Corp" `
            -Path                 $ouPath `
            -AccountPassword      (ConvertTo-SecureString $DefaultPassword -AsPlainText -Force) `
            -ChangePasswordAtLogon $false `
            -Enabled              $true

        # Add user to their department security group
        $groupName = "GRP_$($user.Department)"
        if (Get-ADGroup -Filter { Name -eq $groupName } -ErrorAction SilentlyContinue) {
            Add-ADGroupMember -Identity $groupName -Members $user.Username
            Write-Host "  ✓ Added to group: $groupName" -ForegroundColor DarkGray
        }

        Write-Host "✅ Created: $($user.Username) ($($user.FirstName) $($user.LastName)) → $($user.Department)" -ForegroundColor Green
        $successCount++

    } catch {
        Write-Host "❌ Failed to create $($user.Username): $($_.Exception.Message)" -ForegroundColor Red
        $errorCount++
    }
}

Write-Host "`n=== Summary ===" -ForegroundColor Cyan
Write-Host "✅ Created:  $successCount users" -ForegroundColor Green
Write-Host "❌ Failed:   $errorCount users" -ForegroundColor Red
Write-Host "⏭ Skipped:  $($users.Count - $successCount - $errorCount) users (already existed)`n"
