https://docs.microsoft.com/en-us/azure/virtual-machines/windows/tutorial-manage-vm


# Sign in to your Azure subscription
Connect-AzAccount

# Current active Subscriptions
Get-AzSubscription
Get-Azcontext

# Connect with perticular subscription for your current session
Select-AzSubscription -Subscription "Pay-As-You-Go"

### Marketplace Images

# Use the Get-AzVMImagePublisher command to return a list of image publishers:
Get-AzVMImagePublisher -Location "EastUS"

# Use the Get-AzVMImageOffer to return a list of image offers
Get-AzVMImageOffer `
   -Location "EastUS" `
   -PublisherName "MicrosoftWindowsServer"

# The Get-AzVMImageSku command will then filter on the publisher and offer name to return a list of image names.
Get-AzVMImageSku `
   -Location "EastUS" `
   -PublisherName "MicrosoftWindowsServer" `
   -Offer "WindowsServer"

# This information can be used to deploy a VM with a specific image. 
# This example deploys a VM using the latest version of a Windows Server 2016 with Containers image.
   New-AzVm `
    -ResourceGroupName "myResourceGroupVM" `
    -Name "myVM2" `
    -Location "EastUS" `
    -VirtualNetworkName "myVnet" `
    -SubnetName "mySubnet" `
    -SecurityGroupName "myNetworkSecurityGroup" `
    -PublicIpAddressName "myPublicIpAddress2" `
    -ImageName "MicrosoftWindowsServer:WindowsServer:2016-Datacenter-with-Containers:latest" `
    -Credential $cred `
    -AsJob

