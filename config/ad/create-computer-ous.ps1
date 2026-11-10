# Domain root
$DomainRoot = "DC=school,DC=local"

New-ADOrganizationalUnit -Name "School Computers" -Path $DomainRoot -ProtectedFromAccidentalDeletion $true

$ComputersPath = "OU=School Computers,$DomainRoot"
$ComputerOUs = @("Workstations", "Servers")

foreach ($SubOU in $ComputerOUs) {
    New-ADOrganizationalUnit -Name $SubOU -Path $ComputersPath -ProtectedFromAccidentalDeletion $true
    Write-Host "Created Computer sub-OU: $SubOU" -ForegroundColor Cyan
}