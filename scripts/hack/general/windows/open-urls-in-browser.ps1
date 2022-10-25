$counter=0                                    

foreach($line in Get-Content urls.txt)
{
    start Microsoft-edge:"http://"$line":80"
    start Microsoft-edge:"https://"$line":443"
    $counter = $counter + 1
    Start-Sleep 5

    if ($counter -eq 4)
    {
        $counter=0
        pause "Press any key to continue"
    }
}

