# Domain root
$DomainRoot = "DC=school,DC=local"

# Top Level OUs
$TopOUs = @("School Users", "Computers", "Groups", "Service Accounts", "Tier 0")

foreach ($OU in $TopOUs) {
    New-ADOrganizationalUnit -Name $OU -Path $DomainRoot -ProtectedFromAccidentalDeletion $true
    Write-Host "Created OU: $OU" -ForegroundColor White
}

# Sub OUs 
$UsersPath = "OU=School Users,$DomainRoot"
$SubOUs = @("Students", "Teaching Staff", "Admin Staff", "IT Staff", "Contractors")

foreach ($SubOU in $SubOUs) {
    New-ADOrganizationalUnit -Name $SubOU -Path $UsersPath -ProtectedFromAccidentalDeletion $true
    Write-Host "Created Sub OU: $SubOU" -ForegroundColor Cyan
}

# Sub OUs for Students
$StudentPath = "OU=Students,$UsersPath"
$Years = 11..13 

foreach ($Year in $Years) {
    New-ADOrganizationalUnit -Name "Year $Year" -Path $StudentPath -ProtectedFromAccidentalDeletion $true
    Write-Host "Created Student Sub OU: Year $Year" -ForegroundColor Yellow
}

# Sub OUs for Computers
$ComputersPath = "OU=Computers,$DomainRoot"
$ComputerOUs = @("Workstations", "Servers")

foreach ($SubOU in $ComputerOUs) {
    New-ADOrganizationalUnit -Name $SubOU -Path $ComputersPath -ProtectedFromAccidentalDeletion $true
    Write-Host "Created Computer sub-OU: $SubOU" -ForegroundColor Cyan
}

# Sub OUs for Tier 0
$Tier0Path = "OU=Tier 0,$DomainRoot"
$Tier0OUs = @("Domain Controllers", "Admin Accounts")

foreach ($SubOU in $Tier0OUs) {
    New-ADOrganizationalUnit -Name $SubOU -Path $Tier0Path -ProtectedFromAccidentalDeletion $true
    Write-Host "Created Tier 0 Sub OU: $SubOU" -ForegroundColor Red
}

Write-Host "OU Structure creation complete!" -ForegroundColor Green