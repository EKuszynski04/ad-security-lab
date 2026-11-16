# FS01 Workstation
$FS01 = "FS01"

Invoke-Command -ComputerName $FS01 -Credential "SCHOOL\Administrator" -ScriptBlock {
    # StaffData Share
    Grant-SmbShareAccess -Name "StaffData" -AccountName "SCHOOL\GG_HR_Staff" -AccessRight Full -Force | Out-Null
    Revoke-SmbShareAccess -Name "StaffData" -AccountName "Everyone" -Force -ErrorAction SilentlyContinue | Out-Null
    
    # StudentData Share
    Grant-SmbShareAccess -Name "StudentData" -AccountName "SCHOOL\GG_Teachers" -AccessRight Full -Force | Out-Null
    Revoke-SmbShareAccess -Name "StudentData" -AccountName "Everyone" -Force -ErrorAction SilentlyContinue | Out-Null

    # ExamPapers Share
    Grant-SmbShareAccess -Name "ExamPapers" -AccountName "SCHOOL\GG_Exam_Officers" -AccessRight Full -Force | Out-Null
    Revoke-SmbShareAccess -Name "ExamPapers" -AccountName "Everyone" -Force -ErrorAction SilentlyContinue | Out-Null

    Write-Host "Share permissions updated" -ForegroundColor Green
}