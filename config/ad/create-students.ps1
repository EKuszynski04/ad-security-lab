# Config
$DomainRoot = "DC=school,DC=local"
$StudentOU = "OU=Students,OU=School Users,$DomainRoot"
$SecurePassword = ConvertTo-SecureString "StudentPassword2026!" -AsPlainText -Force

# Array of student names
$StudentFirstName = @(
    "Oliver", "Harry", "Jack", "George", "Noah", "Charlie", "Jacob", "Alfie", "Freddie", "Oscar",
    "Olivia", "Amelia", "Isla", "Ava", "Emily", "Sophia", "Grace", "Mia", "Poppy", "Ella",
    "Leo", "Archie", "Joshua", "William", "James", "Henry", "Thomas", "Daniel", "Samuel", "Max",
    "Rosie", "Lily", "Evie", "Florence", "Alice", "Isabelle", "Freya", "Charlotte", "Daisy", "Phoebe",
    "Maciek", "Dawid", "Abigail", "Ethan", "Lucas", "Logan", "Aiden", "Elijah", "Sebastian", "Jayden"
)

$StudentLastName = @(
     "Smith", "Jones", "Taylor", "Brown", "Williams", "Wilson", "Johnson", "Davies", "Robinson", "Wright",
    "Thompson", "Evans", "Walker", "White", "Roberts", "Green", "Hall", "Wood", "Jackson", "Clarke",
    "Patel", "Khan", "Lewis", "James", "Phillips", "Mason", "Mitchell", "Rose", "Davis", "Edwards",
    "Harris", "Cooper", "King", "Lee", "Scott", "Turner", "Carter", "Morgan", "Bell", "Murphy",
    "Bailey", "Reed", "Cook", "Ward", "Watson"
)

$Years = 11..13 

# Generate student accounts

$StudentAccounts = @()
$Count = 0
$MaxCount = 1200

Write-Host "Starting generation of $MaxCount students..." -ForegroundColor Cyan

while ($Count -lt $MaxCount) {

    # Student info
    $FirstName = $StudentFirstName | Get-Random
    $LastName = $StudentLastName | Get-Random
    $Year = $Years | Get-Random
    $RandomSuffix = Get-Random -Minimum 10 -Maximum 99
    $Username = ($FirstName.Substring(0,1) + $LastName + $RandomSuffix).ToLower()
    $DisplayName = "$FirstName $LastName"
    
    # Check if the user already exists
    if ($StudentAccounts -notcontains $Username)
    {
        $TargetOU = "OU=Year $Year,$StudentOU"
        $UPN = "$Username@school.local"

        # try catch block incase user creation fails
        try
        {
            New-ADUser `
                -Name "$FirstName $LastName" `
                -GivenName $FirstName `
                -Surname $LastName `
                -DisplayName "$FirstName $LastName" `
                -SamAccountName $Username `
                -UserPrincipalName $UPN `
                -Path $TargetOU `
                -AccountPassword $SecurePassword `
                -Enabled $true `
                -ChangePasswordAtLogon $false -ErrorAction Stop

            $StudentAccounts += $Username
            $Count++

            # Print progress every 100 users
            if ($Count % 100 -eq 0)
            {
                Write-Host "Created $Count student accounts..." -ForegroundColor Green
                Write-Host "$FirstName $LastName $UPN $Username" -ForegroundColor Yellow
            }
        }
        catch
        {
            Write-Host "Error creating user: $Username" -ForegroundColor Red
            Write-Host "Reason: $_" -ForegroundColor DarkRed
        }
    }
}

Write-Host "Finished creating $Count student accounts!" -ForegroundColor Cyan