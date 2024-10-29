& $PSScriptRoot/activate.ps1

$VIVADO_INSTALL_DIR = "C:\Xilinx\Vivado\2024.1" # Folder than contains bin
$QUARTUS_INSTALL_DIR =  "C:\intelFPGA\23.1std\quartus" # Folder than contains bin64


Write-Output "Vivado dir: $VIVADO_INSTALL_DIR\bin" 
Write-Output "Quartus dir: $QUARTUS_INSTALL_DIR\bin64" 

$env:PATH += ";$VIVADO_INSTALL_DIR\bin;$QUARTUS_INSTALL_DIR\bin64"