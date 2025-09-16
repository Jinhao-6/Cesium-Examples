# 设置输出编码为UTF8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# 读取文件内容
$fileContent = Get-Content -Path 'f:\sjh\codeDemo\Cesium-Examples\decoded_index.html' -Raw -Encoding UTF8

# 查找所有URL编码的中文内容并解码 (%uXXXX格式)
$pattern = '%u([0-9A-Fa-f]{4})'
$fileContent = [regex]::Replace($fileContent, $pattern, {
    param($match)
    $hexValue = $match.Groups[1].Value
    $charCode = [Convert]::ToInt32($hexValue, 16)
    [char]$charCode
})

# 处理标准URL编码字符 (%XX格式)，不依赖System.Web
$fileContent = [regex]::Replace($fileContent, '%([0-9A-Fa-f]{2})', {
    param($match)
    $byteValue = [Convert]::ToByte($match.Groups[1].Value, 16)
    [char]$byteValue
})

# 保存解码后的内容
$fileContent | Set-Content -Path 'f:\sjh\codeDemo\Cesium-Examples\decoded_index_final.html' -Encoding UTF8

Write-Host "解码完成，结果已保存到 decoded_index_final.html"