# Name der Software, die deinstalliert werden soll
$softwareName = "c:\Program Files\McAfee\wps\1.25.208.1\mc-update.exe"
$fileExists = Test-Path -path $softwareName
# Überprüfen, ob die Software installiert ist
if ($fileExists) {
  # Deinstallationsbefehl ermitteln (variiert je nach Software)
  #$uninstallString = (Get-WmiObject -Class Win32_Product | Where-Object {$_.Name -like "*$softwareName*"}).UninstallString

  # Deinstallation durchführen (mit Überprüfung auf Erfolg)
  try {
    & $softwareName /uninstall
    write-host $LastExitCode
    if ($LastExitCode -eq 0) {
      Write-Host "Software '$softwareName' erfolgreich deinstalliert."
      Exit 0
    } else {
      Write-Host "Fehler bei der Deinstallation von '$softwareName'. Exit-Code: $LastExitCode"
      Exit 1
    }
  } catch {
    Write-Host "Fehler bei der Ausführung des Deinstallationsbefehls: $_"
    Exit 1
  }
} else {
  Write-Host "Software '$softwareName' ist nicht installiert."
  Exit 0
}