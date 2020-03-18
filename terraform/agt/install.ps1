<#
Install DevOps Agent VM
https://docs.microsoft.com/en-us/azure/devops/pipelines/agents/v2-windows?view=azure-devops

** THIS IS A REFERENCE SCRIPT, DO NOT RUN THIS SCRIPT FROM CONSOLE **
Run as Administrator
#>

# Install Packer
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Invoke-WebRequest https://releases.hashicorp.com/packer/1.5.1/packer_1.5.1_windows_amd64.zip -outfile .\packer_1.5.1_windows_amd64.zip
Expand-Archive -Path .\packer_1.5.1_windows_amd64.zip -DestinationPath c:\bin\ -Force
setx PATH "$env:path;c:\bin" -m

# Install Azure CLI
Invoke-WebRequest -Uri https://aka.ms/installazurecliwindows -OutFile .\AzureCLI.msi; Start-Process msiexec.exe -Wait -ArgumentList '/I AzureCLI.msi /quiet'

# Install Dotnet Core
Invoke-WebRequest https://download.visualstudio.microsoft.com/download/pr/854ca330-4414-4141-9be8-5da3c4be8d04/3792eafd60099b3050313f2edfd31805/dotnet-sdk-3.1.101-win-x64.exe -outfile .\dotnet-sdk-3.1.101-win-x64.exe
Start-Process .\dotnet-sdk-3.1.101-win-x64.exe -ArgumentList '/quiet' -Wait

# open new(restart) console

# Install DevOps Agent
Invoke-WebRequest https://vstsagentpackage.azureedge.net/agent/2.163.1/vsts-agent-win-x64-2.163.1.zip -outfile .\vsts-agent-win-x64-2.163.1.zip
Expand-Archive -Path .\vsts-agent-win-x64-2.163.1.zip -DestinationPath c:\agent

# Check `dotnet` & `packer` are correctly installed and run agent 
cd c:\agent
run.cmd
