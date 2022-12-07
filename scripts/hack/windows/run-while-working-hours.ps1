$allComm = @(
'command1'
'command2'
"echo end"
)

while (1) 
{
    if (((Get-Date).DayOfWeek.value__ -ne 6) -and ((Get-Date).DayOfWeek.value__ -ne 7))
    {
        if (([int](Get-Date -Format "HH") -gt 8) -and ([int](Get-Date -Format "HH") -lt 16))
        {
            iex($allComm[0])
            
            if ($allComm.Length -eq 2)
            {
                return 0
            }
            $allComm = $allComm | Select-Object -Skip 1
        }
    }
    Start-Sleep 3600
}

