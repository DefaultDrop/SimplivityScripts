<#

.SYNOPSIS
This script outputs a list of failed backups and backup count by VM

.DESCRIPTION
Params:

    -VaIP       -IP of the Simplivity OVC or MVA

.EXAMPLE
./Get-SvtBackupList.ps1 -VaIP "192.168.1.1" | Display the backups on screen

.NOTES
Author: Shay Hosking

.LINK
https://github.com/DefaultDrop/SimplivityScripts

#>

Param(
    [Parameter(Mandatory = $true)]
    [string]$VaIP
)

# Connect to Simplivity
.\New-SvtConnection.ps1 -VaIP $VaIP

# Get the list of failed backups for the last 24 hours
try{
    Write-Host "Looking for Failed Backups"
    $BackupsFailed = Get-SvtBackup -BackupState FAILED -ErrorAction Stop | Group-Object VmName | Select-Object Count, Name | Out-String
    Write-Host "Found Failed Backups" -ForegroundColor Red
    #Write-Output $BackupsFailed
}
catch {
    $BackupsFailed = $_.Exception.Message
    #Write-Output "Failed Backups: $_"
}

# Get the count of backups by VM for the last 24 hours
try {
    Write-Host "Looking for successful backups"
    $BackupCount = Get-SvtBackup -ErrorAction Stop | Group-Object VmName | Select-Object Count, Name | Out-String
    #$BackupCount = Get-SvtBackup -ErrorAction Stop | Group-Object VmName | Select-Object {Count+"<br />"}, {@Name+"<br />"}
    Write-Host "Count of backups by VM"
    #Write-Output $BackupCount
}
catch {
    Write-Host "Error generating successul backup list" -ForegroundColor Red
    $BackupCount = $_.Exception.Message
    #Write-Output $BackupCount -ForegroundColor Red
}

Write-Output "<b>Failed Backups:</b> $BackupsFailed<br /><b>Backup Count</b><br />$BackupCount"