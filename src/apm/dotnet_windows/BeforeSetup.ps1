# Allow some time before starting IIS
Start-Sleep -Seconds 5

# Log the restarting message
Write-Output "Restarting IIS service..."

# Restart IIS
Stop-Service -Name 'w3svc' -ErrorAction Stop
Start-Service -Name 'w3svc' -ErrorAction Stop

# Log that IIS has been restarted
Write-Output "IIS service has been restarted."

# Monitor IIS status and ensure it's running and alive
while ($true) {
    try {
        $iisStatus = Get-Service -Name 'w3svc' -ErrorAction Stop
        if ($iisStatus.Status -eq 'Running') {
            Write-Output "IIS is healthy."
        }
        else {
            Write-Output "IIS is not running. Attempting to restart..."
            Start-Service -Name 'w3svc' -ErrorAction Stop
        }
    }
    catch {
        Write-Output "Failed to get IIS status or restart IIS: $_"
    }
    Start-Sleep -Seconds 10
}
