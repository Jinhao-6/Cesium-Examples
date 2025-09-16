# 修复decoded_index_final.html中的全角符号问题

# 文件路径
$filePath = "f:\sjh\codeDemo\Cesium-Examples\decoded_index_final.html"
$backupPath = "f:\sjh\codeDemo\Cesium-Examples\decoded_index_final_backup.html"

# 创建备份
Copy-Item -Path $filePath -Destination $backupPath

# 读取文件内容
$content = Get-Content -Path $filePath -Encoding UTF8 -Raw

# 替换全角加号为半角加号
$fixedContent = $content -replace ' ', '+'

# 保存修复后的内容
Set-Content -Path $filePath -Value $fixedContent -Encoding UTF8

Write-Host "全角加号修复完成！已创建备份文件 $backupPath"