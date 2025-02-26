<#	
	.NOTES
	===========================================================================
	 Created on:   	28.01.2025
	 Changed on:   	26.02.2025
	 Created by:   	c.eder
	 Organization: 	School IT Admin / Upperaustria
	 Filename:     	CreateLocalAdmin Remediate.ps1
	 Settings:		User logged-on                       [ ] Yes [X] No
	 				Enforce script signature check       [ ] Yes [X] No
					Run script in 64-bit PowerShell Host [X] Yes [ ] No
	 ===========================================================================
	.DESCRIPTION
		 Script to create an local admin user on a specific computer
		 and disable Bitlocker if enabled
		 
#>

Start-Transcript -OutputDirectory c:\IntuneLogs
# Local Admin User
$Username = "MyUser"

$serial = (Get-WmiObject -query 'select * from Win32_BIOS').SerialNumber
$Password = "Pass$($serial)" 
write-output "Create user $($Username)"


# Get name of the local admin group
$AdminGroupSid = 'S-1-5-32-544'
$AdminGroup = New-Object System.Security.Principal.SecurityIdentifier($AdminGroupSid)
$AdminGroupName = $AdminGroup.Translate([System.Security.Principal.NTAccount]).Value -replace '.+\\'
write-output "Add user to usergroup $($AdminGroupName)"

# Check if username exists
$adsi = [ADSI]"WinNT://$env:COMPUTERNAME"
$existing = $adsi.Children | Where-Object {$_.SchemaClassName -eq 'user' -and $_.Name -eq $Username }



if ($null -eq $existing) {
	# Create user and add too local admin group
	& NET USER $Username $Password /add /y /expires:never
	& NET LOCALGROUP $AdminGroupName $Username /add	
	write-output "Add user and set password/group"
} else {
	# Setting Password 
	$existing.SetPassword($Password)
	write-output "User exists, set password"
}

# Set never Expires
& WMIC USERACCOUNT WHERE "Name='$Username'" SET PasswordExpires=FALSE

# Bitlocker Key

 
write-output "Bitlocker Status: $((Get-BitLockerVolume).VolumeStatus)"
& "C:\Windows\System32\manage-bde.exe" -off c:
write-output "Bitlocker Status: $((Get-BitLockerVolume).VolumeStatus)"

exit 0

Stop-Transcript