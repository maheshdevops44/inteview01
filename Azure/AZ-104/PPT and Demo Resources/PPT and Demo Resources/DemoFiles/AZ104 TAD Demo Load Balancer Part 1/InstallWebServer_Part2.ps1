$config = @{
  "fileUris" = (,"https://storagelb108.blob.core.windows.net/lbscript/InstallWebServer.ps1");
  "commandToExecute" = "powershell -ExecutionPolicy Unrestricted -File InstallWebServer.ps1"
}
 
$set = Get-AzVmss -ResourceGroupName "rg-scaleset-lb" -VMScaleSetName "demo-scaleset02"

$set = Add-AzVmssExtension -VirtualMachineScaleSet $set -Name "customScript" -Publisher "Microsoft.Compute" -Type "CustomScriptExtension" -TypeHandlerVersion 1.9 -Setting $config

Update-AzVmss -ResourceGroupName "rg-scaleset-lb" -Name "demo-scaleset02" -VirtualMachineScaleSet $set