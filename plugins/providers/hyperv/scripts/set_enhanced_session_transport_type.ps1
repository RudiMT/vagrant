#Requires -Modules VagrantMessages

param (
    [parameter (Mandatory=$true)]
    [Guid] $VMID,
    [parameter (Mandatory=$true)]
    [string] $Type
)

$ErrorActionPreference = "Stop"

try {
    $VM = Hyper-V\Get-VM -Id $VMID
} catch {
    Write-ErrorMessage "Failed to locate VM: ${PSItem}"
    exit 1
}

try {
    # HyperV 1.1 (Windows Server 2012R2) crashes on this call.
    $present = Get-Command Set-VM -ParameterName EnhancedSessionTransportType -ErrorAction SilentlyContinue
    if($present) {
        Hyper-V\Set-VM -VM $VM -EnhancedSessionTransportType $Type
    }else{
        Write-Output("This version of HyperV does not support EnhancedSessionTransportType, ignoring.")
    }
} catch {
    Write-ErrorMessage "Failed to assign EnhancedSessionTransportType to ${Type}:${PSItem}"
    exit 1
}
