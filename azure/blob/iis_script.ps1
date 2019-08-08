param (
    [string]$thumbprint
)

function logging($output)
{
    $time = Get-Date
    Write-Output "$time - $output" >> customscript.log
}

logging("start logging")

logging("copying appsettings.json")
Copy-Item -Path .\appsettings.json -Destination c:\inetpub\wwwroot

logging("enabling IIS SSL")
logging("--thumbprint: $thumbprint")
# https://docs.microsoft.com/en-us/azure/virtual-machines/windows/tutorial-secure-web-server#configure-iis-to-use-the-certificate
New-WebBinding -Name "Default Web Site" -Protocol https -Port 443

# Import-Module WebAdministration 
if (Test-Path IIS:\SslBindings\0.0.0.0!443) {Remove-Item -Path IIS:\SslBindings\0.0.0.0!443}
Get-ChildItem cert:\LocalMachine\My\$thumbprint | New-Item -Force -Path IIS:\SslBindings\!443

logging("restart IIS SSL")
net stop was /y
net start w3svc

logging("end logging")
