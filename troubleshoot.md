# Troubleshooting Tips

## Bugs Handling

Extra consideration needed if you use Windows agent and environment.

1. For Windows Agent

There is a bug.

https://github.com/Microsoft/azure-pipelines-tasks/issues/10224

add powershell script and use `mpath` variable instead of `Build.ARTIFACTSTAGINGDIRECTORY`

```
    $mpath = $env:BUILD_ARTIFACTSTAGINGDIRECTORY -replace "\\","\\\\"
    Write-Host "##vso[task.setvariable variable=mpath]$mpath"
```

2. Packer 1.4.2 bug

`azure-arm: unexpected EOF` error

https://github.com/hashicorp/packer/issues/7816

Packer 1.4.1 works: https://releases.hashicorp.com/packer/1.3.4/

3. Running `az cli`

`az cli` may not run correctly in Windows/CMD environment due to string format.
For example, single quote, that is `'` not working as in Linux.

```
"{""key"": ""value""}"
```

az vmss update -g test-dnc -n dncvmss --set virtualMachineProfile.osProfile.secrets[0].vaultCertificates[0].certificateUrl="https://mykv.vault.azure.net/secrets/ilkimxyz190514/5054df8c1e594d08aaff3bcff9024d0d" --set virtualMachineProfile.extensionProfile.extensions[0].settings="{""fileUris"": [""https://azureblob.blob.core.windows.net/container/iis_script.ps1"", ""https://azureblob.blob.core.windows.net/container/appsettings.json""],""commandToExecute"": ""powershell -ExecutionPolicy Unrestricted -File iis_script.ps1 -thumbprint AAAAAAAAAAAA

az vmss update -g test-dnc -n dncvmss --set virtualMachineProfile.osProfile.secrets[0].vaultCertificates[0].certificateUrl="https://mykv.vault.azure.net/secrets/ilkimxyz190728/dbd62781ea0649589a02ba6d0029e912" --set virtualMachineProfile.extensionProfile.extensions[0].settings="{""fileUris"": [""https://azureblob.blob.core.windows.net/container/iis_script.ps1"", ""https://azureblob.blob.core.windows.net/container/appsettings.json""],""commandToExecute"": ""powershell -ExecutionPolicy Unrestricted -File iis_script.ps1 -thumbprint BBBBBBBBBBBB""}" 

## Troubleshooting

1. packer template file location

```
..\_work\_temp\***.json
```

2. Install necessary tool before starting agent

- packer 1.4.1
- az cli 2.x

3. VMSS setting

if a target VMSS is stopped or something wrong. Azure arm deployment won't work and produce wrong error message

```
{
  "error": {
    "code": "BadRequest",
    "message": "Id /subscriptions/XXXX-XXXX-XXXX-XXXX/resourceGroups/test-sig/providers/Microsoft.Compute/galleries/testsig/images/sig-146/versions/1.0.146 is not a valid resource reference."
  }
}
```
## Handling ARM Changes

ARM behavior changes sometimes, following CLI was worked for updating certificate but it creates an internal error.

```
az vmss update -g $(rgname) -n $(prodvmss) --set virtualMachineProfile.osProfile.secrets[0].vaultCertificates[0].certificateUrl="$(certificateurl)" --set virtualMachineProfile.extensionProfile.extensions[0].settings="{""fileUris"": [""$(scripturl)"", ""$(appsettingsurl)""],""commandToExecute"": ""powershell -ExecutionPolicy Unrestricted -File $(scriptfile) -thumbprint $(thumbprint)""}"
```

Upgrade CLI changed as following

> Note that following CLIs run in a separated CLI script, see [upgrade-pipline.yml](./azure/release_sample/upgrade-pipeline.yml). 

```
az vmss update -g $(rgname) -n $(vmssName) --add virtualMachineProfile.osProfile.secrets[0].vaultCertificates "{""certificateUrl"": ""$(certificateurl)"", ""certificateStore"": ""My""}'

az vmss update -g $(rgname) -n $(vmssName) --set virtualMachineProfile.extensionProfile.extensions[0].settings="{""fileUris"": [""$(scripturl)"", ""$(appsettingsurl)""],""commandToExecute"": ""powershell -ExecutionPolicy Unrestricted -File $(scriptfile) -thumbprint $(thumbprint)""}"
```