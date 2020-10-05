az login
$subs = az account list
foreach ($sub in $subs) { 
	az account set --subscription $sub.id
    $vms = Get-AzVM
	foreach ($vm in $vms) { 
		$vmInfo = "" | Select ResourceGroupName,Name,Location,VmSize,OsType,Extension,Publisher,Version
		$exts = az vm extension list --resource-group $vm.ResourceGroupName --vm-name $vm.Name --query '[].{Publisher:publisher,Version:typeHandlerVersion,Extension:virtualMachineExtensionType}' -o json | ConvertFrom-Json    
		foreach ($ext in $exts) {
			$vmInfo.Name = $vm.Name
			$vmInfo.ResourceGroupName = $vm.ResourceGroupName
			$vmInfo.Location = $vm.Location
			$vmInfo.VmSize = $vm.HardwareProfile.VmSize
			$vmInfo.OsType = $vm.StorageProfile.OsDisk.OsType
			$vmInfo.Extension = $ext.Extension
			$vmInfo.Publisher = $ext.Publisher
			$vmInfo.Version = $ext.Version
			$vmInfo
		}
	}
}