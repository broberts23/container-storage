param location string
param clusterName string
param kubernetesVersion string
param vnetAddressSpace array
param nodeSubnetPrefix string
param nodeSettings object
param nodeNetworkProfile object


@description('Create the VNet')
resource vnet 'Microsoft.Network/virtualNetworks@2021-05-01' = {
  name: '${clusterName}-vnet'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: vnetAddressSpace
    }
    subnets: [
      {
        name: '${clusterName}-snet'
        properties: {
          addressPrefix: nodeSubnetPrefix
        }
      }
    ]
  }
}

@description('Create the AKS cluster')
resource aks 'Microsoft.ContainerService/managedClusters@2023-07-02-preview' = {
  name: clusterName
  location: location

  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    kubernetesVersion: kubernetesVersion
    dnsPrefix: clusterName
    enableRBAC: true
    agentPoolProfiles: [
      {
        name: 'agentpool'
        // the node pool label to associate the node pool with the correct IO engine for Azure Container Storage
        nodeLabels: {
          'acstor.azure.com/io-engine': 'acstor'
        }
        count: nodeSettings.nodeCount
        vmSize: nodeSettings.nodeSize
        osType: nodeSettings.osType
        osSKU: nodeSettings.osSKU
        mode: 'System'
        vnetSubnetID: resourceId('Microsoft.Network/virtualNetworks/subnets', vnet.name, '${clusterName}-snet')
      }
    ]
    networkProfile: {
      networkPlugin: nodeNetworkProfile.networkPlugin
      serviceCidr: nodeNetworkProfile.serviceCidr
      dnsServiceIP: nodeNetworkProfile.dnsServiceIP
    }
  }
}

@description('Create the role assignment for the AKS cluster')
resource rbac 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(aks.id)
  scope: resourceGroup()
  properties: {
    roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
    principalId: aks.identity.principalId
    principalType: 'ServicePrincipal'
  }
}

output controlPlaneFQDN string = aks.properties.fqdn
