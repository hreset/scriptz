 # Use: bounty_test \\someNetworkPath [-log logname.log] [-sec secondsBetween]
 # henson.reset@gmail.com

 # Attaches specified network drive to first available drive letter
 # and tests connection every specified number of seconds.
 
 [CmdletBinding()]
 param([Parameter(Mandatory=$true)][string]$netPath,
       [string]$logName = "bountlog.txt",
       [string]$seconds = 300)

 # Number of seconds to wait between attempts
 $seconds = 5

 # Drive letter of temporary network mapping
 $driveLetter = "NOTASSIGNED"
 
 Write-Host "Beginning connection test to $netPath"
 Write-Host "Press Ctrl + C to exit."
 while ($true) { 

  Start-Sleep -s $seconds
  if ($driveLetter -ne "NOTASSIGNED") {
    net use $driveLetter /delete /yes 
  }
  
  #Try Connecting
  $date = Get-Date
  $connect  = (net use * $netPath)
  $lastExit = $LASTEXITCODE
  $matches  = ($connect | Select-String "Drive\s(.+?)\sis").Matches

  if (($lastExit -eq 0) -and ($matches.Groups.Count -gt 1)) { 
    # If successfull
    $driveLetter = $matches.Groups[1].Value
    echo "$date - Connected Successfully. ($driveLetter)" >> $logName
  } else { 
    # If not successful
    echo "$date - Could not connect." >> $logName
  } 

} 