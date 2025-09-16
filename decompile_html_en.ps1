# Define HTML file path
$htmlFilePath = "f:\sjh\codeDemo\Cesium-Examples\examples\cesiumEx\templates\1_uav\index.html"

# Check if file exists
if (-Not (Test-Path -Path $htmlFilePath)) {
    Write-Host "Error: File $htmlFilePath does not exist"
    exit 1
}

# Get basic file information
$fileInfo = Get-Item -Path $htmlFilePath
Write-Host "File Information:
- Path: $($fileInfo.FullName)
- Size: $($fileInfo.Length) bytes
- Creation Time: $($fileInfo.CreationTime)
- Last Modified: $($fileInfo.LastWriteTime)\n"

# Try to read the file and detect URL encoding
Write-Host "Checking for URL encoding..."

try {
    # Read the file with UTF8 encoding
    $content = Get-Content -Path $htmlFilePath -Raw -Encoding UTF8
    
    # Check if content contains URL encoded parts
    if ($content -match '%[0-9A-Fa-f]{2}') {
        Write-Host "URL encoded content detected. Trying to decode..."
        
        # Create a temporary decoded file
        $tempDecodedFile = "$PSScriptRoot\decoded_index.html"
        
        try {
            # Try to decode the URL encoded content
            $decodedContent = [System.Uri]::UnescapeDataString($content)
            
            # Save decoded content to file
            $decodedContent | Out-File -FilePath $tempDecodedFile -Encoding UTF8
            Write-Host "Decoded content saved to: $tempDecodedFile"
            
            # Show preview of decoded content
            Write-Host "\nDecoded Content Preview (first 1000 chars):\n"
            $previewLength = [Math]::Min($decodedContent.Length, 1000)
            $decodedContent.Substring(0, $previewLength)
            
            # Basic HTML structure analysis
            Write-Host "\nHTML Structure Analysis:\n"
            if ($decodedContent -match '<!DOCTYPE\s+html') { Write-Host "- Found HTML5 DOCTYPE declaration" }
            if ($decodedContent -match '<html') { Write-Host "- Found HTML root element" }
            if ($decodedContent -match '<head') { Write-Host "- Found HEAD section" }
            if ($decodedContent -match '<body') { Write-Host "- Found BODY section" }
            
            # Count script and style tags
            $scriptCount = ([regex]::Matches($decodedContent, '<script')).Count
            $styleCount = ([regex]::Matches($decodedContent, '<style')).Count
            Write-Host "- Contains $scriptCount script tags and $styleCount style tags"
            
            # Check for Cesium related code
            if ($decodedContent -match 'Cesium') { Write-Host "- Detected Cesium related code" }
            
        } catch {
            Write-Host "Error during URL decoding: $_"
        }
        
    } else {
        # If not URL encoded, show raw content preview
        Write-Host "\nRaw Content Preview (first 1000 chars):\n"
        $previewLength = [Math]::Min($content.Length, 1000)
        $content.Substring(0, $previewLength)
    }
    
} catch {
    Write-Host "Error reading file: $_"
    exit 1
}

Write-Host "\nHTML file decompilation analysis completed!"