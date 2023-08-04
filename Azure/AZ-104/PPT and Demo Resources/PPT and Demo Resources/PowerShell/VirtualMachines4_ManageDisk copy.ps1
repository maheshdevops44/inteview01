https://docs.microsoft.com/en-us/azure/virtual-machines/windows/tutorial-manage-vm


# Sign in to your Azure subscription
Connect-AzAccount

# Current active Subscriptions
Get-Azcontext

# Connect with perticular subscription for your current session
Select-AzSubscription -Subscription "Pay-As-You-Go"

# Create a VM
   $azRegion = "Central US"
   $azResourceGroup = "myDemoResourceGroup"
   $azVMName = "myDemoVM"
   $azDataDiskName = "myDemoDataDisk"

   New-AzVm `
      -Location $azRegion `
      -ResourceGroupName $azResourceGroup `
      -Name $azVMName `
      -Size "Standard_D2s_v3" `
      -VirtualNetworkName "myDemoVnet" `
      -SubnetName "myDemoSubnet" `
      -SecurityGroupName "myDemoNetworkSecurityGroup" `
      -PublicIpAddressName "myDemoPublicIpAddress"

# Add a data disk

# Create the data disk
# Before a data disk can be created, you must first create a disk object. 
   $diskConfig = New-AzDiskConfig `
      -Location $azRegion `
      -CreateOption Empty `
      -DiskSizeGB 128 `
      -SkuName "Standard_LRS"   

# After the disk object is created, use the New-AzDisk cmdlet to provision a data disk.
   $dataDisk = New-AzDisk `
      -ResourceGroupName $azResourceGroup `
      -DiskName $azDataDiskName `
      -Disk $diskConfig

# You can use the Get-AzDisk cmdlet to verify that the disk was created.
   Get-AzDisk `
      -ResourceGroupName $azResourceGroup `
      -DiskName $azDataDiskName

# Attach the data disk
# Get the VM to which you'll attach the data disk. 
   $vm = Get-AzVM `
      -ResourceGroupName $azResourceGroup `
      -Name $azVMName

# Next, attach the data disk to the VM's configuration
   $vm = Add-AzVMDataDisk `
      -VM $vm `
      -Name $azDataDiskName `
      -CreateOption Attach `
      -ManagedDiskId $dataDisk.Id `
      -Lun 1

# Finally, update the VM's configuration
   Update-AzVM `
      -ResourceGroupName $azResourceGroup `
      -VM $vm




# Initialize the data disk
<#
   Sign in to the Azure portal.
   Locate the VM to which you've attached the data disk. Create a Remote Desktop Protocol (RDP) connection and sign in as the local administrator.
   After you establish an RDP connection to the remote VM, select the Windows Start menu. Enter PowerShell in the search box and select Windows PowerShell to open a PowerShell window.
#>

