Install-WindowsFeature -Name Web-Server, Web-Mgmt-Tools
#mkdir C:\Voidu\www.voidu.com

$folder = New-Item  C:\Voidu\www.voidu.com  -ItemType directory
$website = New-Website -Name "www.voidu.com" -HostHeader "www.voidu.com" -Port 80 -PhysicalPath $folder -force

New-WebBinding $website.name -HostHeader "www.voidu.com" -Port 443 -Protocol "https" -SslFlags 1

Start-WebSite -Name "www.voidu.com"

#PowerShellGet requirest NuGet installation.
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force

# ESET File security instalation
Invoke-WebRequest https://download.eset.com/com/eset/apps/business/efs/windows/latest/efsw_nt64.msi -OutFile C:\Users\Administrator\Downloads\efsw_nt64.msi
msiexec /i C:\Users\Administrator\Downloads\efsw_nt64 /qn

# Install AWS CLI
Import-Module AWSPowerShell
# Download ESET Agent file (.bat)
Read-S3Object -BucketName "eset-console-bucket" -Key "ESMCAgentInstaller/ESMCAgentInstaller.bat" -File "C:\Users\Administrator\Desktop\ESMCAgentInstaller.bat"
# Setting configuration files in order to run ESET Management Agent in startup.
#Add-Content -Path 'C:\Users\Administrator\Desktop\eset_startup_script.ps1' -Value 'Start-Process -FilePath "C:\Users\Administrator\Desktop\ESMCAgentInstaller.bat" -Verb runAs'
#Add-Content -Path 'C:\Users\Administrator\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\startup.cmd' -Value 'start /w pkgmgr /iu:IIS-ASP'
#Add-Content -Path 'C:\Users\Administrator\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\startup.cmd' -Value 'PowerShell -Command "Set-ExecutionPolicy Unrestricted" >> "%TEMP%\StartupLog.txt" 2>&1'
#Add-Content -Path 'C:\Users\Administrator\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\startup.cmd' -Value 'PowerShell C:\Users\Administrator\Desktop\script.ps1 >> "%TEMP%\StartupLog.txt" 2>&1'

# Creating Task Scheduler in order to start ESET Management Agent at booting.
$Action = New-ScheduledTaskAction -Execute 'C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe' -Argument "Start-Process -FilePath 'C:\Users\Administrator\Desktop\ESMCAgentInstaller.bat' -Verb runAs"
$Trigger = New-ScheduledTaskTrigger -AtStartup
$Settings = New-ScheduledTaskSettingsSet
$Task = New-ScheduledTask -Action $Action -Trigger $Trigger -Settings $Settings
Register-ScheduledTask -TaskName 'ESET Installition Script' -InputObject $Task -User 'SYSTEM'