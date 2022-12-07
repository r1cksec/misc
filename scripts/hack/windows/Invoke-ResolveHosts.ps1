<#
.SYNOPSIS
Resolve given hostnames.

.EXAMPLE
Invoke-Invoke-ResolveHosts -hostfile <file>.txt
#>
Function Invoke-ResolveHosts
{
    Param
    (
        [Parameter(ParameterSetName='hostfile', Mandatory=$true)][string]$hostfile=""
    )

    foreach($currentHost in Get-Content $hostfile)
    {
        nslookup $currentHost | Select-String "Name:" >> resolve-results.txt
        Start-Sleep -s $(Get-Random -Minimum 1 -Maximum 3)
    }
}

