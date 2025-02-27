# Check BitLocker encryption status 

# Output the BitLocker encryption status
# Write-Output $bitLockerStatus


Write-Output "BitLocker status $((Get-BitLockerVolume | Select-Object VolumeStatus).VolumeStatus)"


Exit 0