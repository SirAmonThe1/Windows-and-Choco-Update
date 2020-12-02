#Requires -Version 3.0 
#Requires -RunAsAdministrator

<#
.SYNOPSIS 
	Checks for updates on the local machine.
.DESCRIPTION 
	Looks for Windows Updates and software updates via Chocolatey. If a reboot is necessary,
	it will ask to do so.
.NOTES     
	Needs "Windows Update Powershell Module" from https://gallery.technet.microsoft.com/scriptcenter/2d191bcd-3308-4edd-9de2-88dff796b0bc/
	Copy it to C:\Users\USER\Documents\WindowsPowerShell\Modules\PSWindowsUpdate
	
	Also needs installed Chocolatey of course -- https://chocolatey.org
	
	Has to be executed with admin rights. Best is to create a bat-File like this:
	  @echo off
	  powershell.exe -Command "\path\to\do-full-upgrade.ps1"
	and use a shortcut with "execute as admin" enabled
.LINK 
	Benjamin Heil, kontakt@bheil.net
	https://www.bheil.net
#>

Import-Module PSWindowsUpdate

# Windows Update
Write-Host -BackgroundColor Magenta -ForegroundColor White ">>> WINDOWS UPDATE"
Write-Host "Checking for Windows Updates."
Write-Host -ForegroundColor DarkGray "This will take a while ..."
$updates = Get-WUInstall -ListOnly
if ($updates) {
	Write-Host -ForegroundColor Yellow "Updates found:"
    Write-Host ($updates | Format-Table | Out-String)
    $confirmation = Read-Host "Install all? [y/n]"
    if ($confirmation -eq 'y') {
        Get-WUInstall -AcceptAll -IgnoreReboot -Verbose
    }
} else {
    Write-Host -ForegroundColor Green "No Windows Updates available!"
}
Write-Host

# Chocolatey
Write-Host -BackgroundColor Blue -ForegroundColor White ">>> CHOCOLATEY"
Write-Host "Checking for outdated software packages via Chocolatey ..."
$choco = choco outdated
if ($choco -like "*Chocolatey has determined 0 package(s) are outdated*") {
    Write-Host -ForegroundColor Green "No updates available via Chocolatey"
} else {
	Write-Host -ForegroundColor DarkGray ($choco | Format-Table | Out-String)
	Write-Host -ForegroundColor Yellow "Outdated software found."
    $confirmation = Read-Host "Update all with Chocolatey? [y/n]"
    if ($confirmation -eq 'y') {
        cup all -y
		Write-Host -ForegroundColor Yellow "Press any key to continue ..."
		$host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    }
}
Write-Host

# Reboot
Write-Host -BackgroundColor DarkYellow -ForegroundColor White ">>> REBOOT STATUS"
Get-WURebootStatus