# Config
$DomainRoot = "DC=school,DC=local"
$AdminOU = "OU=Admin Staff,OU=School Users,$DomainRoot"
$ITOU = "OU=IT Staff,OU=School Users,$DomainRoot"
$ContractorOU = "OU=Contractors,OU=School Users,$DomainRoot"
$SecurePassword = ConvertTo-SecureString "StaffPassword2026!" -AsPlainText -Force

# Names
$FirstNames = @(
    "Oliver", "Harry", "Jack", "George", "Noah", "Charlie", "Jacob", "Alfie", "Freddie", "Oscar",
    "Olivia", "Amelia", "Isla", "Ava", "Emily", "Sophia", "Grace", "Mia", "Poppy", "Ella",
    "Leo", "Archie", "Joshua", "William", "James", "Henry", "Thomas", "Daniel", "Samuel", "Max",
    "Rosie", "Lily", "Evie", "Florence", "Alice", "Isabelle", "Freya", "Charlotte", "Daisy", "Phoebe",
    "Maciek", "Dawid", "Abigail", "Ethan", "Lucas", "Logan", "Aiden", "Elijah", "Sebastian", "Jayden"
)
$LastNames = @(
     "Smith", "Jones", "Taylor", "Brown", "Williams", "Wilson", "Johnson", "Davies", "Robinson", "Wright",
    "Thompson", "Evans", "Walker", "White", "Roberts", "Green", "Hall", "Wood", "Jackson", "Clarke",
    "Patel", "Khan", "Lewis", "James", "Phillips", "Mason", "Mitchell", "Rose", "Davis", "Edwards",
    "Harris", "Cooper", "King", "Lee", "Scott", "Turner", "Carter", "Morgan", "Bell", "Murphy",
    "Bailey", "Reed", "Cook", "Ward", "Watson"
)

# Generate Admin Staff, IT Staff and Contractor accounts
$AdminMaxCount = 15
$ITMaxCount = 15
$ContractorMaxCount = 10


# Function to generate user accounts
Function Create-UserAccounts {
    param (
        [string]$TargetOU,
        [int]$MaxAccountNumber,
        [string]$AccountType,
        [bool] $CreateAdminAccounts = $false,
        [datetime] $ExpiryDate = [datetime]::MinValue
    )

    $CreatedAccounts = 0

    while ($CreatedAccounts -lt $MaxAccountNumber)
    {
        # Names
        $FirstName = $FirstNames | Get-Random
        $LastName = $LastNames | Get-Random
        $RandomSuffix = Get-Random -Minimum 10 -Maximum 99

        # Standard Account Info
        $Username = ($FirstName.Substring(0,1) + $LastName + $RandomSuffix).ToLower()
        $DisplayName = "$FirstName $LastName"
        $UPN = "$Username@school.local"

        if (-not (Get-ADUser -Filter "SamAccountName -eq '$Username'" -ErrorAction SilentlyContinue)) {
            # try catch block incase user creation fails
                try
                {
                    # User params
                    $UserParams = @{
                        Name = "$FirstName $LastName"
                        GivenName = $FirstName
                        Surname = $LastName
                        DisplayName = "$FirstName $LastName"
                        SamAccountName = $Username
                        UserPrincipalName = $UPN
                        Path = $TargetOU
                        AccountPassword = $SecurePassword
                        Enabled = $true
                        ChangePasswordAtLogon = $false
                        ErrorAction = 'Stop'
                    }


                    # if contractor set expiry date
                    if ($ExpiryDate -ne [datetime]::MinValue) {
                        $UserParams['AccountExpirationDate'] = $ExpiryDate
                    }

                    # Add user
                    New-ADUser @UserParams

                    if ($CreateAdminAccounts) {

                        $AdminUsername = "adm-$Username"
                        $AdminUPN = "$AdminUsername@school.local"

                        New-ADUser `
                            -Name "Admin $FirstName $LastName" `
                            -GivenName $FirstName `
                            -Surname $LastName `
                            -DisplayName "Admin $FirstName $LastName" `
                            -SamAccountName $AdminUsername `
                            -UserPrincipalName $AdminUPN `
                            -Path $TargetOU `
                            -AccountPassword $SecurePassword `
                            -Enabled $true `
                            -ChangePasswordAtLogon $false

    
                        Write-Host "Created $AdminUsername admin account" -ForegroundColor Yellow
                    }

                    $CreatedAccounts++
                    Write-Host "Created $CreatedAccounts $AccountType accounts" -ForegroundColor Yellow

                }
                catch
                {
                    Write-Host "Reason: $_" -ForegroundColor DarkRed
                }
        }
    }
    
}

# Create Admin Staff accounts
Create-UserAccounts -TargetOU $AdminOU -MaxAccountNumber $AdminMaxCount -AccountType "Admin Staff" 

# Create IT Staff accounts
Create-UserAccounts -TargetOU $ITOU -MaxAccountNumber $ITMaxCount -AccountType "IT Staff" -CreateAdminAccounts $true

# Create Contractor accounts
$ContractorExpiryDate = (Get-Date).AddMonths(3)
Create-UserAccounts -TargetOU $ContractorOU -MaxAccountNumber $ContractorMaxCount -AccountType "Contractor" -ExpiryDate $ContractorExpiryDate


Write-Host "Staff user creation complete!" -ForegroundColor Cyan