# Connect to VM
# Get the public IP address of the VM
   Get-AzPublicIpAddress `
   -ResourceGroupName "myResourceGroupVM"  | Select IpAddress
# create a remote desktop session with the VM
   mstsc /v:13.90.42.196


# Initialize Disk
Get-Disk | Where PartitionStyle -eq 'raw' |
      Initialize-Disk -PartitionStyle MBR -PassThru |
      New-Partition -AssignDriveLetter -UseMaximumSize |
      Format-Volume -FileSystem NTFS -NewFileSystemLabel "myDemoDataDisk" -Confirm:$false

# Update the disk's size

# Select the VM that contains the disk that you'll resize with the Get-AzVM cmdlet.
$vm = Get-AzVM `
   -ResourceGroupName $azResourceGroup `
   -Name $azVMName

# Before you can resize a VM's disk, you must stop the VM. 
   Stop-AzVM `
    -ResourceGroupName $azResourceGroup `
    -Name $azVMName

# After the VM is stopped, get a reference to either the OS or data disk attached to the VM with the Get-AzDisk cmdlet.

#  The following example selects the VM's first data disk.
      $disk= Get-AzDisk `
        -ResourceGroupName $azResourceGroup `
        -DiskName $vm.StorageProfile.DataDisks[0].Name

# Now that you have a reference to the disk, set the size of the disk to 250 GiB.
   $disk.DiskSizeGB = 250

# Next, update the disk image with the Update-AzDisk cmdlet.
   Update-AzDisk `
    -ResourceGroupName $azResourceGroup `
    -Disk $disk -DiskName $disk.Name   

# Finally, restart the VM with the Start-AzVM cmdlet.
   Start-AzVM `
    -ResourceGroupName $azResourceGroup `
    -Name $azVMName
   
# Expand the disk volume in the OS
# Before you can take advantage of the new disk size, you need to expand the volume within the OS.
# RDP in to machine and open windows powershell and run below command
   $driveLetter = "[Drive Letter]" 
   $size = (Get-PartitionSupportedSize -DriveLetter $driveLetter) 
   Resize-Partition `
      -DriveLetter $driveLetter `
      -Size $size.SizeMax

# Upgrade a disk
# There are several ways to respond to changes in your organization's workloads. 
# For example, you may choose to upgrade a standard HDD to a premium SSD to handle increased demand.

# Select the VM that contains the disk that you'll upgrade with the Get-AzVM cmdlet.
$vm = Get-AzVM `
   -ResourceGroupName $azResourceGroup `
   -Name $azVMName

# Before you can upgrade a VM's disk, you must stop the VM. 
   Stop-AzVM `
    -ResourceGroupName $azResourceGroup `
    -Name $azVMName

# After the VM is stopped, get a reference to either the OS or data disk attached to the VM 
     $disk= Get-AzDisk `
        -ResourceGroupName $azResourceGroup `
        -DiskName $vm.StorageProfile.DataDisks[0].Name   

# Now that you have a reference to the disk, set the disk's SKU to Premium_LRS.
   $disk.Sku = [Microsoft.Azure.Management.Compute.Models.DiskSku]::new('Premium_LRS')

# Next, update the disk image with the Update-AzDisk cmdlet.
   Update-AzDisk `
    -ResourceGroupName $azResourceGroup `
    -Disk $disk -DiskName $disk.Name

# The disk image is updated. Use the following example code to validate that the disk's SKU has been upgraded.
    $disk.Sku.Name

# Finally, restart the VM with the Start-AzVM cmdlet.
   Start-AzVM `
    -ResourceGroupName $azResourceGroup `
    -Name $azVMName

# Detach a data disk
# First, select the VM to which the disk is attached
$vm = Get-AzVM `
   -ResourceGroupName $azResourceGroup `
   -Name $azVMName

# Next, detach the disk from the VM
   Remove-AzVMDataDisk `
    -VM $vm `
    -Name $azDataDiskName

# Update the state of the VM 
   Update-AzVM `
    -ResourceGroupName $azResourceGroup `
    -VM $vm

# Delete a data disk
# Get all disks in resource group $azResourceGroup
$allDisks = Get-AzDisk -ResourceGroupName $azResourceGroup

# Determine the number of disks in the collection
if($allDisks.Count -ne 0) {

    Write-Host "Found $($allDisks.Count) disks."

    # Iterate through the collection
    foreach ($disk in $allDisks) {

        # Use the disk's "ManagedBy" property to determine if it is unattached
        if($disk.ManagedBy -eq $null) {

            # Confirm that the disk can be deleted
            Write-Host "Deleting unattached disk $($disk.Name)."
            $confirm = Read-Host "Continue? (Y/N)"
            if ($confirm.ToUpper() -ne 'Y') { break }
            else {

                # Delete the disk
                $disk | Remove-AzDisk -Force 
                Write-Host "Unattached disk $($disk.Name) deleted."
            }
        }
    }
}

# Clean up resources
Remove-AzResourceGroup -Name $azResourceGroup
















