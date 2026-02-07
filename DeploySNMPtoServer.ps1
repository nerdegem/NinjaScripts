# Define variables
$communityString = "CommunityString"
$allowedHosts = @("S10.1.2.3", "10.1.2.4")

# Check if SNMP is installed
$snmpCapability = Get-WindowsCapability -Online | Where-Object { $_.Name -like "SNMP.Client*" }

if ($snmpCapability.State -ne "Installed") {
    Write-Host "Installing SNMP..."
    dism /online /enable-feature /featureName:SNMP /featureName:WMISnmpProvider
    Start-Sleep -Seconds 5
} else {
    Write-Host "SNMP is already installed."
}

# Ensure registry paths exist
$basePath = "HKLM:\SYSTEM\CurrentControlSet\Services\SNMP\Parameters"
$validCommunitiesPath = Join-Path $basePath "ValidCommunities"
$permittedManagersPath = Join-Path $basePath "PermittedManagers"

If (-Not (Test-Path $validCommunitiesPath)) {
    New-Item -Path $validCommunitiesPath -Force | Out-Null
}

If (-Not (Test-Path $permittedManagersPath)) {
    New-Item -Path $permittedManagersPath -Force | Out-Null
}

# Set SNMP community string with READ ONLY (4) access
New-ItemProperty -Path $validCommunitiesPath -Name $communityString -PropertyType DWORD -Value 4 -Force

# Clear and set permitted managers
Remove-Item -Path $permittedManagersPath -Recurse -Force -ErrorAction SilentlyContinue
New-Item -Path $permittedManagersPath -Force | Out-Null

$i = 1
foreach ($snmpHost in $allowedHosts) {
    New-ItemProperty -Path $permittedManagersPath -Name "X$i" -PropertyType String -Value $snmpHost -Force
    $i++
}

# Restart SNMP service if it exists
$snmpService = Get-Service -Name "SNMP" -ErrorAction SilentlyContinue
if ($snmpService) {
    Restart-Service -Name "SNMP"
    Write-Host "SNMP service restarted."
} else {
    Write-Host "SNMP service not found. A reboot may be required to complete setup."
}
