Install-Module -Name DockerMsftProvider -Repository PSGallery -Force
Set-DnsClientServerAddress -InterfaceAlias ("Ethernet 2") -ServerAddresses ("8.8.8.8")


mkdir "C:\temp"
Start-BitsTransfer -Source "https://go.microsoft.com/fwlink/?linkid=2109019" -Destination "C:\temp\sqlpackage.zip"

Add-Type -AssemblyName System.IO.Compression.FileSystem; `
[System.IO.Compression.ZipFile]::ExtractToDirectory("C:\temp\sqlpackage.zip", "C:\tools\sqlpackage")

