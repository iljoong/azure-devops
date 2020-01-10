# Step by Step Config

> For troubleshooting and bugs handling, please refer [troubleshoot.md](./troubleshoot.md)

## Prepare Environment

1. prepare azure environment
    - Azure DevOps
    - Virtual Network
    - Key Vault
        - add a _certificate_
        - add a _password secret_ for admin password
        - manually update `adminPassword.reference.keyVault.id` in [vmss.parameters.json](./template/vmss.parameters.json)
    - Blob account
        - upload files in [azure/blob](./azure/blob/) to blob account and update variables
2. provision a Window VM for build agent
3. install devops agent software on build agent

## Variables & Azure Subscription

1. add `variable group` in __Pipeline/Library__, please refer variables in [variables.yml](./variables.yml)
    - azure_subscription
    - azure_build
    - azure_vmss
2. add a service connection for _Azure Subscription_ in __Settings/Service connections__
    - create a `Azure Resource Manager`
    - use connection name as `MyAzure_Subscription`
    - check `allow all pipelines to use this connection`

## Build Setup

1. create a new project in Azure DevOps
2. push app source to the project repo
3. create a build pipeline
    - create a new pipeline with `Azure Repos Git (YAML)` and import `build-pipelines.yml`
    - update some variables like `agent pool` name
4. rename it as `build-pipeline`

> trigger is disabled in `build-piplines.yml` 

## PR build Setup

1. create a new build pipeline for PR build
    - use `build-pr-pipelines.yml` for PR build
2. rename it as `build-pr-pipeline`
3. go to Repos/Branches and select Branch policies for `master` branch
4. add build policy and select _build-pr-pipeline_ for build pipeline

> For more information about branc policies, read [documentation](https://docs.microsoft.com/en-us/azure/devops/repos/git/branch-policies?view=azure-devops)


## Release Setup

> Unlike build pipeline, you need to create a release pipeline manually. Please refer sample [release pipeline](./azure/release_sample/release-pipeline.yml)

1. create a new release pipeline (`release-pipeline`) and choose `empty job`
2. create a stage and name it `Deploy to VMSS`
3. add an artifact
    - add build artifact
    - add source repo artifact (latest master branch)
4. assign _your agent VM_ in agent pool
5. create a _Powershell_ task for debugging
    - select `inline` type
    - add following script
    ```
    # Write your PowerShell commands here.
    Write-Host "imageId : /subscriptions/$(subscription_id)/resourceGroups/$(sig_rg)/providers/Microsoft.Compute/galleries/$(sig_name)/images/$(sig_prefix)-$(Build.BuildId)/versions/1.0.$(Build.BuildId)"
    Write-Host "scripturl: $(scripturl)" 
    Write-Host "appseetingsurl: $(appsettingsurl)"
    Write-Host "thumbprint $(thumbprint)"
    Write-Host "certificateurl: $(certificateurl)"
    ``` 
6. create a _Azure resource group deployment_ task
    - choose `Linked artifact` in Template location
    - add __template__ (`/template/vmss_edisk.json`) and __template parameters__ (`/template/vmss.parameters.json`) from template folder
    - add following override template parameters
    ```
    -vmssName $(prodvmss) -vmSku "Standard_D2s_v3" -instanceCount 1 -vnetname $(vnetname) -subnetname $(subnetname) -ilbip "10.0.3.100" -subnet "10.0.3.0/24" -adminUsername "iljoong" -imageId "/subscriptions/$(subscription_id)/resourceGroups/$(sig_rg)/providers/Microsoft.Compute/galleries/$(sig_name)/images/$(sig_prefix)-$(Build.BuildId)/versions/1.0.$(Build.BuildId)" -vaultResourceId $(vaultid) -certificateUrl $(certificateurl) -scriptUrl $(scripturl) -appsettingsUrl $(appsettingsurl) -thumbprint $(thumbprint) -identityName $(identityName)
    ```
7. link variable groups (`azure_subscription`, `azure_build`, `azure_vmss`)to release pipeline

## Upgrade Setup

> Like release pipeline, you need to create it manually. Please refer sample [upgrade pipeline](./azure/release_sample/upgrade-pipeline.yml)

1. create a new release pipeline (`upgrade-pipeline`) and choose `empty job`
2. create a stage and name it `Upgrade certificate`
3. assign agent pool to your agent VM for this job
4 create a _Powershell_ task for debugging
    - select `inline` type
    - add following script
    ```
    Write-Host "certificateurl: $(certificateurl)"
    Write-Host "thumbprint: $(thumbprint)"
    ```
5. create two  _Azure CLI_ tasks
   - select `Inline script` in `Script Location`
   - add following script in `Inline Script`
   ```
    az vmss update -g $(rgname) -n $(vmssName) --add virtualMachineProfile.osProfile.secrets[0].vaultCertificates "{""certificateUrl"": ""$(certificateurl)"", ""certificateStore"": ""My""}"
   ```
   - add another script in `Inline Script`
   ```
    az vmss update -g $(rgname) -n $(vmssName) --set virtualMachineProfile.extensionProfile.extensions[0].settings="{""fileUris"": [""$(scripturl)"", ""$(appsettingsurl)""],""commandToExecute"": ""powershell -ExecutionPolicy Unrestricted -File $(scriptfile) -thumbprint $(thumbprint)""}"
   ```
6. link variable groups (`azure_subscription`, `azure_build`, `azure_vmss`)to upgrade pipeline

> VMSS template behavior has been changed. You no longer modify `virtualMachineProfile.osProfile.secrets[0].vaultCertificates[0].certificateUrl` but you need to __add__ new certficate.

## Build and Release

Manually trigger build and release

## References

  - Quick start: https://docs.microsoft.com/en-us/azure/devops/pipelines/create-first-pipeline?view=azure-devops&tabs=tfs-2018-2
  - Dotnet Core: https://docs.microsoft.com/en-us/azure/devops/pipelines/languages/dotnet-core?view=azure-devops
  - Yaml schema: https://docs.microsoft.com/en-us/azure/devops/pipelines/yaml-schema?view=azure-devops&tabs=example
  - Pool: https://docs.microsoft.com/en-us/azure/devops/pipelines/agents/hosted?view=azure-devops#use-a-microsoft-hosted-agent
  - trigger: https://docs.microsoft.com/en-us/azure/devops/pipelines/build/triggers?view=azure-devops&tabs=yaml
  - variables: https://docs.microsoft.com/en-us/azure/devops/pipelines/library/variable-groups?view=azure-devops&tabs=yaml
  - predefined variables: https://docs.microsoft.com/en-us/azure/devops/pipelines/build/variables?view=azure-devops&tabs=yaml
  - (TODO) Reference secrets with dynamic ID: https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-manager-keyvault-parameter#reference-secrets-with-dynamic-id