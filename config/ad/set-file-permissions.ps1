# FS01 Workstation
$FS01 = "FS01"

# Run command on file server
Invoke-Command -ComputerName $FS01 -Credential "SCHOOL\Administrator" -ScriptBlock {

# Config
$DomainRoot = "DC=school,DC=local"
$Path = "C:\Files"
$Domain = "SCHOOL"

# Configure Staff Data
Write-Host "Configuring StaffData ..." -ForegroundColor Yellow

# Reset persmissions
icacls "$Path\StaffData" /reset
icacls "$Path\StudentData" /reset
icacls "$Path\ExamPapers" /reset

# Remove existing permissions 
icacls "$Path\StaffData" /inheritance:r | Out-Null
icacls "$Path\StaffData" /remove:g "Users" "Authenticated Users" | Out-Null

# Grant Domain Admins full control
icacls "$Path\StaffData" /grant "SYSTEM:(OI)(CI)F" "${Domain}\Domain Admins:(OI)(CI)F" | Out-Null

# Grant GG_HR_Staff modify permissions
icacls "$Path\StaffData" /grant "${Domain}\GG_HR_Staff:(OI)(CI)M" | Out-Null

# Configure Student Data
Write-Host "Configuring Student Data ..." -ForegroundColor Yellow

# Remove existing permissions 
icacls "$Path\StudentData" /inheritance:r | Out-Null
icacls "$Path\StudentData" /remove:g "Users" "Authenticated Users" | Out-Null

# Grant Domain Admins full control
icacls "$Path\StudentData" /grant "SYSTEM:(OI)(CI)F" "${Domain}\Domain Admins:(OI)(CI)F" | Out-Null

# Grant GG_Teachers read & execute permissions
icacls "$Path\StudentData" /grant "${Domain}\GG_Teachers:(OI)(CI)RX" | Out-Null

# Configure Exam Papers
Write-Host "Configuring Exam Papers ..." -ForegroundColor Yellow

# Remove existing permissions 
icacls "$Path\ExamPapers" /inheritance:r | Out-Null
icacls "$Path\ExamPapers" /remove:g "Users" "Authenticated Users" | Out-Null

# Grant Domain Admins full control
icacls "$Path\ExamPapers" /grant "SYSTEM:(OI)(CI)F" "${Domain}\Domain Admins:(OI)(CI)F" | Out-Null

# Grant GG_Exam_Officers read & execute permissions
icacls "$Path\ExamPapers" /grant "${Domain}\GG_Exam_Officers:(OI)(CI)RX" | Out-Null

}



