# Domain root
$DomainRoot = "DC=school,DC=local"

# Group OU
$GroupOU = "OU=Groups,$DomainRoot"

# Group names
$GroupNames = @(
    "GG_Teachers", "GG_HR_Staff", "GG_Exam_Officers", "GG_IT_Admins"
)
foreach ($GroupName in $GroupNames) {
    New-ADGroup -Name $GroupName -Path $GroupOU -GroupScope Global -GroupCategory Security
    Write-Host "Created Security Group: $GroupName" -ForegroundColor Green
}

# Add Teachers to GG_Teachers security group
$Teachers = Get-ADUser -Filter * -SearchBase "OU=Teaching Staff,OU=School Users,$DomainRoot"
foreach ($Teacher in $Teachers) {
    Add-ADGroupMember -Identity "GG_Teachers" -Members $Teacher.SamAccountName
    Write-Host "Added $($Teacher.SamAccountName) to GG_Teachers group" -ForegroundColor Yellow
}

# Add Admin Staff to GG_HR_Staff security group
$AdminStaff = Get-ADUser -Filter * -SearchBase "OU=Admin Staff,OU=School Users,$DomainRoot"
foreach ($Admin in $AdminStaff) {
    Add-ADGroupMember -Identity "GG_HR_Staff" -Members $Admin.SamAccountName
    Write-Host "Added $($Admin.SamAccountName) to GG_HR_Staff group" -ForegroundColor Yellow
}

# Add Exam Officers to GG_Exam_Officers security group
$ExamOfficers = $Teachers | Get-Random -Count 5
foreach ($ExamOfficer in $ExamOfficers) {
    Add-ADGroupMember -Identity "GG_Exam_Officers" -Members $ExamOfficer.SamAccountName
    Write-Host "Added $($ExamOfficer.SamAccountName) to GG_Exam_Officers group" -ForegroundColor Yellow
}

# Add IT Staff to GG_IT_Admins security group
$ITStaff = Get-ADUser -Filter "SamAccountName -like 'adm-*'" -SearchBase "OU=IT Staff,OU=School Users,$DomainRoot"
foreach ($IT in $ITStaff) {
    Add-ADGroupMember -Identity "GG_IT_Admins" -Members $IT.SamAccountName
    Write-Host "Added $($IT.SamAccountName) to GG_IT_Admins group" -ForegroundColor Yellow
}

