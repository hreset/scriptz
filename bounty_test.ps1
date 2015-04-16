 # Use: bounty_test \\someNetworkPath
 # henson.reset@gmail.com

 # Attaches specified network drive to Y: (which should not exist!)
 # and tests connection every specified number of seconds.
 
 # Default network path to test
 param([string]$netPath = "\\someNetworkPath")

 # Number of seconds to wait between attempts
 $seconds = 300

 Write-Host "Beginning connection test to $netPath"
 Write-Host "Press Ctrl + C to exit."
 while ($true) { 

  Start-Sleep -s $seconds
  net use /delete y: # Disonnect if connected (may error first run)
  $date = Get-Date
  net use y: $netPath # Try connecting again
  
  if ($LASTEXITCODE -eq 0) { 
    # If successfull
    echo "$date - Connected Successfully." >> bountlog.txt
  } else { 
    # If not successful
    echo "$date - Could not connect." >> bountlog.txt
  } 

} 