#=============================================================================================================================
#
# Script Name:     IntW Detect RemoveLokalAdmin.ps1
# Description:     Detect Local Admin User 
# Notes:           Change the value of the variable $LocalAdminUser to your local Admin
#                  Don't change the $results variable
#
#=============================================================================================================================

# Define Variables
$results = @()
$LocalAdminUser = "BGAdmin"

try
{
    $results = @(Get-Localuser -Name $LocalAdminUser)

    if (($results -ne $null)){
        #Below necessary for Intune as of 10/2019 will only remediate Exit Code 1
        Write-Host "Match"
        Return $results.count
        exit 1
    }
    else{
        #No matching user, do not remediate
        Write-Host "No_Match"        
        exit 0
    }   
}
catch{
    $errMsg = $_.Exception.Message
    Write-Error $errMsg
    exit 1
}