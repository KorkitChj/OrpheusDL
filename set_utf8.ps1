param (
    [string]$folderPath
)

# Check if folderPath is valid
if (-Not (Test-Path $folderPath)) {
    Write-Host "Invalid folder path: $folderPath"
    return
}

# Get folder name
$folderName = Split-Path $folderPath -Leaf
Write-Host "Processing folder: $folderPath, Folder name: $folderName"

# Set M3U playlist path
$playlistPath = Join-Path -Path $folderPath -ChildPath "$folderName.m3u"
Write-Host "Playlist path: $playlistPath"

# Check if M3U file already exists
if (Test-Path $playlistPath) {
    try {
        Remove-Item $playlistPath -Force
        Write-Host "Deleted existing playlist: $playlistPath"
    } catch {
        Write-Host "Failed to remove file: $($_.Exception.Message)"
    }
}

# Get all audio files in the folder
$audioFiles = Get-ChildItem -Path $folderPath -Recurse -Include *.mp3, *.flac, *.wav
Write-Host "Audio files found: $($audioFiles.Count)"

# Check if there are audio files
if ($audioFiles.Count -eq 0) {
    Write-Host "No audio files found in folder: $folderPath"
} else {
    try {
        # Write the list of files to the M3U file (UTF-8)
        $audioFiles | ForEach-Object { $_.FullName } | Out-File -Encoding utf8 $playlistPath
        
        # Check if the playlist was created successfully
        if (Test-Path $playlistPath) {
            Write-Host "Playlist created successfully: $playlistPath"
        } else {
            Write-Host "Failed to create playlist: $playlistPath"
        }
    } catch {
        Write-Host "Error creating playlist: $($_.Exception.Message)"
    }
}
