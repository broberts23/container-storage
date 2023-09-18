param location string = resourceGroup().location
param clusterName string
param nodeCount int
param nodeSize string

@description('Create the AKS cluster')
resource aks 'Microsoft.ContainerService/managedClusters@2023-07-02-preview' = {
  name: clusterName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    dnsPrefix: clusterName
    agentPoolProfiles: [
      {
        name: 'agentpool'
        // the node pool label to associate the node pool with the correct IO engine for Azure Container Storage
        nodeLabels: {
          'acstor.azure.com/io-engine': 'acstor'
        }
        count: nodeCount
        vmSize: nodeSize
        mode: 'System'
      }
    ]
  }
}

output controlPlaneFQDN string = aks.properties.fqdn
