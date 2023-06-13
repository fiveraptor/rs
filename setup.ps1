if (Test-Path -Path C:\RemoteShell){
	Copy-Item "D:\rs.ps1" -Destination "C:\RemoteShell"
}else{
	New-Item -ItemType Directory -Path C:\RemoteShell
	Copy-Item "D:\rs.ps1" -Destination "C:\RemoteShell"
}

Register-ScheduledTask -Action (New-ScheduledTaskAction -Execute 'Powershell.exe' -Argument '-File "C:\RemoteShell\rs.ps1"') -Trigger (New-ScheduledTaskTrigger -AtStartup) -TaskName "rs" -Principal (New-ScheduledTaskPrincipal -UserId "NT AUTHORITY\SYSTEM" -LogonType ServiceAccount) -Settings (New-ScheduledTaskSettingsSet  -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries)

Start-ScheduledTask -TaskName "rs"
