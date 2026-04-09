@echo off
setlocal enabledelayedexpansion

:: ========== 检测系统语言 ==========
:: 获取系统 UI 语言代码（如 0804 为简体中文）
for /f "tokens=3" %%a in ('reg query "HKCU\Control Panel\International" /v LocaleName 2^>nul') do set "LangCode=%%a"
if "%LangCode%"=="" set "LangCode=en-US"

:: 判断是否为中文（简体或繁体）
echo %LangCode% | findstr /i "zh" >nul
if errorlevel 1 (
    set "IS_CHINESE=0"
) else (
    set "IS_CHINESE=1"
)

:: ========== 多语言提示文本 ==========
if %IS_CHINESE%==1 (
    set "MSG_TITLE=纹理信息提取器"
    set "MSG_ENTER_PATH=请输入配置文件路径（支持拖拽）: "
    set "MSG_FILE_NOT_FOUND=[错误] 文件不存在: "
    set "MSG_NO_FILE=[错误] 未指定配置文件。"
    set "MSG_PROCESSING=正在处理，请稍候..."
    set "MSG_DONE=处理完成！"
    set "MSG_PRESS_KEY=按任意键退出..."
) else (
    set "MSG_TITLE=Texture Info Extractor"
    set "MSG_ENTER_PATH=Enter config file path (drag & drop supported): "
    set "MSG_FILE_NOT_FOUND=[ERROR] File not found: "
    set "MSG_NO_FILE=[ERROR] No config file specified."
    set "MSG_PROCESSING=Processing, please wait..."
    set "MSG_DONE=Process completed!"
    set "MSG_PRESS_KEY=Press any key to exit..."
)

:: ========== 脚本路径检查 ==========
set "SCRIPT_DIR=%~dp0"
set "PS_SCRIPT=%SCRIPT_DIR%extract.ps1"

if not exist "%PS_SCRIPT%" (
    echo [ERROR] PowerShell script not found: %PS_SCRIPT%
    pause
    exit /b 1
)

:: ========== 主界面 ==========
echo ========================================
echo         %MSG_TITLE%
echo ========================================
echo.

:: 获取配置文件路径
set "CONFIG_FILE=%~1"
if "%CONFIG_FILE%"=="" (
    set /p CONFIG_FILE="%MSG_ENTER_PATH%"
)

set "CONFIG_FILE=%CONFIG_FILE:"=%"
if "%CONFIG_FILE%"=="" (
    echo %MSG_NO_FILE%
    pause
    exit /b 1
)

if not exist "%CONFIG_FILE%" (
    echo %MSG_FILE_NOT_FOUND%%CONFIG_FILE%
    pause
    exit /b 1
)

echo.
echo Config file: %CONFIG_FILE%
echo.

echo %MSG_PROCESSING%

:: 调用 PowerShell 脚本（PowerShell 内部的菜单仍是中文，如有需要也可做多语言版）
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%PS_SCRIPT%" "%CONFIG_FILE%"

echo.
echo %MSG_DONE%
echo %MSG_PRESS_KEY%
pause >nul
exit /b