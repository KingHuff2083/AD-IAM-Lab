# scripts/okta/Sync-OktaGroups.ps1
# Reports on AD group membership and cross-references with Okta via the Okta API.
# Useful for auditing sync status between on-prem AD and Okta.
#
# Prerequisites:
#   Install-Module -Name ActiveDirectory
#   $env:OKTA_DOMAIN and $env:OKTA_API_TOKEN must be set
#
# Usage:
#   $env:OKTA_DOMAIN = "https://dev-XXXXXXX.okta.com"
#   $env:OKTA_API_TOKEN = "your_api_token"
#   .\Sync-OktaGroups.ps1

param(
    [string]$OktaDomain = $env:OKTA_DOMAIN,
    [string]$OktaApiToken = $env:OKTA_API_TOKEN,
    [string]$SearchBase = "OU=ACME Corp,DC=lab,DC=local",
    [string]$GroupPrefix = "GRP_"
)

Import-Module ActiveDirectory -ErrorAction Stop

if (-not $OktaDomain -or -not $OktaApiToken) {
    Write-Error "Set OKTA_DOMAIN and OKTA_API_TOKEN environment variables before running."
    exit 1
}

$headers = @{
    "Authorization" = "SSWS $OktaApiToken"
    "Content-Type"  = "application/json"
    "Accept"        = "application/json"
}

Write-Host "`n=== AD → Okta Group Sync Report ===" -ForegroundColor Cyan

# Get all AD groups matching our prefix
$adGroups = Get-ADGroup -Filter { Name -like "GRP_*" } -SearchBase $SearchBase -Properties Members

foreach ($adGroup in $adGroups) {

    Write-Host "`n📁 AD Group: $($adGroup.Name)" -ForegroundColor Yellow

    # Get AD group members
    $adMembers = Get-ADGroupMember -Identity $adGroup.Name |
        ForEach-Object { Get-ADUser -Identity $_.SamAccountName -Properties EmailAddress } |
        Select-Object SamAccountName, EmailAddress

    Write-Host "   AD Members ($($adMembers.Count)):"
    $adMembers | ForEach-Object { Write-Host "     • $($_.SamAccountName) ($($_.EmailAddress))" }

    # Look up the matching Okta group
    try {
        $encodedName = [System.Web.HttpUtility]::UrlEncode($adGroup.Name)
        $response = Invoke-RestMethod `
            -Uri "$OktaDomain/api/v1/groups?q=$encodedName&limit=1" `
            -Headers $headers `
            -Method GET

        if ($response.Count -eq 0) {
            Write-Host "   ⚠️  No matching Okta group found — not yet synced?" -ForegroundColor Yellow
            continue
        }

        $oktaGroup = $response[0]
        Write-Host "   Okta Group: $($oktaGroup.profile.name) (ID: $($oktaGroup.id))"

        # Get Okta group members
        $oktaMembers = Invoke-RestMethod `
            -Uri "$OktaDomain/api/v1/groups/$($oktaGroup.id)/users?limit=200" `
            -Headers $headers `
            -Method GET

        $oktaEmails = $oktaMembers | ForEach-Object { $_.profile.email }

        Write-Host "   Okta Members ($($oktaMembers.Count)):"
        $oktaMembers | ForEach-Object {
            Write-Host "     • $($_.profile.login)"
        }

        # Cross-reference: find AD users not in Okta
        $adEmails = $adMembers | ForEach-Object { $_.EmailAddress }
        $missingInOkta = $adEmails | Where-Object { $_ -notin $oktaEmails }
        $extraInOkta = $oktaEmails | Where-Object { $_ -notin $adEmails }

        if ($missingInOkta) {
            Write-Host "   ❌ In AD but NOT in Okta:" -ForegroundColor Red
            $missingInOkta | ForEach-Object { Write-Host "     • $_" -ForegroundColor Red }
        }
        if ($extraInOkta) {
            Write-Host "   ⚠️  In Okta but NOT in AD (orphaned):" -ForegroundColor Yellow
            $extraInOkta | ForEach-Object { Write-Host "     • $_" -ForegroundColor Yellow }
        }
        if (-not $missingInOkta -and -not $extraInOkta) {
            Write-Host "   ✅ In sync!" -ForegroundColor Green
        }

    } catch {
        Write-Host "   ❌ Okta API error: $($_.Exception.Message)" -ForegroundColor Red
    }
}

Write-Host "`n=== Report Complete ===`n" -ForegroundColor Cyan
