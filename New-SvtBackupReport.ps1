<#

.SYNOPSIS
This script sends a report of Siplivity backups to a Teams Webhook

.DESCRIPTION
Params:
    -VaIP       -IP of the Simplivity OVC or MVA
    -Webhook    -URI of the webhook

.EXAMPLE
New-SvtBackupReport.ps1
    -VaIP 192.168.1.1
    -Webook https://webhook.com/651e54

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
$MessageBody = .\Get-SvtBackupList.ps1 -VaIP $VaIP -Output

# Build the message to be posted
$Message = "<h1>Simplivity Backup Report</h1><br />$MessageBody"
Write-Host "$Message"

# Post the message
.\New-TeamsMsg.ps1 -Webhook $Webhook -Message $Message