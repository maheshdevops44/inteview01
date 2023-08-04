$resourcegroup=read-host "please enter the resourcegroup name"
$location=read-host "please enter the location"
$sroageaccountname=read-host "please nter the storage account name"
New-AzStorageAccount -ResourceGroupName $resourcegroup -AccountName $sroageaccountname -Location $location -SkuName Standard_LRS
write-host $sroageaccountname "is been created sucessfully"