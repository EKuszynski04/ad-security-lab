#  File to setup LAPS permissions in AD

# Update Schema
Update-AdmPwdADSchema

# Allow Domain Admins to read passwords
Set-AdmPwdReadPasswordPermission -Identity "DC=school,DC=local" -AllowedPrincipals "Domain Admins"

# Allow GG_IT_Admins to read passwords
Set-AdmPwdReadPasswordPermission -Identity "DC=school,DC=local" -AllowedPrincipals "GG_IT_Admins"

# Give Workstation OU permissions to write passwords
Set-AdmPwdComputerSelfPermission -Identity "OU=Workstations,OU=School Computers,DC=school,DC=local"