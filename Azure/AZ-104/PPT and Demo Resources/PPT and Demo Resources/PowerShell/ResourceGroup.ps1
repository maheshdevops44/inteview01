

# Login in to account
Connect-AzAccount
Connect-AzAccount -Tenant 'b47e8d8c-b842-4a0a-ae11-40f6419a6106'


# List of all Subscriptions
Get-AzSubscription

# Current active Subscriptions
Get-Azcontext

# Connect with perticular subscription for your current session
# Select-AzSubscription is alias of Set-AzContext cmdlet
Select-AzSubscription -Subscription "Pay-As-You-Go"
Set-AzContext -Subscription "Pay-As-You-Go"

# list of all resource groups
Get-AzResourceGroup

Get-AzResourceGroup | Format-Table

Get-AzResourceGroup | select ResourceGroupName, Location

Get-AzResourceGroup | Where-Object{ $_.Location -eq 'westus'}

Get-AzResourceGroup | Where-Object{ $_.Location -eq 'westus'} | select ResourceGroupName, Location

Get-AzResourceGroup | `
Where-Object{ $_.Location -eq 'westus'} | `
select ResourceGroupName, Location


# To create a resource group, use New-AzResourceGroup.
    New-AzResourceGroup -Name rg-exampleGroup -Location westus

    $locationName = "East US" 
    $resrouceGroupName = "rg-exampleGroup-2" 
    New-AzResourceGroup -Name $resrouceGroupName -Location $locationName

# List resource groups
    Get-AzResourceGroup | Format-Table

# Deploy resources
# The following example creates a storage account. The name you provide for the storage account must be unique across Azure.
    New-AzStorageAccount -ResourceGroupName rg-exampleGroup -Name demostorage1008 -Location westus -SkuName "Standard_LRS"

# Lock resource group   
    New-AzResourceLock -LockName LockGroup -LockLevel CanNotDelete -ResourceGroupName rg-exampleGroup

# To get the locks for a resource group, use Get-AzResourceLock.
    Get-AzResourceLock -ResourceGroupName rg-exampleGroup
 
# Delete Lock
    Remove-AzResourceLock -LockName 'LockGroup' -ResourceGroupName rg-exampleGroup
    
# Delete resource groups
    Remove-AzResourceGroup -Name rg-exampleGroup