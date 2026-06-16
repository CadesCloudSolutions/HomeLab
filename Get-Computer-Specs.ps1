$cs  = Get-CimInstance Win32_ComputerSystem
$bios= Get-CimInstance Win32_BIOS
$cpu = Get-CimInstance Win32_Processor
$os  = Get-CimInstance Win32_OperatingSystem
$ram = Get-CimInstance Win32_PhysicalMemory
$gpu = Get-CimInstance Win32_VideoController
$disk= Get-CimInstance Win32_DiskDrive

[PSCustomObject]@{
  Manufacturer = $cs.Manufacturer
  Model        = $cs.Model
  SystemType   = $cs.SystemFamily
  SerialNumber = $bios.SerialNumber
  CPU          = "$($cpu.Name.Trim())  ($($cpu.NumberOfCores)C/$($cpu.NumberOfLogicalProcessors)T)"
  RAM_Total_GB = [math]::Round($cs.TotalPhysicalMemory/1GB,0)
  RAM_Modules  = ($ram | ForEach-Object { "$([math]::Round($_.Capacity/1GB,0))GB@$($_.Speed)MHz" }) -join ", "
  GPU          = ($gpu.Name -join ", ")
  OS           = "$($os.Caption) $($os.Version) (Build $($os.BuildNumber))"
} | Format-List

"`n--- Disks ---"
$disk | Select-Object Model, @{n='Size_GB';e={[math]::Round($_.Size/1GB,0)}}, InterfaceType | Format-Table -AutoSize