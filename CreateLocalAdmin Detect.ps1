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
try {
	# Local Admin User
	$Username = "MyUser"
	$adsi = [ADSI]"WinNT://$env:COMPUTERNAME"
	$existing = $adsi.Children | Where-Object {$_.SchemaClassName -eq 'user' -and $_.Name -eq $Username }

	if ($null -eq $existing) {
		# Create user and add too local admin group
		Write-Output "User does not exist"
		exit 1
	} else {
		Write-Output "User exist"
		exit 1
	}
}
catch {
	Write-Output "some error"
	exit 0
}
Stop-Transcript

