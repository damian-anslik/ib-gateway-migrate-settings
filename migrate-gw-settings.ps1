<# 
This script migrates user and gateway settings from one version of the IB Gateway to another. To do so:

1. Navigate to the old gateway directory. The path will be passed in as an argument to the script.
2. Find all of the user settings folders. These consist of a random combination of letters. For example: ccpegejeididahbbhbnmcopknnaafanojcnjchii or abpegejeididahbbhbnmcopknnaafanojcnjchii
3. Copy the user settings folders to the new gateway directory. The path will be passed in as an argument to the script.
4. Copy over the jts.ini file from the old gateway directory to the new gateway directory.
#>

param(
    [Parameter(Mandatory=$true)]
    [string]$oldGatewayPath,
    [Parameter(Mandatory=$true)]
    [string]$newGatewayPath
)

# Get all of the user settings folders, only over a certain number of characters
Write-Host "Getting user settings folders..."
$userSettingsFolders = Get-ChildItem -Path $oldGatewayPath -Directory | Where-Object { $_.Name.Length -gt 20 } | Select-Object -ExpandProperty FullName
Write-Host "Found $($userSettingsFolders.Count) user settings folders."

# Copy the user settings folders to the new gateway directory, overwriting any existing folders
Write-Host "Copying user settings folders to new gateway directory..."
$userSettingsFolders | ForEach-Object {
    Copy-Item -Path $_ -Destination $newGatewayPath -Recurse -Force
}

# Copy over the jts.ini file from the old gateway directory to the new gateway directory
Write-Host "Copying jts.ini file to new gateway directory..."
Copy-Item -Path "$oldGatewayPath\jts.ini" -Destination $newGatewayPath

# Print out done message
Write-Host "Done!"