# WinChoco-PSUpdate
 
#> needs installed Chocolatey of course -- https://chocolatey.org
 
.SYNOPSIS 
	Checks for updates on the local machine.
	
.DESCRIPTION 
	Looks for Windows Updates and software updates via Chocolatey. If a reboot is necessary,
	it will ask to do so.
	
.NOTES     
	Needs "Windows Update Powershell Module" from https://gallery.technet.microsoft.com/scriptcenter/2d191bcd-3308-4edd-9de2-88dff796b0bc/
	The Skript trys to update / install it via chocolatey.
	if this fails:
	Copy the Filder from the ZIP to C:\Users\USER\Documents\WindowsPowerShell\Modules\PSWindowsUpdate
	
	Has to be executed with admin rights. 
	The bat-File is asking for the Admin rights after started

