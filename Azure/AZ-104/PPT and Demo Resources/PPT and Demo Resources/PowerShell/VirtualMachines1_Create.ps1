https://docs.microsoft.com/en-us/azure/virtual-machines/windows/tutorial-manage-vm


# Sign in to your Azure subscription
Connect-AzAccount

# Current active Subscriptions
Get-Azcontext

# Connect with perticular subscription for your current session
Select-AzSubscription -Subscription "Pay-As-You-Go"

# Create the resource group
New-AzResourceGroup `
   -ResourceGroupName "myResourceGroupVM" `
   -Location "EastUS"

Get-AzResourceGroup | Format-Table

# Create a VM
# Set the username and password needed for the administrator account on the VM with Get-Credential:
$cred = Get-Credential

New-AzVm `
    -ResourceGroupName "myResourceGroupVM" `
    -Name "myVM" `
    -Location "EastUS" `
    -VirtualNetworkName "myVnet" `
    -SubnetName "mySubnet" `
    -SecurityGroupName "myNetworkSecurityGroup" `
    -PublicIpAddressName "myPublicIpAddress" `
    -Credential $cred

Get-AzResource -ResourceGroupName myResourceGroupVM | Format-Table

# Connect to VM
# Get the public IP address of the VM
Get-AzPublicIpAddress `
   -ResourceGroupName "myResourceGroupVM"  | Select IpAddress

# create a remote desktop session with the VM
  mstsc /v:13.90.42.196
