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
    [string]$Webhook,

    [Parameter(Mandatory = $true)]
    [string]$Message
)

# Convert $Message to json text
$json = @"
{
    "Text": "$Message",
}
"@

# Post the webhook
Write-Host "Posting Webhook"
Invoke-RestMethod -Method post -ContentType 'Application/Json' -Body $json -Uri $Webhook