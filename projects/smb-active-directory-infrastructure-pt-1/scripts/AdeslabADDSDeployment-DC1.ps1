#
# Windows PowerShell script for AD DS Deployment
# Promotes DC1 to the first domain controller of a new forest, ad.adeslab.com.
#
# Step 1 installs the AD DS role (which provides the ADDSDeployment module).
# Step 2 promotes the server and creates the forest; Install-ADDSForest prompts
# for the DSRM (Safe Mode) password at run time (no secret is stored here).
# The server reboots automatically once promotion completes. Run as Administrator.
#

# Step 1 - install the AD DS role and management tools
Install-WindowsFeature AD-Domain-Services -IncludeManagementTools

# Step 2 - promote to a new forest
Import-Module ADDSDeployment
Install-ADDSForest `
-CreateDnsDelegation:$false `
-DatabasePath "C:\Windows\NTDS" `
-DomainMode "WinThreshold" `
-DomainName "ad.adeslab.com" `
-DomainNetbiosName "AD" `
-ForestMode "WinThreshold" `
-InstallDns:$true `
-LogPath "C:\Windows\NTDS" `
-NoRebootOnCompletion:$false `
-SysvolPath "C:\Windows\SYSVOL" `
-Force:$true
