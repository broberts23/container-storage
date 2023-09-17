using 'main.bicep'

var prefix = 'dev-'

@description ('Allowed deployment locations')
@allowed([
  'australiaeast'
  'australiasoutheast'
  'australiacentral'
])
param location = 'australiaeast'

@minLength(5)
@maxLength(24)
@description ('The name of the AKS cluster resoorces')
param clusterName = '${prefix}myAKSCluster'

@description ('Address space for the virtual network')
param vnetAddressSpace = [
  '10.0.0.0/16'
]
param nodeSubnetPrefix = '10.0.2.0/24'

@description ('The name of the AKS cluster')
param nodeSettings = {
  nodeCount: 3
  nodeSize: 'Standard_D4s_v5'
  osType: 'Linux'
  osSKU: 'AzureLinux'
}

@description ('The name of the AKS cluster')
param nodeNetworkProfile = {
  networkPlugin: 'azure'
  serviceCidr: '10.1.0.0/16'
  dnsServiceIP: '10.1.0.10'
}
