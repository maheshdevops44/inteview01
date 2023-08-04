# Configure the Microsoft Azure Provider
provider "azurerm" {
    version = "~>1.32.0"
    subscription_id = "36276096-787b-4471-96fb-9264d6a482cb"
    client_id = "6a342074-f6a8-4c7a-9e4e-b1721c8b5445"
    client_secret = "c1hz32yUl0HCKUjGJUS-~nMD3~0-V2mSr9"
    tenant_id = "4fdcb84f-9eae-47c3-873d-ba19697d3b55"
}

# Create a resource group if it doesn't exist
resource "azurerm_resource_group" "myterraformgroup" {
    name     = "myResourceGroup1"
    location = "eastus"

    tags = {
        environment = "Terraform Demo"
    }
}




