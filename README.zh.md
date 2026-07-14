[Português](README.md) | [English](README.en.md) | [Français](README.fr.md) | [Español](README.es.md) | [简体中文](README.zh.md) | [日本語](README.ja.md)

# Cloudflare DNS Manager

用于通过 Cloudflare API 管理 DNS 记录的 Flutter 应用程序。

本 README 包含所有平台的通用信息。有关构建命令、测试和平台专属说明，请参阅 [Android](README-Android.md)、[Linux](README-Linux.md) 和 [Windows](README-Windows.md) 指南。

## 功能

- 本地密码认证，以及受支持平台上的生物识别登录。
- 关闭并重新打开应用后自动注销。
- 可配置的域名列表和 DNS 记录编辑器。
- Cloudflare 代理开关、CDN 缓存清除和 API 令牌验证。
- 浅色、深色或系统主题；支持葡萄牙语、英语、法语、西班牙语、简体中文和日语。
- 应用内本地化版本历史。

## 访问与安全

首次使用时请创建应用密码。每次新会话都需要认证。会话只保存在内存中；密码使用带随机盐的 PBKDF2-HMAC-SHA256 哈希保存到平台安全存储中。Cloudflare 令牌也会安全保存。主题和 DNS 设置保存在普通本地偏好设置中。

## Cloudflare API 令牌

1. 登录应用。
2. 打开**设置**。
3. 粘贴您的 [Cloudflare API 令牌](https://dash.cloudflare.com/profile/api-tokens)。
4. 选择**测试**，然后选择**保存**。

要清除 CDN 缓存，请创建具有 **Zone / Cache Purge / Purge** 和 **Zone / DNS / Edit** 权限的自定义令牌。

## 架构

- Flutter / Dart；使用 `shared_preferences` 保存非敏感本地状态。
- 使用 `flutter_secure_storage` 保存机密，`local_auth` 用于生物识别，`http` 和 `url_launcher` 用于通信和外部链接。

## 已知问题

Windows 需要 Microsoft Visual C++ Redistributable 2015–2022。若缺少 DLL，请从 [Microsoft 官方下载页面](https://learn.microsoft.com/zh-cn/cpp/windows/latest-supported-vc-redist) 安装。

## 许可证

MIT
