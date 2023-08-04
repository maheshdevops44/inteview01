$resourcgroup=read-host "please enter the resourcegroupname"
$location=read-host "please enter the location"
New-AzResourceGroup -Name $resourcgroup -Location $location
write-host "resourcegroup has been created sucessfully"