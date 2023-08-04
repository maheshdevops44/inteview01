https://docs.microsoft.com/en-us/azure/virtual-machines/windows/tutorial-manage-vm


# Sign in to your Azure subscription
Connect-AzAccount

# Current active Subscriptions
Get-Azcontext

# Connect with perticular subscription for your current session
Select-AzSubscription -Subscription "Pay-As-You-Go"

Get-AzResource -ResourceGroupName myResourceGroupVM | Format-Table

<#
Load balance Windows virtual machines in Azure to create a highly available application with Azure PowerShell

An Azure load balancer is a Layer-4 (TCP, UDP) load balancer that provides high availability by distributing incoming traffic among healthy VMs. A load balancer health probe monitors a given port on each VM and only distributes traffic to an operational VM.
You define a front-end IP configuration that contains one or more public IP addresses. This front-end IP configuration allows your load balancer and applications to be accessible over the Internet.
Virtual machines connect to a load balancer using their virtual network interface card (NIC). To distribute traffic to the VMs, a back-end address pool contains the IP addresses of the virtual (NICs) connected to the load balancer.
To control the flow of traffic, you define load balancer rules for specific ports and protocols that map to your VMs.
#>

# Create RG
New-AzResourceGroup `
  -ResourceGroupName "myResourceGroupLoadBalancer" `
  -Location "EastUS"

# Create a public IP address
# To access your app on the Internet, you need a public IP address for the load balancer. 
$publicIP = New-AzPublicIpAddress `
  -ResourceGroupName "myResourceGroupLoadBalancer" `
  -Location "EastUS" `
  -AllocationMethod "Static" `
  -Name "myPublicIP"

# creates a frontend IP pool named myFrontEndPool and attaches the myPublicIP address:
$frontendIP = New-AzLoadBalancerFrontendIpConfig `
  -Name "myFrontEndPool" `
  -PublicIpAddress $publicIP

# creates a backend address pool
$backendPool = New-AzLoadBalancerBackendAddressPoolConfig `
  -Name "myBackEndPool"

# creates a load balancer named myLoadBalancer using the frontend and backend IP pools created
$lb = New-AzLoadBalancer `
  -ResourceGroupName "myResourceGroupLoadBalancer" `
  -Name "myLoadBalancer" `
  -Location "EastUS" `
  -FrontendIpConfiguration $frontendIP `
  -BackendAddressPool $backendPool

# Create a health probe
Add-AzLoadBalancerProbeConfig `
  -Name "myHealthProbe" `
  -LoadBalancer $lb `
  -Protocol tcp `
  -Port 80 `
  -IntervalInSeconds 15 `
  -ProbeCount 2

# To apply the health probe, update the load balancer 
Set-AzLoadBalancer -LoadBalancer $lb

