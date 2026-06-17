---
name: duanju-fenjing
description: 短剧分镜视频生成流程，涵盖前置条件检查（文件、配置、工作流、ComfyUI 服务）、分镜视频生成（首帧图、短视频提示词、低/高分辨率生成）、短视频合成（TTS、字幕、BGM）、批量生成等完整工作流。
version: 1.0.0
author: songz
tags:
  - 短剧
  - 分镜
  - 视频生成
  - ComfyUI
  - LTX2.3
  - Wan2.2
  - z_image
  - TTS
  - BGM
  - 字幕
inputs:
  - workspace/duanju/<剧名>/参考素材.md
  - workspace/duanju/<剧名>/<集数>_台词.md
  - workspace/duanju/<剧名>/<集数>_脚本.md
  - workspace/duanju/<剧名>/<集数>_分镜.md
  - skill.md（ComfyUI 远程调用配置）
  - comfyui_workflows/*.json（工作流模版）
outputs:
  - workspace/duanju/<剧名>/<集数>_video/<分镜>/*（分镜短视频）
  - workspace/duanju/<剧名>/<集数>_video/*（合成后短视频）
  - workspace/duanju/<剧名>/<剧名>_短视频.md（生成进度）
dependencies:
  - ComfyUI
  - LTX2.3 模型
  - Wan2.2 14B 模型
  - z_image 模型
  - Kokorotts/kokoro-v1_0.pth（TTS）
  - minimax audio 模型（BGM）
---

## 2. 前置条件

### 2.1 短剧文件检查
1. 确认存在 `workspace/duanju/<剧名>/参考素材.md`。
2. 分析 `参考素材.md` 中记录的每集、分镜、人物、场景相关文件是否都存在。
3. 如有缺失，提示用户并由用户确定如何补全文件。

### 2.2 配置文件检查
- `skill.md` 中已配置好 ComfyUI 远程调用参数（API 地址、参数模板等）。

### 2.3 工作流文件检查
确认以下工作流文件均已存在：

| 名称 | 路径 |
|------|------|
| LTX2.3模型 图片生成视频 | `comfyui_workflows/image_video_ltx2_3.json` |
| Wan2.2模型 图片生成视频 | `comfyui_workflows/image_video_wan2_2_14B.json` |
| Wan2.2模型 起始帧到结束帧 | `comfyui_workflows/start_end_video_wan2_2_14B.json` |
| LTX2.3模型 文字生成视频 | `comfyui_workflows/text_video_ltx2_3.json` |
| Wan2.2模型 文字生成视频 | `comfyui_workflows/text_video_wan2_2_14B.json` |
| Wan2.2模型 控制镜头视频生成 | `comfyui_workflows/video_wan2_2_14B_fun_camera.json` |
| z_image模型 图片生成 | `comfyui_workflows/z_image_turbo_text_to_image.json` |

### 2.4 检查 ComfyUI 服务可用性
1. 检测 `skill.md` 中配置的 ComfyUI API 是否可访问，验证服务是否在线。
2. 可访问 → 直接进入 3.1。
3. 不可访问 → 询问用户是否使用脚本打开 Windows（唤醒主机 + SSH 远程启动 ComfyUI）。
4. 用户同意使用脚本：
   1. 执行开机脚本（Wake-on-LAN 等）唤醒 Windows 主机。
   2. 轮询等待 Windows 启动完成，直到可通过 SSH 连接。
   3. SSH 连接成功后，远程执行命令启动 ComfyUI 服务。
   4. 重新检测 ComfyUI API 是否可访问；可访问则继续 3.1，仍不可用则报错。
5. 用户拒绝使用脚本 → 提示用户手动开机 Windows 并启动 ComfyUI 服务后重试。

### 2.5 命名与一致性规范
- **人物一致性**：分镜中重点人物必须通过 `@人物:` 标签引用 `参考素材.md`。
- **场景一致性**：分镜中重点场景必须通过 `@场景:` 标签引用 `参考素材.md`。
- **编号规范**：集数使用两位数字（如 01、02）。
- **台词时间轴**：台词脚本中每条对白/旁白必须标注精确时间戳（起止时间），与对应分镜时长一致，用于短视频、字幕与 TTS 对齐。
- **音轨时长优先**：分镜时长以「台词文本字数 ÷ 参考素材.md 语速」计算出的音轨时长为准，确保 TTS 配音、分镜视频、字幕、BGM 全部按台词时间轴同步。
- **不修改大纲**。

### 2.6 输入文件清单
- `workspace目录/duanju/<剧名>/<集数>_台词.md`：每集带时间戳的台词脚本（用于短视频、字幕与 TTS 对齐）
- `workspace目录/duanju/<剧名>/<集数>_脚本.md`：每集的剧情脚本
- `workspace目录/duanju/<剧名>/<集数>_分镜.md`：每集的分镜脚本

### 2.7 字幕配置检查
1. 检查 `workspace/duanju/<剧名>/参考素材.md` 文件中是否存在字幕、字体、字号等信息。
2. 如没有：
   1. 根据大纲、剧情、分辨率，选择短视频字幕、字体、大小、位置。
   2. 将字幕信息写入 `workspace/duanju/<剧名>/参考素材.md` 文件。

---

## 3. 短剧视频生成

### 3.1 生成进度检查
1. 检查 `workspace/duanju/<剧名>/<剧名>_短视频.md` 中剧集短视频、分镜短视频的生成进度。
2. 提示用户从第 X 集 X 分镜继续生成。
3. 如 `workspace/duanju/<剧名>/<剧名>_短视频.md` 文件不存在，提示用户从第一集开始生成短视频。
4. 如 `workspace/duanju/<剧名>/<剧名>_短视频.md` 没有短视频生成结果，提示用户从第一集开始生成短视频。

### 3.2 分镜视频生成

#### 3.2.1 拆分分镜
- 根据 `workspace/duanju/<剧名>/<集数>_分镜.md` 拆分出分镜数量。
- 每集脚本、每分镜脚本格式及文件参考 `duanju-script.md` 中描述，包含脚本命名、脚本内容。
- 输出目录：`workspace目录/duanju/<剧名>/<集数>_video/<分镜>`。

#### 3.2.2 生成首帧图
1. 根据大纲、剧情、分镜脚本，生成首帧图提示词。
2. 根据提示词，参考 `comfyui_workflows/z_image_turbo_text_to_image.json` 生成临时工作流文件，**不可以修改工作流模版**。修改参考图片（场景、人物等）、提示词。
3. 使用 ComfyUI 生成 3 张首帧图。
4. 提示用户选择首帧图，用户确认后继续后面步骤。

#### 3.2.3 撰写分镜短视频提示词
1. 根据首帧图提示词和分镜脚本，生成分镜短视频提示词。
   - 提示词强调视频同时生成中文字幕。
   - 负向提示词主要是人物细节，如不要穿模、不要异形手、脚。
2. 撰写分镜短视频提示词：
   - 参考大纲、剧情、分镜脚本、分镜首帧图提示词，从首帧图开始动画。
   - 严格参考分镜台词时间。
   - 参考文件：
     - `workspace/duanju/<剧名>/<集数>_脚本.md`
     - `workspace/duanju/<剧名>/<集数>_分镜.md`
     - `workspace/duanju/<剧名>/<集数>_台词.md`
   - 生成分镜短视频提示词，严格根据台词时间卡点。

#### 3.2.4 生成分镜短视频
1. 参考 `comfyui_workflows/image_video_ltx2_3.json`，生成临时工作流文件，**不可以修改工作流模版**。修改参考首帧图、人物素材、场景素材、提示词。
2. 生成低分辨率短视频。
3. 用户查看分镜短视频：
   - 用户可以提出修改意见，修改提示词重新生成。
   - 用户确认后，固定之前短视频生成参数（随机数）生成高分辨率短视频。
4. 保存最终高分辨率分镜短视频。

#### 3.2.5 更新分镜短视频进度
更新 `workspace/duanju/<剧名>/<剧名>_短视频.md`：
- 第 X 集 第 X 分镜 短视频生成完成
- 短视频文件

#### 3.2.6 生成本集全部分镜短视频
按 3.2.1 ～ 3.2.5 步骤生成本集全部分镜短视频。

### 3.3 合成短视频

#### 3.3.1 合成 TTS 音频
1. 使用 `Kokorotts/kokoro-v1_0.pth` 根据台词脚本、`参考素材.md` 中不同人物/旁白音的音色、音速生成 TTS，严格根据台词时间生成。
2. 将 TTS 音频文件和短视频进行合成。

#### 3.3.2 添加字幕
1. 根据 `workspace/duanju/<剧名>/参考素材.md` 文件中字幕、字体、台词脚本，在短视频中添加字幕，严格根据台词时间添加。
2. 提示用户查看合成后短视频，用户确认后继续后面步骤。

#### 3.3.3 生成 BGM
1. 根据大纲、本集脚本剧情、台词时间、重点剧情起始时间、重点剧情结束时间或到本集短视频结束时间，计算 BGM 时长。
2. 根据大纲、本集脚本剧情、台词时间撰写 BGM 提示词。
3. 使用 minimax audio 模型生成 BGM，严格按照 BGM 时长生成。
4. 将 BGM 与短视频合成，严格按照重点剧情起始时间合并 BGM。

#### 3.3.4 用户确认与更新
1. 提示用户查看合成后本集短视频，用户确认后继续后面步骤。
2. 更新 `workspace/duanju/<剧名>/<剧名>_短视频.md`：
   - 第 X 集短视频生成完成
   - 短视频文件

### 3.4 输出文件
- `workspace目录/duanju/<剧名>/<集数>_video/<分镜>/...`：本集各分镜短视频。
- `workspace目录/duanju/<剧名>/<集数>_video/...`：本集合成后的短视频。

### 3.5 批量生成
按 3.1 ～ 3.4 步骤生成每一集短视频。


