# Config
$DomainRoot = "DC=school,DC=local"
$TeacherOU = "OU=Teaching Staff,OU=School Users,$DomainRoot"
$SecurePassword = ConvertTo-SecureString "TeacherPassword2026!" -AsPlainText -Force

# Array of Teacher names
$TeacherFirstName = @(
    "Bert", "Ernie", "Bird", "Elmo", "Cookie", "Grover", "Abby", "Count", "Snuffy",
    "Oliver", "Harry", "Jack", "George", "Noah", "Charlie", "Jacob", "Alfie", "Freddie", "Oscar",
    "Olivia", "Amelia", "Isla", "Ava", "Emily", "Sophia", "Grace", "Mia", "Poppy", "Ella",
    "Leo", "Archie", "Joshua", "William", "James", "Henry", "Thomas", "Daniel", "Samuel", "Max",
    "Rosie", "Lily", "Evie", "Florence", "Alice", "Isabelle", "Freya", "Charlotte", "Daisy", "Phoebe",
    "Maciek", "Dawid", "Abigail", "Ethan", "Lucas", "Logan", "Aiden", "Elijah", "Sebastian", "Jayden"
)

$TeacherLastName = @(
     "Smith", "Jones", "Taylor", "Brown", "Williams", "Wilson", "Johnson", "Davies", "Robinson", "Wright",
    "Thompson", "Evans", "Walker", "White", "Roberts", "Green", "Hall", "Wood", "Jackson", "Clarke",
    "Patel", "Khan", "Lewis", "James", "Phillips", "Mason", "Mitchell", "Rose", "Davis", "Edwards",
    "Harris", "Cooper", "King", "Lee", "Scott", "Turner", "Carter", "Morgan", "Bell", "Murphy",
    "Bailey", "Reed", "Cook", "Ward", "Watson"
)

# Generate Teacher accounts

$TeacherAccounts = @()
$Count = 0
$MaxCount = 110

Write-Host "Starting generation of $MaxCount teachers..." -ForegroundColor Cyan

while ($Count -lt $MaxCount) {

    # Teacher info
    $FirstName = $TeacherFirstName | Get-Random
    $LastName = $TeacherLastName | Get-Random
    $RandomSuffix = Get-Random -Minimum 10 -Maximum 99
    $Username = ($FirstName.Substring(0,1) + $LastName + $RandomSuffix).ToLower()
    $DisplayName = "$FirstName $LastName"
    
    # Check if the user already exists
    if ($TeacherAccounts -notcontains $Username)
    {
        $TargetOU = $TeacherOU
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

            $TeacherAccounts += $Username
            $Count++

            # Print progress every 11 users
            if ($Count % 11 -eq 0)
            {
                Write-Host "Created $Count teacher accounts..." -ForegroundColor Green
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

Write-Host "Finished creating $Count teacher accounts!" -ForegroundColor Cyan