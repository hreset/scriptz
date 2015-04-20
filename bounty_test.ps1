 # bounty_test \\someNetworkPath [-log log.log] [-sec seconds] [-att attempts]
 # henson.reset@gmail.com

 # Attaches specified network drive to first available drive letter
 # and tests connection every specified number of seconds. If attempts 
 # is not specified, script will run until user terminates.
 
 [CmdletBinding()]
 param([Parameter(Mandatory=$true)][string]$netPath,
       [string]$logName = "bountlog.txt",
       [int]$seconds  = 300,
       [int]$attempts = -1)

 # Drive letter of temporary network mapping
 $driveLetter = "NOTASSIGNED"
 
 # Current attempt number (0-based)
 $numAttempts = 0

 # Successful attempts
 $successAttempts = 0

 Write-Host "Beginning connection test to $netPath"
 Write-Host "Press Ctrl + C to exit."
 try {
     while (($attemps -eq -1) -or ($numAttempts -lt $attempts)) { 

      Start-Sleep -s $seconds

      # Try Connecting
      $date = Get-Date
      $connect  = (net use * $netPath)
      $lastExit = $LASTEXITCODE
      $matches  = ($connect | Select-String "Drive\s(.+?)\sis").Matches

      if (($lastExit -eq 0) -and ($matches.Groups.Count -gt 1)) { 
        # If successfull
        $driveLetter = $matches.Groups[1].Value
        echo "$date - Connected Successfully. ($driveLetter)" >> $logName
        Write-Debug "Connection attempt $numAttempts was successful."
        $successAttempts++
      } else { 
        # If not successful
        echo "$date - Could not connect." >> $logName
        Write-Debug "Connection attempt $numAttempts has failed."
      } 

      if ($driveLetter -ne "NOTASSIGNED") {
        # Yes flag is undocumented
        net use $driveLetter /delete /yes 1> $null
      }
      $numAttempts++
    } 
 } finally {
    Write-Host ("Done. {0} of {1} attemps were successful." -f 
        $successAttempts, $numAttempts)
        
 }