# Define the path to check
$filePath = 'C:\IT\Background.png'
$customFieldName = "BackgroundOnMachine"

# Check if the file exists
if (Test-Path $filePath) {
    Write-Output "File exists: $filePath"

    # Set a custom field in NinjaOne
    # Replace 'CustomFieldName' with the actual name or ID of your custom field

    $customFieldValue = "True"

    # NinjaOne uses environment variables or API calls to set custom fields
    # Here's a placeholder for setting the field via NinjaOne's scripting environment
    Write-Output "Setting custom field '$customFieldName' to '$customFieldValue'"
    # NinjaOne-specific command goes here, e.g.:
    # Set-CustomField -Name $customFieldName -Value $customFieldValue
    # Set the custom field in NinjaOne
  Ninja-Property-Set $customFieldName $customFieldValue

} else {
    Write-Output "File not found: $filePath"
    $customFieldValue = "False"
    Ninja-Property-Set $customFieldName $customFieldValue
}
