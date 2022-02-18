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
		PowerShell.exe -Command "& {Start-Process PowerShell.exe -ArgumentList '-ExecutionPolicy Bypass -File ""%~dpn0.ps1""' -Verb RunAs}"
#>

# Chocolatey
Write-Host -BackgroundColor Blue -ForegroundColor White "##### --- CHOCOLATEY"
Write-Host
Write-Host -ForegroundColor Red ">>> Checking for outdated software-packages via Chocolatey"
$choco = choco outdated
if ($choco -like "*Chocolatey has determined 0 package(s) are outdated*") {
    Write-Host -ForegroundColor Green ">>> No updates available via Chocolatey"
} else {
	Write-Host -ForegroundColor DarkGray ($choco | Format-Table | Out-String)
	Write-Host -ForegroundColor Magenta ">>> Outdated software found"
    <#$confirmation = Read-Host "Update all with Chocolatey? [y/n]"
    if ($confirmation -eq 'y') {
        cup all -y -r#>
	cup all -y -r
}
Write-Host

# Windows Update
Write-Host -BackgroundColor Magenta -ForegroundColor White "##### --- WINDOWS UPDATE"
Write-Host
Write-Host -ForegroundColor Red ">>> Checking the tool PSWindowsUpdate"
$PS = cup PSWindowsUpdate -y -r
if ($PS -like "*Chocolatey upgraded 0/1 packages*") {
    Write-Host -ForegroundColor Green ">>> Up to date"
}
Write-Host



Write-Host -ForegroundColor Red ">>> Checking for Windows Updates"
Write-Host -ForegroundColor DarkGray "This will take a while ..."

Hide-WindowsUpdate -Title "Lenovo*" -hide -confirm:$false
Hide-WindowsUpdate -Title "Advanced Micro*" -hide -confirm:$false

$updates = Get-WUlist -MicrosoftUpdate

if ($updates) {
	Write-Host -ForegroundColor Magenta ">>> Updates found:"
    Write-Host ($updates | Format-Table | Out-String)

	Install-WindowsUpdate -MicrosoftUpdate -AcceptAll -IgnoreReboot | Format-Table
	}
else {
    Write-Host -ForegroundColor Green ">>> No Windows Updates available!"
}
Write-Host

# Reboot
Write-Host -BackgroundColor Red -ForegroundColor White "##### --- REBOOT STATUS"
Write-Host
Write-Host -ForegroundColor Red ">>> Checking for reboot status"
$Reboot = Get-WURebootStatus
if ($Reboot -like "*localhost: Reboot is not required*") {
    Write-Host -ForegroundColor Green ">>> No reboot required"
} 

# Exit
Write-Host 
Write-Host -ForegroundColor Yellow "Press any key to exit ..."
$host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")