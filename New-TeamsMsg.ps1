<#

.SYNOPSIS
This script post a message to Teams via a webhook

.DESCRIPTION
Params:
    -Webhook    -Webhook URI
    -Message    -Message to post


.EXAMPLE
.\New-TeamsMsg.ps1 -Webhook https://webhook.com/651e54 -Message "Test Message"
    Posts the message "Test Message" to the webhook at "https://webhook.com/651e54"

.NOTES
Author: Shay Hosking

.LINK
https://github.com/DefaultDrop/SimplivityScripts

#>

Param(
    [Parameter(Mandatory = $true)]
    [string]$Webhook,

    [Parameter(Mandatory = $true)]
    [string]$Message
)

# Convert $Message to json text
$json = @"
{
    "Text": "<br />$Message",
}
"@

# Post the webhook
Write-Host "Posting Webhook"
Invoke-RestMethod -Method post -ContentType 'Application/Json' -Body $json -Uri $Webhook