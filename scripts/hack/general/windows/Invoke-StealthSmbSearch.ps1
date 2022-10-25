<#
.SYNOPSIS
Enumerate smb shares.

.EXAMPLE
Invoke-StealthSmbSearch -hostfile <file>.txt

#>
Function Invoke-StealthSmbSearch
{
    Param
    (
        [Parameter(ParameterSetName='hostfile', Mandatory=$true)][string]$hostfile=""
    )

    foreach($currentHost in Get-Content $hostfile)
    {
        net view \\$currentHost /all 2>&1 | Out-File -Append net-results.txt
        Start-Sleep -s $(Get-Random -Minimum 60 -Maximum 180)
    }
}

