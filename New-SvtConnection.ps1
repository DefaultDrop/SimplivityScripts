<#

.SYNOPSIS
This script connects to a HPE Simplivity appliance installs the Simplivity powershell module

.DESCRIPTION
Params:

    -VaIP       -IP of the Simplivity OVC or MVA

The script will check for a saved credential in the working directory and if not present,
it will prompt to create the credential. Ensure you run this script manually at least once
to ensure the credential is created.

.EXAMPLE
./New-SVTConnection.ps1 -VaIP "192.168.1.1"

.NOTES
Author: Shay Hosking

.LINK
https://github.com/DefaultDrop/SimplivityScripts

#>

Param(
    [Parameter(Mandatory = $true)]
    [string]$VaIP
)

# Check if Simplivity Module is installed and if not, install it
if (Get-Module -ListAvailable -Name HPESimpliVity) {
    Write-Host "HPESimpliVity module installed OK" -ForegroundColor Green
}
else {
    Write-Host "HPESimpliVity module not installed" -ForegroundColor Yellow
    Write-Host "Installing..." -ForegroundColor Yellow
    try {
        # Set PowerShell Gallery to trusted
        Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
        # Install module with current user to avoid running as admin
        Install-Module -Name HPESimpliVity -Scope CurrentUser -ErrorAction Stop
    }
    catch {
        #If the install fails, write the message to the screen and exit the script
        $ErrorMessage = $_.Exception.Message
        Write-Host "Failed to install the HPESimpliVity module" -ForegroundColor Red
        Write-Host $ErrorMessage -ForegroundColor Red
        Exit
    }   
}

# Import the Simplivity Module
Import-Module HPESimplivity -Force

# Check to see if there's a credential file, if not prompt
if (-not(Test-Path -Path .\cred.xml -PathType Leaf)) {
    try {
        $Cred = Get-Credential -Message "Input your vCenter credentials" -Username 'administrator@vsphere.local' | Export-Clixml .\cred.XML
        Write-Host "Exiting Script after creating credential file, run again to connect" -ForegroundColor Yellow
        Exit
    }
    catch {
        throw $_.Exception.Message
        Exit
    }
}
# If the file already exists, import the credential.
else {
    Write-Host "Found credential file, importing..." -ForegroundColor Green
    $Cred = Import-CLIXML .\cred.XML
}

# Connect to Simplivity
Connect-SVT -VirtualAppliance $VaIP -Credential $Cred