# scripts/users/Disable-InactiveUsers.ps1
# Finds and disables AD users who haven't logged in for X days.
# This is a common offboarding / account hygiene automation task.
#
# Usage:
#   .\Disable-InactiveUsers.ps1                    # Dry run (no changes)
#   .\Disable-InactiveUsers.ps1 -Commit            # Actually disable accounts
#   .\Disable-InactiveUsers.ps1 -InactiveDays 60   # Custom threshold

param(
    [int]$InactiveDays = 90,
    [switch]$Commit = $false,
    [string]$SearchBase = "OU=ACME Corp,DC=lab,DC=local",
    [string]$LogPath = ".\inactive-users-$(Get-Date -Format 'yyyy-MM-dd').log"
)

Import-Module ActiveDirectory -ErrorAction Stop

$cutoffDate = (Get-Date).AddDays(-$InactiveDays)

Write-Host "`n=== Inactive User Report ===" -ForegroundColor Cyan
Write-Host "Threshold:  $InactiveDays days (inactive since $($cutoffDate.ToShortDateString()))"
Write-Host "Search OU:  $SearchBase"
Write-Host "Mode:       $(if ($Commit) { 'LIVE — accounts will be disabled' } else { 'DRY RUN — no changes' })`n"

# Find enabled users whose last logon is older than the threshold
# Note: LastLogonDate replicates across DCs; use it for multi-DC environments
$inactiveUsers = Get-ADUser -Filter {
    Enabled -eq $true -and LastLogonDate -lt $cutoffDate
} -SearchBase $SearchBase -Properties LastLogonDate, EmailAddress, Department, Manager |
    Where-Object { $_.LastLogonDate -ne $null } |
    Sort-Object LastLogonDate

if ($inactiveUsers.Count -eq 0) {
    Write-Host "✅ No inactive users found." -ForegroundColor Green
    exit 0
}

Write-Host "Found $($inactiveUsers.Count) inactive user(s):`n"

$log = @()

foreach ($user in $inactiveUsers) {
    $daysSinceLogin = ((Get-Date) - $user.LastLogonDate).Days
    $logEntry = [PSCustomObject]@{
        Username      = $user.SamAccountName
        DisplayName   = $user.DisplayName
        Department    = $user.Department
        LastLogon     = $user.LastLogonDate.ToShortDateString()
        DaysInactive  = $daysSinceLogin
        Action        = if ($Commit) { "Disabled" } else { "Would disable" }
    }
    $log += $logEntry

    Write-Host "  👤 $($user.SamAccountName) | Last login: $($user.LastLogonDate.ToShortDateString()) ($daysSinceLogin days ago)" -ForegroundColor Yellow

    if ($Commit) {
        try {
            Disable-ADAccount -Identity $user.SamAccountName

            # Move disabled user to a Disabled Users OU (create it if needed)
            $disabledOU = "OU=Disabled Users,$SearchBase"
            try {
                Get-ADOrganizationalUnit -Identity $disabledOU -ErrorAction Stop | Out-Null
            } catch {
                New-ADOrganizationalUnit -Name "Disabled Users" -Path $SearchBase
            }
            Move-ADObject -Identity $user.DistinguishedName -TargetPath $disabledOU

            Write-Host "    ✅ Disabled and moved to Disabled Users OU" -ForegroundColor Green
        } catch {
            Write-Host "    ❌ Error: $($_.Exception.Message)" -ForegroundColor Red
            $logEntry.Action = "Error: $($_.Exception.Message)"
        }
    }
}

# Export log to CSV
$log | Export-Csv -Path $LogPath -NoTypeInformation
Write-Host "`n📄 Log saved to: $LogPath"

if (-not $Commit) {
    Write-Host "`n⚠️  This was a DRY RUN. Run with -Commit to actually disable accounts." -ForegroundColor Yellow
}
