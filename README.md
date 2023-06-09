# Reverse PowerShell

This script allows you to establish a reverse PowerShell session with a target machine. It was created by Mistkeithy and should be used for educational and research purposes only.

## Usage

1. Update the `$hostIP` variable with the IP address of the machine running the listener (e.g. `127.0.0.1`).
2. Update the `$port` variable with the port number that the listener is using (e.g. `4442`).
3. Save the script as a PowerShell file (e.g. `reverse_powershell.ps1`).
4. Start a listener on the machine with the IP address specified in step 1 using the command `ncat -lvp <port>` (e.g. `ncat -lvp 4442`).
5. Run the script on the target machine by opening a PowerShell prompt and running `.\reverse_powershell.ps1`.
6. The script will continuously attempt to establish a connection with the listener. Once a connection is established, you able to type any commands. The script also designed to work correctly in Linux PowerShell (Debian 11).

## Commands

The following commands can be used within the reverse PowerShell session:

- Any valid PowerShell command can be executed.
- `exit`: Closes the connection and terminates the script.
- `upload <filename>`: Uploads a file to the target machine. The file must be in binary format and should be uploaded as a separate command after `upload <filename>`. The file will be saved in the same directory where the script is running. Example: `upload test.txt` followed by the binary data of the file.

## Daemonizing in Linux

To keep the reverse PowerShell script running in the background and automatically start on system boot, you can daemonize it in Linux. Here are the steps:

1. Create a new file in the `/etc/systemd/system/` directory with a `.service` extension (e.g. `reverse_powershell.service`).
2. Enter the following text into the file:

```
[Unit]
Description=Reverse PowerShell script

[Service]
Type=simple
ExecStart=/usr/bin/pwsh -Command /path/to/reverse_powershell.ps1
Restart=always
RestartSec=18000

[Install]
WantedBy=multi-user.target
```

3. Replace `/path/to/reverse_powershell.ps1` with the actual file path of the reverse PowerShell script.
4. Save and close the file.
5. Run the command `sudo systemctl daemon-reload` to reload the systemd manager configuration.
6. Run the command `sudo systemctl start reverse_powershell.service` to start the service.
7. Run the command `sudo systemctl enable reverse_powershell.service` to enable the service to automatically start on system boot.

The reverse PowerShell script is now daemonized and will run in the background.

## Disclaimer

The author of this script is not responsible for any actions taken by individuals who use this script for malicious purposes. This script is intended for educational and research purposes only. Use at your own risk.
