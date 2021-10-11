<#

.SYNOPSIS


.DESCRIPTION
Params:


.EXAMPLE


.NOTES
Author: Shay Hosking

.LINK
https://github.com/DefaultDrop/SimplivityScripts

#>

Param(
    [Parameter(Mandatory = $true)]
    [string]$VaIP,

    [Parameter()]
    [string]$Webhook
)

# Get the Simplivity Backups
$MessageBody = .\Get-SvtBackupList.ps1 -VaIP $VaIP

$Message = "<h1>Simplivity Backup Report</h1><br />$MessageBody"

Write-Host "$Message"

.\New-TeamsMsg.ps1 -Webhook $Webhook -Message $Message