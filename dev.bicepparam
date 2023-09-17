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

@description ('The version of Kubernetes to use')
@allowed([
  '1.28.0'
  '1.27.3'
  '1.27.1'
  '1.26.6'
])
param kubernetesVersion = '1.27.3'

@description ('Address space for the virtual network')
param vnetAddressSpace = [
  '10.0.0.0/16'
]
param nodeSubnetPrefix = '10.0.2.0/24'

@description ('The name of the AKS cluster')
param nodeSettings = {
  nodeCount: 3
  //You must choose a VM type that supports Azure premium storage and a minimum of 4 vCPUs.
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
