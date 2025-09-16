# 安全修复decoded_index_final.html中的全角符号问题

# 文件路径
$filePath = "f:\sjh\codeDemo\Cesium-Examples\decoded_index_final.html"
$backupPath = "f:\sjh\codeDemo\Cesium-Examples\decoded_index_final_backup2.html"

# 再次创建备份（安全起见）
Copy-Item -Path $filePath -Destination $backupPath -Force

try {
    # 使用StreamReader读取文件内容，确保正确处理大文件
    $reader = New-Object System.IO.StreamReader($filePath, [System.Text.Encoding]::UTF8)
    $content = $reader.ReadToEnd()
    $reader.Close()
    
    # 确保内容不为空
    if ([string]::IsNullOrEmpty($content)) {
        Write-Host "警告：文件内容为空，无法处理。"
        exit 1
    }
    
    # 替换全角加号为半角加号
    $fixedContent = $content -replace ' ', '+'
    
    # 使用StreamWriter安全地写入文件
    $writer = New-Object System.IO.StreamWriter($filePath, $false, [System.Text.Encoding]::UTF8)
    $writer.Write($fixedContent)
    $writer.Close()
    
    Write-Host "全角加号修复完成！已创建备份文件 $backupPath"
    
    # 验证修复后的文件大小
    $fixedFileInfo = Get-Item $filePath
    Write-Host "修复后的文件大小: $($fixedFileInfo.Length) 字节"
    
    # 显示修复的数量
    $originalCount = ($content | Select-String ' ' -AllMatches).Matches.Count
    $fixedCount = ($fixedContent | Select-String ' ' -AllMatches).Matches.Count
    $fixedNumber = $originalCount - $fixedCount
    Write-Host "成功修复了 $fixedNumber 处全角加号"
} catch {
    Write-Host "错误: $($_.Exception.Message)"
    # 如果出错，恢复原始文件
    Copy-Item -Path $backupPath -Destination $filePath -Force
    Write-Host "已从备份恢复原始文件"
}