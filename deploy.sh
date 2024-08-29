#!/usr/bin/env bash

OS='windows'
LOCATION='eastus2'
STORAGE_NAME='stmcsimplestore559' # must be globally unique
FN_NAME='SimpleOrchestration559'

RG_NAME="rg-simple-orchestration-$LOCATION-$OS-2"


# az login
az group create -n $RG_NAME -l $LOCATION

az storage account create \
  --name $STORAGE_NAME \
  -l $LOCATION \
  -g $RG_NAME \
  --sku Standard_LRS \
  --allow-blob-public-access false

az functionapp create \
  --name $FN_NAME \
  -g $RG_NAME \
  --consumption-plan-location $LOCATION \
  --runtime dotnet-isolated \
  --functions-version 4  \
  --storage-account $STORAGE_NAME \
  --os-type $OS

sleep 3

pushd src

# Note: If you get the error "Can't determine Project to build. Expected 1 .csproj or .fsproj but found 2" while publishing,
# see https://github.com/Azure/azure-functions-core-tools/issues/3594.  :( 
# delete the bin and obj folders and try to publish again.
rm -rf bin obj
func azure functionapp publish $FN_NAME

popd