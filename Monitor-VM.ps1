$VMName = "VM NAME" 
$PushoverUserKey = ""
$PushoverApiToken = ""

while ($true) {
    $VMState = VBoxManage showvminfo $VMName --machinereadable | Select-String -Pattern 'VMState="running"'
    
    if (-not $VMState) {
        $Body = @{
            token = $PushoverApiToken
            user = $PushoverUserKey
            message = "ATTENTION! $VMName aborted as of $(Get-Date -Format 'F') *CDT*"
        priority = 1
        }

                # Send the request with -Body parameter
        try {
            Invoke-RestMethod -Uri "https://api.pushover.net/1/messages.json" -Method Post -Body $Body -ContentType "application/x-www-form-urlencoded"
        } catch {
            Write-Error "Failed to send Pushover notification: $_"
        }
        
        break

    }

    Start-Sleep -Seconds 10  
}
