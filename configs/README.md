# 配置文件说明
- 配置说明仅针对2.0.0以下版本

## 配置文件选择

- `config.json` - 国服配置
- `config_ASIA.json` - 日服配置
- `config_TW.json` - 中国台湾配置

## 手动下载

由于 GitHub/Gitee 频繁访问可能导致文件下载被限制，如果自动下载失败，请按以下步骤手动配置：

1. 根据你的服务器选择对应的配置文件
2. 下载该配置文件到应用根目录

## 自提取

使用纹理查找工具后，会在temp目录下生成cache.json文件，用于缓存查找结果。可以通过使用仓库提供的脚本文件提取对应的配置文件，详见 [配置提取脚本使用说明](script/README.md)

## 注意事项

- 工具默认访问 Gitee 下载配置文件
- 国外用户请将 `setting.json` 中的 `config_repository_url` 字段删除，以便访问 GitHub
