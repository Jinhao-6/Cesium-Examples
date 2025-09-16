# 定义HTML文件路径
$htmlFilePath = "f:\sjh\codeDemo\Cesium-Examples\examples\cesiumEx\templates\1_uav\index.html"

# 检查文件是否存在
if (-Not (Test-Path -Path $htmlFilePath)) {
    Write-Host "错误: 文件 $htmlFilePath 不存在"
    exit 1
}

# 获取文件基本信息
$fileInfo = Get-Item -Path $htmlFilePath
Write-Host "文件信息:
- 路径: $($fileInfo.FullName)
- 大小: $($fileInfo.Length) 字节
- 创建时间: $($fileInfo.CreationTime)
- 修改时间: $($fileInfo.LastWriteTime)\n"

# 尝试读取文件内容并识别其编码
Write-Host "尝试识别文件编码..."
$encoding = "UTF8"

try {
    # 使用UTF8编码读取文件
    $content = Get-Content -Path $htmlFilePath -Raw -Encoding $encoding
    
    # 检查内容是否可能是URL编码的
    if ($content -match '%[0-9A-Fa-f]{2}') {
        Write-Host "检测到可能是URL编码的内容，尝试解码..."
        
        # 尝试解码URL编码的内容
        $decodedContent = [System.Uri]::UnescapeDataString($content)
        
        # 保存解码后的内容到临时文件
        $tempDecodedFile = "$PSScriptRoot\decoded_index.html"
        $decodedContent | Out-File -FilePath $tempDecodedFile -Encoding $encoding
        Write-Host "已将解码后的内容保存到: $tempDecodedFile"
        
        # 显示解码后内容的前1000个字符
        Write-Host "\n解码后文件开头部分 (前1000字符):\n"
        $previewLength = [Math]::Min($decodedContent.Length, 1000)
        $decodedContent.Substring(0, $previewLength)
        
        # 分析解码后的HTML结构
        Write-Host "\n解码后的HTML结构分析:\n"
        if ($decodedContent -match '<!DOCTYPE\s+html') {
            Write-Host "- 找到标准HTML5文档类型声明"
        }
        
        if ($decodedContent -match '<html') {
            Write-Host "- 找到HTML根元素"
        }
        
        if ($decodedContent -match '<head') {
            Write-Host "- 找到HEAD部分"
        }
        
        if ($decodedContent -match '<body') {
            Write-Host "- 找到BODY部分"
        }
        
        # 计算脚本和样式标签数量
        $scriptCount = ([regex]::Matches($decodedContent, '<script')).Count
        $styleCount = ([regex]::Matches($decodedContent, '<style')).Count
        Write-Host "- 包含 $scriptCount 个script标签和 $styleCount 个style标签"
        
        # 检查是否包含Cesium相关代码
        if ($decodedContent -match 'Cesium') {
            Write-Host "- 检测到Cesium相关代码"
        }
        
    } else {
        # 如果不是URL编码，直接分析原始内容
        Write-Host "\n文件内容预览 (前1000字符):\n"
        $previewLength = [Math]::Min($content.Length, 1000)
        $content.Substring(0, $previewLength)
    }
} catch {
    Write-Host "读取文件时出错: $_"
    exit 1
}

Write-Host "\nHTML文件反编译分析完成!"