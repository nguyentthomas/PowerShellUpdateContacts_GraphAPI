Get-InstalledModule Microsoft.Graph
$maximumfunctioncount = '32768'
Import-Module -Name Microsoft.Graph.Users

Connect-MgGraph -Scopes "User.Read.All","Group.ReadWrite.All"
Get-MgUser -UserId "{USER}" -Property DisplayName, BusinessPhones, JobTitle, Mail, City, CompanyName, Department, EmployeeId, StreetAddress, Country | Select-Object DisplayName, BusinessPhones, JobTitle, Mail, City, CompanyName, Department, EmployeeId, StreetAddress, Country
# Read the CSV file
$users = Import-Csv -Path "{INPUT FILE}"

foreach ($user in $users){
    $userPrincipalName = $user.UserPrincipalName
    $streetAddress = $user.StreetAddress

    $existingUser = Get-MgUser -UserId $userPrincipalName -Property UserPrincipalName, BusinessPhones, Department, OfficeLocation, StreetAddress -ErrorAction SilentlyContinue | Select-Object UserPrincipalName, BusinessPhones, Department
    
    if ($existingUser) {
        # Check if the existing job title matches the new value
        if ($existingUser.StreetAddress -eq $streetAddress) {
            # Job title already set with the same value
            Write-Host "User '$userPrincipalName' already set to same value." -ForegroundColor Yellow
        }else{
            # Update the job title
            Update-MgUser -UserId $userPrincipalName -streetAddress $streetAddress
            Write-Host "User '$userPrincipalName' updated streetAddress to '$streetAddress' successfully." -ForegroundColor Green
        }} 
        else {
        # User not found
        Write-Host "User '$userPrincipalName' not found." -ForegroundColor Red
    }
}
#>

Disconnect-MgGraph