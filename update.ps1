$datesFile = "./.dates"
$l = Get-ChildItem obj/*.c,obj/*.h,Makefile

if(-not (Test-Path $datesFile))
{
    echo "No previous saved dates, copying all files."
    foreach($file in $l)
    {
        pscp $file root@192.168.6.2:/home/paul/src/oled/obj
    }        
}
else 
{
    $i = Import-Csv -Path $datesFile

    foreach($file in $l)
    {
        $olddatestring = ($i | Where-Object { $_.Name -eq $file.Name}).LastWriteTime

        if($olddatestring)
        {
            $olddate = [datetime]$olddatestring
            $curdate = [datetime][string]$file.LastWriteTime
    
            if($curdate -gt $olddate)
            {
                echo "$($file.Name) has date $curdate newer than $olddate"
                pscp $file root@192.168.6.2:/home/paul/src/oled/obj  
            }
        }	
	else
	{
                echo "$($file.Name) is a new file"
                pscp $file root@192.168.6.2:/home/paul/src/oled/obj    	
	}
    }
}

$l | Select-Object -Property Name,LastWriteTime | Export-Csv -Path $datesFile

