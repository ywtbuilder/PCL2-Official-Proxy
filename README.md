# PCL2 Official Proxy

PCL2 Official Proxy is a personal, non-commercial derivative of the open-source [PCL launcher](https://github.com/Meloong-Git/PCL). It is maintained by [ywtbuilder](https://github.com/ywtbuilder).

This is a third-party application. It is not an official PCL distribution and is not affiliated with or endorsed by Mojang or Microsoft. In the application name, “Official Proxy” refers to its preference for official game download sources and support for a locally configured HTTP proxy.

## Purpose

- Prefer official game download sources while retaining the original mirror options.
- Support a user-configured local HTTP proxy.
- Authenticate Microsoft accounts and obtain the player's licensed Java Edition profile before launching the game.

## Authentication and game ownership

The application uses Microsoft's device code flow. The user signs in on Microsoft's website; the launcher does not ask for the Microsoft account password.

After Microsoft account authentication, the launcher exchanges Xbox user and XSTS credentials with Minecraft services. Before continuing to game launch, it requests the official Java Edition entitlement and the current player profile.

- The entitlement response must contain `game_minecraft` or `product_minecraft`.
- Unrelated entitlements, including a Bedrock-only entitlement, do not grant Java Edition launch access.
- Reusing an unexpired access token still requires fresh entitlement and profile requests.
- Failed authentication, entitlement checks, or profile requests stop the launch flow.
- Offline and third-party account modes are not accepted by the launch flow and are not offered in the launch or instance settings pages.
- Exporting a launch script uses the same authentication and ownership checks.
- Server configuration does not disable these requirements.
- HTTPS requests use the default .NET certificate validation. The former certificate-error bypass setting has been removed.

## API access requested

The application requests access to authenticate with Minecraft services, verify the user's Java Edition entitlement, and retrieve the player's profile. Its flow uses `authentication/login_with_xbox`, `entitlements/license`, and `minecraft/profile` on `api.minecraftservices.com`.

## Implementation and validation status

The implementation is based on PCL 2.14.0.0. The authentication and ownership implementation was built and checked at source revision `4c851daf4fa8959add3278cbe940e4f125642d23`.

The Windows Release build and 11 automated checks passed. The checks cover Java entitlement decisions, rejection of offline and third-party login inputs, and preservation of default HTTPS certificate validation.

Microsoft device code authorization and Xbox authentication succeeded during local integration work. Minecraft services returned `Invalid app registration` for the new application ID. AppID approval is required to complete the live integration. Successful live entitlement verification and a complete game launch have not yet been demonstrated for this application ID.

The derivative source is available in this repository. This page provides application information for the AppID review. The upstream source is linked above.

Original PCL authorship and licensing notices remain in the application and derivative source.

---

## Original upstream README

### Plain Craft Launcher

[![Stars](https://img.shields.io/github/stars/Meloong-Git/PCL?style=flat&logo=data:image/svg%2bxml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZlcnNpb249IjEiIHdpZHRoPSIxNiIgaGVpZ2h0PSIxNiI+PHBhdGggZD0iTTggLjI1YS43NS43NSAwIDAgMSAuNjczLjQxOGwxLjg4MiAzLjgxNSA0LjIxLjYxMmEuNzUuNzUgMCAwIDEgLjQxNiAxLjI3OWwtMy4wNDYgMi45Ny43MTkgNC4xOTJhLjc1MS43NTEgMCAwIDEtMS4wODguNzkxTDggMTIuMzQ3bC0zLjc2NiAxLjk4YS43NS43NSAwIDAgMS0xLjA4OC0uNzlsLjcyLTQuMTk0TC44MTggNi4zNzRhLjc1Ljc1IDAgMCAxIC40MTYtMS4yOGw0LjIxLS42MTFMNy4zMjcuNjY4QS43NS43NSAwIDAgMSA4IC4yNVoiIGZpbGw9IiNlYWM1NGYiLz48L3N2Zz4=&logoSize=auto&label=Stars&labelColor=444444&color=eac54f)](https://github.com/Meloong-Git/PCL/)
[![Issues](https://img.shields.io/github/issues/Meloong-Git/PCL?style=flat&label=Issues&labelColor=444444&color=1F883D)](https://github.com/Meloong-Git/PCL/issues)
[![哔哩哔哩](https://img.shields.io/badge/动态-BiliBili-00A4DB?style=flat&labelColor=444444&logoSize=auto)](https://space.bilibili.com/11343203/dynamic)
[![爱发电](https://img.shields.io/badge/赞助-爱发电-946ce6?style=flat&labelColor=444444&logoSize=auto)](https://meloong.com/afd/a/LTCat)

包含 PCL 的大部分源代码，包括 UI 库、动画模块、下载模块、Minecraft 启动模块等！<br/>
代码并不是实时更新的，它会在每次 PCL 发布更新时同步一次。<br/>
非常感谢社区的大力支持！

<br/>

### 相关资源
- [PCL 下载](https://meloong.com/pcl)：下载可免费使用的正式版 PCL！
- [PCL 功能投票](https://github.com/Meloong-Git/PCL/discussions/2)：来参加投票吧，开发者会优先处理票数较高的项目！
- [帮助文档库](https://github.com/LTCatt/PCL2Help)：PCL 内置帮助文档的存储库
