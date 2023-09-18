using 'main.bicep'

@description ('Allowed deployment locations')
@allowed([
  'australiaeast'
  'australiasoutheast'
  'australiacentral'
])
param location = 'australiaeast'

@description ('The name of the AKS cluster')
param nodeSettings = {
  nodeCount: 3
  //You must choose a VM type that supports Azure premium storage and a minimum of 4 vCPUs.
  nodeSize: 'Standard_D4s_v5'
}
