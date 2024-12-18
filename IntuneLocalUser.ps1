<#	
	.NOTES
	===========================================================================
	 Created on:   	18.12.2024
	 Created by:   	c.eder
	 Organization: 	School IT Admin / Upperaustria
	 Filename:     	IntuneLocalUser.ps1
	===========================================================================
	.DESCRIPTION
		 Script to create an local user with Admin rights on a specific computer
#>


# Local Admin User
$serial = get-computerinfo -property "BiosSeralNumber"
$Username = "lauser"
$Password = "la$($serial.BiosSeralNumber)"
# (Get-FileHash -InputStream ([System.IO.MemoryStream]::New([System.Text.Encoding]::UTF8.GetBytes($serial.biosseralnumber))) -Algorithm MD5).Hash

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
& WMIC USERACCOUNT WHERE "Name='$Username'" SET PasswordExpires=FALSE

# Shutdown
#shutdown.exe /s /f