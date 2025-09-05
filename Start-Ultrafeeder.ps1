# Get IP devices
$ipdevices = usbipd list

# Skip the header line and parse device rows
$busid = $ipdevices |
    Select-Object -Skip 1 |                             # skip header
    Where-Object { $_ -match 'Bulk In, Interface' } |   # find row for the SDR dongle
    ForEach-Object { ($_ -split '\s+')[0] }             # split on whitespace and grab BUSID

# Bind and attach the device to WSL
usbipd bind --busid $busid
usbipd attach --wsl --busid $busid

# Start the ultrafeeder service in WSL
wsl --cd /opt/adsb -e docker compose up -d
