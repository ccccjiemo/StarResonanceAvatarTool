# extract.ps1 (支持多 path 选择)
param(
    [string]$ConfigPath
)

$ErrorActionPreference = "Stop"
$OutputEncoding = [System.Text.Encoding]::UTF8

function Pause-Exit {
    Write-Host "`n按任意键退出..." -ForegroundColor Cyan
    $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
    exit
}

# ----- 获取配置文件路径 -----
if (-not $ConfigPath) {
    $ConfigPath = Read-Host "请输入配置文件路径（支持拖拽）"
}
$ConfigPath = $ConfigPath -replace '^"|"$', ''

if (-not (Test-Path $ConfigPath)) {
    Write-Host "[错误] 文件不存在: $ConfigPath" -ForegroundColor Red
    Pause-Exit
}

Write-Host "配置文件: $ConfigPath`n" -ForegroundColor Yellow

# ----- 读取并解析 JSON -----
try {
    $raw = Get-Content -Path $ConfigPath -Raw -Encoding UTF8
    $data = $raw | ConvertFrom-Json
} catch {
    Write-Host "[错误] JSON 解析失败: $($_.Exception.Message)" -ForegroundColor Red
    Pause-Exit
}

# 确保是数组
if ($data -isnot [Array]) {
    $data = @($data)
}

if ($data.Count -eq 0) {
    Write-Host "[错误] JSON 数组为空，没有可处理的数据。" -ForegroundColor Red
    Pause-Exit
}

# ----- 选择要处理的 path（如果有多项）-----
$selectedItem = $null
if ($data.Count -eq 1) {
    $selectedItem = $data[0]
    $displayPath = if ($selectedItem.path) { $selectedItem.path } else { "(未命名路径)" }
    Write-Host "数据仅有一项，自动选择: $displayPath`n" -ForegroundColor Green
} else {
    # 构建选项列表（显示 path，若为空则用索引代替）
    $pathChoices = @()
    foreach ($item in $data) {
        if ($item.path) {
            $pathChoices += $item.path
        } else {
            $pathChoices += "(未命名路径)"
        }
    }

    $index = 0
    $key = $null
    while ($key -ne 13) {
        Clear-Host
        Write-Host "配置文件: $ConfigPath`n" -ForegroundColor Yellow
        Write-Host "检测到多个数据块，请选择要处理的 path (使用方向键 ↑↓ 选择，回车确认):`n"
        for ($i = 0; $i -lt $pathChoices.Count; $i++) {
            if ($i -eq $index) {
                Write-Host ('  > ' + $pathChoices[$i]) -ForegroundColor Green
            } else {
                Write-Host ('    ' + $pathChoices[$i])
            }
        }
        $key = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown').VirtualKeyCode
        if ($key -eq 38) { $index = ($index - 1) % $pathChoices.Count }
        if ($key -eq 40) { $index = ($index + 1) % $pathChoices.Count }
    }
    Write-Host ''
    $selectedItem = $data[$index]
    Write-Host "已选择: $($pathChoices[$index])`n" -ForegroundColor Green
}

# ----- 检查 texture_infos -----
$textures = $selectedItem.texture_infos
if (-not $textures -or $textures.Count -eq 0) {
    Write-Host "[警告] 所选数据块中没有 texture_infos 或为空。" -ForegroundColor Yellow
    Pause-Exit
}

# ----- 区域选择 -----
$regionChoices = @(
    '国服 (输出 config.json)',
    '台服 (输出 config_TW.json)',
    '日服 (输出 config_ASIA.json)',
    '自定义'
)

$index = 0
$key = $null
while ($key -ne 13) {
    Clear-Host
    Write-Host "已选择数据块: " -NoNewline
    Write-Host $(if ($selectedItem.path) { $selectedItem.path } else { "(未命名)" }) -ForegroundColor Cyan
    Write-Host "包含纹理条目: $($textures.Count)`n"
    Write-Host '请选择输出区域 (使用方向键 ↑↓ 选择，回车确认):'
    for ($i = 0; $i -lt $regionChoices.Count; $i++) {
        if ($i -eq $index) {
            Write-Host ('  > ' + $regionChoices[$i]) -ForegroundColor Green
        } else {
            Write-Host ('    ' + $regionChoices[$i])
        }
    }
    $key = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown').VirtualKeyCode
    if ($key -eq 38) { $index = ($index - 1) % $regionChoices.Count }
    if ($key -eq 40) { $index = ($index + 1) % $regionChoices.Count }
}
Write-Host ''

switch ($index) {
    0 { $region = ''; break }
    1 { $region = 'TW'; break }
    2 { $region = 'ASIA'; break }
    3 { $region = Read-Host '请输入自定义 region 代号'; break }
}

# ----- 确定输出文件 -----
$outputFileName = if ($region) { "config_$region.json" } else { "config.json" }
$outputPath = Join-Path -Path $PSScriptRoot -ChildPath $outputFileName

Write-Host "`n正在处理，请稍候..." -ForegroundColor Cyan
Write-Host "输出文件将保存至: $outputPath`n" -ForegroundColor DarkGray

# ----- 过滤和排序 -----
$prefix = 'personalzone_player_bg_'
try {
    $filtered = $textures | Where-Object {
        $_.texture_file_name -match ('^' + [regex]::Escape($prefix) + '\d+$')
    } | ForEach-Object {
        $num = [long]($_.texture_file_name -replace $prefix, '')
        $_ | Add-Member -NotePropertyName '_numSuffix' -NotePropertyValue $num -PassThru
    } | Sort-Object { $_._numSuffix } | ForEach-Object {
        $_.PSObject.Properties.Remove('_numSuffix')
        $_
    }

    if ($filtered.Count -eq 0) {
        Write-Host "[警告] 没有匹配到任何纹理（前缀: $prefix）" -ForegroundColor Yellow
        Pause-Exit
    }

    $filtered | ConvertTo-Json -Depth 10 | Set-Content -Path $outputPath -Encoding UTF8

    Write-Host "`n========================================" -ForegroundColor Green
    Write-Host "  成功写入 $($filtered.Count) 条记录" -ForegroundColor Green
    Write-Host "  文件位置: $outputPath" -ForegroundColor Green
    Write-Host "========================================`n" -ForegroundColor Green
} catch {
    Write-Host "[错误] 处理失败: $($_.Exception.Message)" -ForegroundColor Red
    Pause-Exit
}

Pause-Exit