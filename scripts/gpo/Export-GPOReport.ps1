# scripts/gpo/Export-GPOReport.ps1
# Exports all GPO settings to an HTML report for documentation and auditing.
# Run on the Domain Controller as Administrator.
#
# Usage:
#   .\Export-GPOReport.ps1
#   .\Export-GPOReport.ps1 -OutputPath "C:\Reports"

param(
    [string]$OutputPath = ".\GPO-Reports",
    [string]$Domain = "lab.local"
)

Import-Module GroupPolicy -ErrorAction Stop

# Create output directory
if (-not (Test-Path $OutputPath)) {
    New-Item -ItemType Directory -Path $OutputPath | Out-Null
}

$timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm"
$allGPOs = Get-GPO -All -Domain $Domain

Write-Host "`n=== GPO Report Export ===" -ForegroundColor Cyan
Write-Host "Domain: $Domain"
Write-Host "Found:  $($allGPOs.Count) GPOs`n"

foreach ($gpo in $allGPOs) {
    $safeName = $gpo.DisplayName -replace '[\\/:*?"<>|]', '_'
    $reportPath = Join-Path $OutputPath "$safeName`_$timestamp.html"

    try {
        Get-GPOReport -Guid $gpo.Id -ReportType HTML -Path $reportPath -Domain $Domain
        Write-Host "✅ Exported: $($gpo.DisplayName)" -ForegroundColor Green
    } catch {
        Write-Host "❌ Failed:   $($gpo.DisplayName) — $($_.Exception.Message)" -ForegroundColor Red
    }
}

# Also export a combined XML report for all GPOs
$xmlPath = Join-Path $OutputPath "All-GPOs_$timestamp.xml"
Get-GPOReport -All -ReportType XML -Path $xmlPath -Domain $Domain
Write-Host "`n📄 Combined XML report: $xmlPath"
Write-Host "📁 HTML reports saved to: $OutputPath`n"
