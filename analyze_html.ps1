# 读取HTML文件内容
$fileContent = Get-Content -Path "f:\sjh\codeDemo\Cesium-Examples\examples\cesiumEx\templates\1_uav\index.html" -Raw

# 分析文件基本信息
Write-Host "文件大小: $($fileContent.Length) 字节"

# 尝试提取前1000个字符查看文件开头
Write-Host "\n文件开头部分:\n"
if ($fileContent.Length -gt 0) {
    $startLength = [Math]::Min($fileContent.Length, 1000)
    $fileContent.Substring(0, $startLength)
}

# 尝试提取后1000个字符查看文件结尾
Write-Host "\n文件结尾部分:\n"
if ($fileContent.Length -gt 1000) {
    $fileContent.Substring($fileContent.Length - 1000, 1000)
}