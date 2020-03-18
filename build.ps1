<#
build and make zip package
#>

param (
    [string]$cmd
)

if ($cmd -eq "" -or $cmd -eq "build")
{
    Write-Host "building..."

    Remove-Item app -Force -Recurse -ErrorAction Ignore
    
    dotnet publish -o app -c Release apiapp\apiapp.csproj

    Compress-Archive -Path app\* -DestinationPath apiapp.zip -Force
}
elseif ($cmd -eq "clean")
{
    Write-Host "cleaning..."
    Get-ChildItem .\ -include bin,obj,.terraform,terraform.tfstate*,*.zip -Recurse | % {  echo $_.fullname; remove-item $_.fullname -Force -Recurse }
}
else
{
    Write-Host "build.ps1 [build | clean]"
}



