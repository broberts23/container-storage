# Azure Container Storage: An Introspective

👋 Hey there, fellow techies! Are you tired of dealing with the headache of managing storage for your container workloads? 😩 Well, fear not! Azure Container Storage is here to save the day! 🦸‍♂️💾

In this blog post, we'll dive into the world of Azure Container Storage and explore how it can make your life as a developer so much easier. 🤓 We'll cover everything from the basics of container storage to advanced features like encryption and access policies. 🔒

So sit back, relax, and let's take a journey through the wonderful world of Azure Container Storage! 🚀

## What is Azure Container Storage?

Azure Container Storage solves the problem of managing storage for container workloads in a scalable, secure, and cost-effective way. It provides a fully managed, cloud-native solution for volume management, deployment, and orchestration for containers, and seamlessly integrates with Kubernetes to enable automatic and dynamic provisioning of persistent volumes. By using Azure Container Storage, developers can focus on building and deploying containerized applications without worrying about the underlying storage infrastructure.

Container Storage is a managed service that provides persistent storage for containerized applications. It supports both block and file storage, and can be used with any container orchestrator that supports the Container Storage Interface (CSI). It is built on top of Azure Storage, which provides a highly available, durable, and scalable storage platform for all types of data.

Container Storage Pools are the basic building blocks of Azure Container Storage. They are logical groupings of storage resources that can be used to provision persistent volumes for containers. Each pool has its own set of storage resources, which can be scaled up or down independently of other pools in the same account. This allows you to easily manage your storage resources based on the needs of your applications.

Read more here: https://learn.microsoft.com/en-us/azure/storage/container-storage/container-storage-introduction

and here: https://techcommunity.microsoft.com/t5/azure-storage-blog/azure-container-storage-in-public-preview/ba-p/3819246

## What are the benefits of using Azure Container Storage?

1. Lowering the total cost of ownership by enabling shared provisioning of capacity and performance on a storage pool, which can be leveraged by multiple volumes.

1. Rapid scale-out of stateful pods using remote network protocols like NVME-oF and iSCSI to mount PV, enabling effortless scaling on AKS across Compute and Storage.

1. Simplified consistent volume management interface backed by local and remote storage options enabling customers to allocate and use storage via the Kubernetes control plane.

1. Fully integrated day-2 experiences, including data protection, cross-cluster recovery, and observability providing operational simplicity for customers who need to create customer scripts or stitch together disparate tools today.

## Supported storage types

Azure Container Storage supports the following storage types:

1. Azure Elastic SAN Preview: This is a highly scalable and performant shared file system that can be used as persistent storage for containerized applications. It provides a fully managed, cloud-native solution for storing and sharing data across multiple containers and pods.

1. Azure Disks: This is a managed disk service that provides high-performance, low-latency storage for virtual machines and container workloads. It supports both standard and premium disk types, with options for encryption and snapshots.

1. Ephemeral Disk: This is a temporary disk that is created and attached to a container when it is scheduled on a node. It provides fast, local storage for temporary data that does not need to be persisted beyond the lifetime of the container.

Each storage option has its own strengths and weaknesses, and the best option for your use case will depend on factors like performance, scalability, cost, and data access patterns.

## Creating the underlying Infrastructure

Before we can start using Azure Container Storage, we need to create the underlying infrastructure. This includes creating a resource group, storage account, and container registry and AKS cluster. We'll use bicep to create these resources. You can find code for this blog in my GitHub repo.

https://github.com/broberts23/container-storage

For simplicity we'll contain the code in a single main.bicep but split the parameters into a separate .bi file. This will allow us to easily change the parameters without having to modify the main file.

```bicep

```

To use Azure Container Storage with Azure managed disks, your AKS cluster should have a node pool of at least three general purpose VMs such as standard_d4s_v5 for the cluster nodes, each with a minimum of four virtual CPUs (vCPUs).

## Connecting to the AKS cluster

After the cluster has been deployed, we need to connect to it to install Azure Container Storage. Instead of using Azure CLI and kubectl, we'll use the Kubernetes extension for VS Code. This extension allows us to easily connect to an AKS cluster and run commands against it from within VS Code.

Find your new cluster under the CLOUD pane in VS Code and right click on it. Select "Merge into KubeConfig" from the context menu. Then refresh the top CLUSTERS pane if your cluster is not automatically selected.

![Alt text](image-1.png)

After connecting to the cluster the mode important thing to validate is the label `acstor.azure.com/io-engine=acstor` has been added to the nodes

![Alt text](image.png)

## Installing Azure Container Storage

Replace <cluster-name> and <resource-group> with your own values. The <name> value can be whatever you want; it's just a label for the extension you're installing.

```bash
az k8s-extension create --cluster-type managedClusters --cluster-name <cluster name> --resource-group <resource group name> --name <name of extension> --extension-type microsoft.azurecontainerstorage --scope cluster --release-train stable --release-namespace acstor
```

If prompted to install k8s-extension extension, select Y.
If the recieve a warning that 'Microsoft.KubernetesConfiguration' provider has not been registered, use the following command to register it:

```bash
az provider register --namespace Microsoft.Kubernetes
az provider register --namespace Microsoft.KubernetesConfiguration
az provider register --namespace Microsoft.ExtendedLocation
```

Installation takes 10-15 minutes to complete

We can verify the installation by running the following command:

```bash