
# Sign in to your Azure subscription
Connect-AzAccount

# list the available locations.
Get-AzLocation | Select-Object -Property Location

# Create a resource group
$Location = 'eastus'
$ResourceGroup = 'MyResourceGroup'
New-AzResourceGroup -Name $ResourceGroup -Location $Location

# Create a storage account
# get the storage account context that defines the storage account you want to use. 
# When acting on a storage account, reference the context instead of repeatedly passing in the credentials. 
$StorageHT = @{
    ResourceGroupName = $ResourceGroup
    Name              = 'mystorageaccount108'
    SkuName           = 'Standard_LRS'
    Location          =  $Location
  }
  $StorageAccount = New-AzStorageAccount @StorageHT
  $Context = $StorageAccount.Context

  # Create a container
  $ContainerName = 'quickstartblobs'
  New-AzStorageContainer -Name $ContainerName -Context $Context -Permission Blob



  # Upload blobs to the container

  # upload a file to the default account (inferred) access tier
$Blob1HT = @{
    File             = 'C:\OnlineCourses\AZ104\PPT and Demo Resources\TestImages\az900.png'
    Container        = $ContainerName
    Blob             = "Image001.jpg"
    Context          = $Context
    StandardBlobTier = 'Hot'
  }
  Set-AzStorageBlobContent @Blob1HT
    
   # upload another file to the Cool access tier
   $Blob2HT = @{
    File             = 'C:\OnlineCourses\AZ104\PPT and Demo Resources\TestImages\image1.png'
    Container        = $ContainerName
    Blob             = 'Image002.png'
    Context          = $Context
    StandardBlobTier = 'Cool'
   }
   Set-AzStorageBlobContent @Blob2HT
    
  # upload a file to a folder to the Archive access tier
  $Blob3HT = @{
    File             = 'C:\OnlineCourses\AZ104\PPT and Demo Resources\TestImages\image2.png'
    Container        = $ContainerName
    Blob             = 'FolderName/Image003.jpg'
    Context          = $Context
    StandardBlobTier = 'Archive'
  }
  Set-AzStorageBlobContent @Blob3HT


  # List the blobs in a container
  Get-AzStorageBlob -Container $ContainerName -Context $Context |
  Select-Object -Property Name


  # retrieve the first storage account key and display it 
$storageAccountKey = (Get-AzStorageAccountKey -ResourceGroupName $ResourceGroup -Name mystorageaccount108).Value[0]

Write-Host "storage account key 1 = " $storageAccountKey

# re-generate the key
New-AzStorageAccountKey -ResourceGroupName $resourceGroup `
    -Name mystorageaccount108 `
    -KeyName key1

# retrieve it again and display it 
$storageAccountKey = (Get-AzStorageAccountKey -ResourceGroupName $resourceGroup -Name mystorageaccount108).Value[0]
Write-Host "storage account key 1 = " $storageAccountKey


  # Clean up resources
  Remove-AzResourceGroup -Name $ResourceGroup