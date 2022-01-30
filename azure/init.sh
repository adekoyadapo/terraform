# Setup Variables.
randomInt=`echo $((1000 + $RANDOM % 10000))`
subscriptionId=$(az account show --query id -o tsv)
resourceGroupName="backend-Sec-RG"
storageName="tfcorebackendsa$randomInt"
kvName="tf-core-backend-kv$randomInt"
appName="tf-core-github-SPN$randomInt"
region="eastus"

# Create a resource resourceGroupName
az group create --name "$resourceGroupName" --location "$region"

# Create a Key Vault
az keyvault create \
    --name "$kvName" \
    --resource-group "$resourceGroupName" \
    --location "$region" \
    --enable-rbac-authorization

# Authorize the operation to create a few secrets - Signed in User (Key Vault Secrets Officer)
az role assignment create \
    --role "Key Vault Secrets Officer" \
    --assignee $(az ad signed-in-user show --query objectId -o tsv) \
    --scope "/subscriptions/$subscriptionId/resourceGroups/$resourceGroupName/providers/Microsoft.KeyVault/vaults/$kvName"

# Create an azure storage account - Terraform Backend Storage Account
az storage account create \
    --name "$storageName" \
    --location "$region" \
    --resource-group "$resourceGroupName" \
    --sku "Standard_LRS" \
    --kind "StorageV2" \
    --https-only true \
    --min-tls-version "TLS1_2"

# Authorize the operation to create the container - Signed in User (Storage Blob Data Contributor Role)
az role assignment create \
    --role "Storage Blob Data Contributor" \
    --assignee $(az ad signed-in-user show --query objectId -o tsv) \
    --scope "/subscriptions/$subscriptionId/resourceGroups/$resourceGroupName/providers/Microsoft.Storage/storageAccounts/$storageName"


#Create Upload container in storage account to store terraform state files
sleep 40
az storage container create \
    --account-name "$storageName" \
    --name "tfstate" \
    --auth-mode login

# Create Terraform Service Principal and assign RBAC Role on Key Vault
spnJSON=$(az ad sp create-for-rbac --name $appName \
    --role "" \
    --scopes /subscriptions/$subscriptionId/resourceGroups/$resourceGroupName/providers/Microsoft.KeyVault/vaults/$kvName)

# Save new Terraform Service Principal details to key vault
az keyvault secret set --vault-name $kvName --name "ARM-CLIENT-ID" --value $(echo $spnJSON | jq -r '.appId')
az keyvault secret set --vault-name $kvName --name "ARM-CLIENT-SECRET" --value $(echo $spnJSON | jq -r '.password')
az keyvault secret set --vault-name $kvName --name "ARM-TENANT-ID" --value $(echo $spnJSON | jq -r '.tenant')
az keyvault secret set --vault-name $kvName --name "ARM-SUBSCRIPTION-ID" --value $subscriptionId

# Assign additional RBAC role to Terraform Service Principal Subscription as Contributor and access to backend storage
az role assignment create --assignee $(az ad sp list --display-name $appName --query '[].appId' -o tsv) \
        --role "Contributor" \
        --subscription $subscriptionId

az role assignment create --assignee $(az ad sp list --display-name $appName --query '[].appId' -o tsv) \
        --role "Storage Blob Data Contributor" \
        --scope "/subscriptions/$subscriptionId/resourceGroups/$resourceGroupName/providers/Microsoft.Storage/storageAccounts/$storageName"

# Login

export ARM_CLIENT_ID=$(az keyvault secret show --vault-name tf-core-backend-kv10063 --subscription 2cf0e780-ab00-410a-b769-ea8c4197e36e --name ARM-CLIENT-ID  --query value --output tsv) 
export ARM_CLIENT_SECRET=$(az keyvault secret show --vault-name tf-core-backend-kv10063 --subscription 2cf0e780-ab00-410a-b769-ea8c4197e36e --name ARM-CLIENT-SECRET  --query value --output tsv)
export ARM_TENANT_ID=$(az keyvault secret show --vault-name tf-core-backend-kv10063 --subscription 2cf0e780-ab00-410a-b769-ea8c4197e36e --name ARM-TENANT-ID  --query value --output tsv)
export ARM_SUBSCRIPTION_ID=$(az account show --query id -o tsv)
az login --service-principal --username $ARM_CLIENT_ID --password $ARM_CLIENT_SECRET --tenant $ARM_TENANT_ID