#Requires -Modules VagrantVM, VagrantMessages

param(
    [parameter (Mandatory = $true)]
    [string] $VMConfigFile,
    [parameter (Mandatory = $true)]
    [string] $DestinationDirectory,
    [parameter (Mandatory = $true)]
    [string] $DataPath,
    [parameter (Mandatory = $true)]
    [string] $SourcePath,
    [parameter (Mandatory = $false)]
    [switch] $LinkedClone,
    [parameter (Mandatory = $false)]
    [string] $VMName = $null
)

$ErrorActionPreference = "Stop"

try {
    if ($LinkedClone) {
        $linked = $true
    }
    else {
        $linked = $false
    }

    $VM = New-VagrantVM -VMConfigFile $VMConfigFile -DestinationDirectory $DestinationDirectory `
        -DataPath $DataPath -LinkedClone $linked -VMName $VMName

    $Result = @{
        id = $VM.Id.Guid;
    }
    Write-OutputMessage (ConvertTo-Json $Result)
}
catch {
    Write-ErrorMessage "${PSItem}"
    exit 1
}
