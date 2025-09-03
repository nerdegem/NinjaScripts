# Get USB devices
$usbDevices = Get-PnpDevice | Where-Object { $_.InstanceId -like "USB\VID_413C&PID_B06*" }   #(Change for your vendor) 

# Initialize an array to hold the processed device information
$processedDevices = @()

# Process each device
foreach ($device in $usbDevices) {
    $status = $device.Status
    $class = $device.Class
    $friendlyName = $device.FriendlyName
    $instanceId = $device.InstanceId -replace '\\', ','

    # Combine the fields into a single line, separated by commas
    $line = "$status,$class,$friendlyName,$instanceId"
    $processedDevices += $line
}

# Sort the processed devices by the Status column, returning OK first
$sortedDevices = $processedDevices | Sort-Object { $_.Split(',')[0] -eq 'OK' } -Descending

# Join the sorted lines into a single string with each device on a new line
$finalOutput = $sortedDevices -join "`n"

# Set the custom field in NinjaOne
Ninja-Property-Set attacheddockingstation $finalOutput
