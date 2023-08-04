https://docs.microsoft.com/en-us/azure/virtual-machines/windows/tutorial-manage-vm


# Sign in to your Azure subscription
Connect-AzAccount

# Current active Subscriptions
Get-Azcontext

# Connect with perticular subscription for your current session
Select-AzSubscription -Subscription "Pay-As-You-Go"


# To see a list of VM sizes available in a particular region, use the Get-AzVMSize command
Get-AzVMSize -Location "EastUS"


# Before resizing a VM, check if the size you want is available on the current VM cluster. The Get-AzVMSize command returns a list of sizes.
Get-AzVMSize -ResourceGroupName "myResourceGroupVM" -VMName "myVM"

# If the size is available, the VM can be resized from a powered-on state, however it is rebooted during the operation.
$vm = Get-AzVM `
   -ResourceGroupName "myResourceGroupVM"  `
   -VMName "myVM"
$vm.HardwareProfile.VmSize = "Standard_DS3_v2"
Update-AzVM `
   -VM $vm `
   -ResourceGroupName "myResourceGroupVM"

# If the size you want isn't available on the current cluster, the VM needs to be deallocated before the resize operation can occur. 
# Deallocating a VM will remove any data on the temp disk, and the public IP address will change unless a static IP address is being used.   
Stop-AzVM `
   -ResourceGroupName "myResourceGroupVM" `
   -Name "myVM" -Force
$vm = Get-AzVM `
   -ResourceGroupName "myResourceGroupVM"  `
   -VMName "myVM"
$vm.HardwareProfile.VmSize = "Standard_E2s_v3"
Update-AzVM -VM $vm `
   -ResourceGroupName "myResourceGroupVM"
Start-AzVM `
   -ResourceGroupName "myResourceGroupVM"  `
   -Name $vm.name
