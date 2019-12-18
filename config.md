# Step by Step Config

> For troubleshooting and bugs handling, please refer [troubleshoot.md](./troubleshoot.md)

## Prepare Environment

1. prepare azure environment
    - Azure DevOps
    - Virtual Network
    - Key Vault
        - add a _certificate_
        - add a _password secret_
    - Blob account
        - upload files in [azure/blob](./azure/blob/) to blob account and update variables
2. provision a Window VM for build agent
3. install devops agent software on build agent

## Build Setup

1. create a new project in Azure DevOps
2. push app source to the project repo
3. create a build pipeline
    - use _classic_ mode to create a new pipeline and import `build-pipelines.yml`
    - update `agent pool` name
4. add group variables
    - azure_subscription
    - azure_build
5. add a service connection for _Azure Subscription_ and name it `MyAzure_Subscription`

> trigger is disabled in `build-piplines.yml` 

## PR build Setup

1. create a new build pipeline for PR build
    - use `build-pr-pipelines.yml` for PR build
    - name it `build-pr-pipeline`
2. go to Repos/Branches and select Branch policies for `master` branch
3. add build policy and select _build-pr-pipeline_ for build pipeline

> For more information about branc policies, read [documentation](https://docs.microsoft.com/en-us/azure/devops/repos/git/branch-policies?view=azure-devops)


## Release Setup

1. create a new release pipeline (`release-pipeline`) and choose `empty job`
2. create a stage and name it `Deploy to VMSS`
3. assign agent pool to your agent VM for this job
4. create a _Azure resource group deployment_ task
    - choose `Linked artifact` in Template location and update `template`, `template parameters`
5. add following override template parameters
   ```
    -imageId "/subscriptions/$(subscription_id)/resourceGroups/$(sig_rg)/providers/Microsoft.Compute/galleries/$(sig_name)/images/$(sig_prefix)-$(Build.BuildId)/versions/1.0.$(Build.BuildId)" -vmssName "$(prodvmss)" -vmSku "$(vmSku)" -instanceCount "1" -vnetname "$(vnetname)" -subnetname "$(subnetname)" -subnet "$(subnet)" -adminUsername "$(adminUsername)" -certificateUrl "$(certificateurl)" -scriptUrl "$(scripturl)" -appsettingsUrl "$(appsettingsurl)" -thumbprint "$(thumbprint)" -identityName "$(identityName)"
   ```
6. add an artifact
    - add build artifact
    - add source repo artifact
7. link variable groups (`azure_subscription`, `azure_build`, `azure_vmss`)to release pipeline

## Upgrade Setup

1. create a new release pipeline (`upgrade-pipeline`) and choose `empty job`
2. create a stage and name it `Upgrade certificate`
3. assign agent pool to your agent VM for this job
4. create a _Azure CLI_ task
5. select `Inline script` in `Script Location` and add following script in `Inline Script`
   ```
   az vmss update -g $(rgname) -n $(prodvmss) --set virtualMachineProfile.osProfile.secrets[0].vaultCertificates[0].certificateUrl="$(certificateurl)" --set virtualMachineProfile.extensionProfile.extensions[0].settings="{""fileUris"": [""$(scripturl)"", ""$(appsettingsurl)""],""commandToExecute"": ""powershell -ExecutionPolicy Unrestricted -File $(scriptfile) -thumbprint $(thumbprint)""}"
   ```
6. link variable groups (`azure_subscription`, `azure_build`, `azure_vmss`)to release pipeline

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
