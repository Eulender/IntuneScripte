<#	
	.NOTES
	===========================================================================
	 Created on:   	20.06.2023
	 Created by:   	c.eder
	 Organization: 	School IT Admin / Upperaustria
	 Filename:     	IntuneLocalAdmin.ps1
	===========================================================================
	.DESCRIPTION
		 Script to create an local admin user on a specific computer
#>


# Local Admin User
$Username = "Username"
$Password = "Password"
$serial = (Get-WmiObject -query 'select * from Win32_BIOS').SerialNumber
$Password = "Pass$($serial)" 


# Get name of the local admin group
$AdminGroupSid = 'S-1-5-32-544'
$AdminGroup = New-Object System.Security.Principal.SecurityIdentifier($AdminGroupSid)
$AdminGroupName = $AdminGroup.Translate([System.Security.Principal.NTAccount]).Value -replace '.+\\'

# Check if username exists
$adsi = [ADSI]"WinNT://$env:COMPUTERNAME"
$existing = $adsi.Children | Where-Object {$_.SchemaClassName -eq 'user' -and $_.Name -eq $Username }

if ($null -eq $existing) {
	# Create user and add too local admin group
	& NET USER $Username $Password /add /y /expires:never
	& NET LOCALGROUP $AdminGroupName $Username /add	
} else {
	#Setting Password 
	$existing.SetPassword($Password)
}

# Set never Expires
Get-Localuser -Name "$Username" | set-localuser -PasswordNeverExpires $true

# Shutdown
#shutdown.exe /s /f