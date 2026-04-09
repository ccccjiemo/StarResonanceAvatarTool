# 配置提取脚本使用说明

## 使用步骤

1. 将需要提取的 JSON 文件（例如 `cache.json`）**拖拽到 `run_extract.bat` 图标上**。
   - 或者双击 `run_extract.bat`，根据提示输入文件路径。

2. 如果 JSON 中包含多个数据块（多个 `path`），使用 **↑/↓** 方向键选择，按 **Enter** 确认。

3. 选择输出区域：
   - **国服** → 输出 `config.json`
   - **台服** → 输出 `config_TW.json`
   - **日服** → 输出 `config_ASIA.json`
   - **自定义** → 输入代号，输出 `config_代号.json`

4. 等待处理完成，生成的文件位于工具所在文件夹。

## 区域代号

区域代号（region）与游戏程序名后缀相对应，例如：

| 游戏程序名 | 区域代号 | 输出文件 |
|-----------|----------|----------|
| Star（国服） | 无后缀 | `config.json` |
| StarTW | TW | `config_TW.json` |
| StarASIA | ASIA | `config_ASIA.json` |
