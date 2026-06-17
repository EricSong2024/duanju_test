# =============================================================================
# 头信息（Skill Header / Metadata）
# =============================================================================
# 本文件为「短剧创作助手」skill 的主入口配置（SKILL.md），
# 头信息区集中定义 skill 的基础属性、适用范围、技术依赖与快速使用方式，
# 便于 agent 解析、注册、检索与自动启用。
# =============================================================================

# ---------- 基础标识 ----------
# 显示名（用户可读）
name: 短剧创作助手
# 内部标识符（用于调用、索引、引用）
id: duanju-creation
# 版本号（遵循 semver 规范）
version: 1.0.0
# 分类
category: 创作生成 / AIGC 视频
# 标签（用于检索与触发匹配）
tags:
  - 短剧
  - AIGC
  - 视频生成
  - 分镜
  - 配音
  - 字幕
  - 人物三视图
  - 场景图
  - 图生视频

# ---------- 适用范围 ----------
# 适用提示词（用于触发 skill）
trigger_keywords:
  - 短剧创作
  - 短剧脚本
  - 分镜脚本
  - 场景描述
  - 人物描述
  - 配音提示词
  - AIGC 短剧
  - AI 短剧生成
  - 视频短剧
  - 连续剧集
  - 短剧分镜
  - 人物三视图
  - 场景图生成
  - 首帧图
  - 字幕生成
  - 口型同步
  - BGM 配乐

# 触发场景（自动启用本技能）
trigger_scenarios:
  - 用户要求生成短剧剧情、世界观或剧情大纲
  - 用户要求拆解剧集到每集脚本或分镜脚本
  - 用户要求绘制分镜首帧图、人物三视图或场景图
  - 用户要求生成配音、动画、视频或字幕
  - 用户要求校准口型、合成成片或添加 BGM
  - 用户要求端到端完成一集乃至全集成片制作

# ---------- 运行环境 ----------
# 平台与硬件
platform:
  os:
    - macOS  # 客户端（运行 agent）
    - Windows  # 远端推理后端
  client:
    type: agent-runtime
    host: 本地 macOS
  backend:
    type: comfyui-server
    host: 192.168.0.2
    port: 8188
    api_base: http://192.168.0.2:8188
    hardware:
      cpu: i7 9700k
      ram: 32G
      gpu: RTX 3080 20G 显存

# 前置依赖（必须满足才可正常调用）
prerequisites:
  software:
    - curl
    - ssh
    - ffmpeg          # 视频拼接 / 字幕 / BGM 合成
    - python >= 3.10  # 部分脚本与工具链
  network:
    - 与 192.168.0.2 在同一局域网
    - WOL 广播可达 Windows 主机
  files:
    - script/wol.sh
    - script/winstartcomfyui.sh
    - script/winstopcomfyui.sh
    - comfyui_workflows/*.json
    - references/duanju*.md
  models:
    location: smb://administrator:123456@192.168.0.2/ComfyUI/models
    required:
      - checkpoints/ltx-2.3-22b-dev-fp8.safetensors
      - diffusion_models/z_image_turbo_bf16.safetensors
      - diffusion_models/wan2.2_i2v_*_14B_fp8_scaled.safetensors
      - diffusion_models/wan2.2_t2v_*_14B_fp8_scaled.safetensors
      - diffusion_models/wan2.2_fun_camera_*_14B_fp8_scaled.safetensors
      - diffusion_models/qwen_image_edit_2511_fp8mixed.safetensors
      - Kokorotts/kokoro-v1_0.pth

# ---------- 描述 ----------
description: |
  短剧创作助手（duanju-creation）是一站式 AIGC 短剧全流程创作技能，
  覆盖从剧情构思、世界观搭建，到分镜动画、配音字幕、最终成片输出的完整链路，
  旨在让用户以最低门槛产出可发布的全集 AIGC 短剧。

  【核心能力】
  - 基础信息收集：短剧类型（言情/悬疑/都市/古风/玄幻/家庭/喜剧）、
    形式（穿越/重生/金手指）、集数（默认 75~90 集）、单集时长（默认 90s）、
    分辨率（默认 1080p）、画风（真人/2D 日系/3D 国漫）等关键参数
  - 文本内容生成：整体剧情大纲与世界观设定、每集脚本（对白/旁白/情绪/
    时长）、分镜脚本拆解（镜头号/景别/运镜/画面/对白/音效）
  - 视觉资产生成：重点人物提示词与三面图（正/侧/背）、重点场景提示词
    与场景图、分镜首帧图，全程基于 ComfyUI z-image 等开源模型
  - 视听内容生成：人物声纹与 TTS 配音（Kokoro TTS 体系）、分镜动画
    （LTX2.3 / Wan2.2 图生视频，含首尾帧、控制镜头等多种工作流）
  - 后处理合成：分镜视频拼接成单集成片、字幕合成、口型校准、
    按剧情氛围匹配 BGM，最终交付带 BGM 的全集短剧成片

  【技术栈】
  - 远程 Windows ComfyUI（i7 9700k / 32G / RTX 3080 20G 显存）作为
    统一 AIGC 推理后端，API: http://192.168.0.2:8188
  - 内置 8 个 ComfyUI 参考工作流：文生图、图生视频、文生视频、
    首尾帧视频、控制镜头视频、图片编辑等，覆盖全部生图与生视频需求
  - 严格遵守开源原则：仅使用开源模型，禁止线上付费模型；模型缺失
    时提示用户手动下载，不擅自联网拉取
  - 通过 WOL 网络唤醒 + SSH 启停脚本管理 ComfyUI 服务生命周期

  【典型场景】
  - 从零端到端生成一部完整 AIGC 短剧（剧情→人物→场景→分镜→成片）
  - 仅使用本 skill 中的某一环节能力，例如：批量产出人物三视图、
    生成分镜脚本、生成特定分镜的首帧图或动画
  - 多集连续剧制作：单集流程跑通后，循环复用产出全集
  - 短剧创作前期筹备：先做世界观、人物、场景资产沉淀，再进入拍摄

  【交付物】
  短剧剧情大纲与世界观 + 重点人物提示词/三面图/声纹 + 重点场景提示词/
  场景图 + 每集脚本 + 每集分镜脚本 + 分镜首帧图 + 分镜动画 + TTS 配音 +
  字幕 + 带 BGM 的全集成片。

# ---------- 快速开始（Quickstart）----------
quickstart:
  description: 5 步快速启动一次短剧生产
  steps:
    1:
      name: 唤醒 ComfyUI 后端
      command: script/wol.sh && script/winstartcomfyui.sh
    2:
      name: 与用户确认基础信息
      detail: 短剧类型 / 形式 / 集数 / 单集时长 / 分辨率 / 画风
    3:
      name: 生成分镜脚本
      detail: references/duanju-script.md
    4:
      name: 生成分镜首帧 + 动画 + 配音字幕
      detail: references/duanju-fenjing.md
    5:
      name: 合并为成片并配 BGM
      command: references/duanju-hebing.md

# ---------- 默认参数 ----------
defaults:
  episodes: "75~90 集"
  duration_per_episode: "90s"
  resolution: "1080p"
  style: "模仿真人"
  type_options: [言情, 悬疑, 都市, 古风, 玄幻, 家庭, 喜剧]
  form_options: [穿越, 重生, 金手指]
  style_options: [模仿中国真人, 2D日系动漫风格, 3D国漫风格]

# ---------- 安全与策略 ----------
policies:
  - 仅使用开源模型，禁止线上付费模型
  - 模型缺失时提示用户手动下载，不擅自联网拉取
  - 不在默认工作流文件上直接修改；生成视频时复制到 workspace 形成临时工作流
  - 临时工作流执行成功后立即清理
  - ComfyUI 调用统一使用 curl 提交工作流 API
  - 每一步输出需与用户确认后方可进入下一步

# 目录
toc:
  - 1. 描述（description）
  - 2. 适用提示词（trigger_keywords）
  - 3. 触发场景（trigger_scenarios）
  - 4. 短剧创作全流程工作流（workflow，step 1~17）
  - 5. 分支 skill 说明（references，文件清单）
  - 6. 解释规则（rules）
  - 7. ComfyUI 环境 （comfyui）
  - 8. 工具脚本（scripts）
  - 9. ComfyUI 启动流程（comfyui_startup）
  - 10. 上下文检查（context_check）
  - 11. 短剧基础信息收集（basic_info_collection）
  - 12. 短剧生成（generation）

# 文件清单（skill 目录结构与说明）
files:
  skill_root: /Users/openclaw/.hermes/profiles/skill/
  structure: |
    skill/
    ├── SKILL.md                          # 本文件：skill 主配置、目录、工作流与说明
    ├── references/                       # 分支 skill 目录，按步骤拆分的能力说明
    │   ├── kokoro_voices.md              # TTS音色说明文件
    │   ├── duanju.md                     # 短剧大纲与世界观生成
    │   ├── duanju-character-prompt.md    # 人物提示词 + 三面图（正/侧/背）
    │   ├── duanju-scene-prompt.md        # 重点场景提示词与场景图
    │   ├── duanju-script.md              # 每集脚本 + 分镜脚本拆解
    │   ├── duanju-fenjing.md             # 分镜首帧图、动画、配音、字幕
    │   └── duanju-hebing.md              # 分镜拼接 + 全集成片 + BGM
    └── script/                           # 远程 ComfyUI 控制脚本
    │   ├── wol.sh                        # 网络唤醒 Windows 台式机
    │   ├── winstartcomfyui.sh            # SSH 启动远程 ComfyUI
    │   └── winstopcomfyui.sh             # SSH 关闭远程 ComfyUI
    └── comfyui_workflows/                # comfyui参考工作流目录
        └── *8个工作流文件*                 # 8个comfyui参考工作流文件
  references_detail:
    - path: references/duanju.md
      purpose: 短剧大纲生成
      step_range: "1"
      description: |
        根据用户选择的短剧类型（言情/悬疑/都市/古风/玄幻/家庭/喜剧）与形式
        （穿越/重生/金手指），生成短剧整体剧情大纲与世界观设定。
    - path: references/duanju-character-prompt.md
      purpose: 人物提示词 + 三面图
      step_range: "2, 3, 4"
      model: comfyui/z-image
      description: |
        根据短剧大纲生成重点人物描述提示词（外貌、性格、服饰、年龄、气质、典型动作），
        再基于提示词生成人物三面图（正面/侧面/背面），同时生成对应声纹。
    - path: references/duanju-scene-prompt
      purpose: 场景提示词 + 场景图
      step_range: "5, 6"
      model: comfyui/z-image
      description: |
        根据短剧大纲生成重点场景描述提示词（环境、光线、色调、构图、时代、地域），
        并基于提示词生成重点场景图片。
    - path: references/duanju-script.md
      purpose: 集脚本 + 分镜脚本
      step_range: "7, 8"
      description: |
        将剧情大纲拆分到每一集，形成每集脚本（对白、旁白、情绪指示、时长预估），
        再将每集脚本拆分为分镜脚本（镜头号、景别、运镜、时长、画面内容、对白、音效）。
    - path: references/duanju-fenjing.md
      purpose: 分镜首帧图 + 动画 + 配音 + 字幕
      step_range: "9, 10, 11, 12, 13, 15, 16"
      models:
        - comfyui/z-image   # 分镜首帧图
        - comfyui/LTX2.3    # 分镜动画
        - comfyui/TTS       # 配音
      description: |
        生成分镜场景提示词（融合人物与场景），生成分镜首帧图并校验一致性，
        完成图生视频动画，再进行 TTS 配音与字幕生成，并校准口型。
    - path: references/duanju-hebing.md
      purpose: 分镜合并 + 全集成片 + BGM
      step_range: "14, 17"
      description: |
        将全部分镜视频拼接为一集成片，并根据剧情与画面配 BGM，
        没有特殊、重要剧情的集数可不增加 BGM。
  scripts_detail:
    - path: script/wol.sh
      purpose: 网络唤醒启动远程 Windows 台式机
      description: |
        通过 WOL 魔术包唤醒远程 Windows，ComfyUI 调用前的必要步骤。
    - path: script/winstartcomfyui.sh
      purpose: SSH 启动远程 ComfyUI
      description: |
        通过 SSH 登录远程 Windows 并启动 ComfyUI 服务，监听 8188 端口。
    - path: script/winstopcomfyui.sh
      purpose: SSH 关闭远程 ComfyUI
      description: |
        通过 SSH 优雅关闭远程 ComfyUI 进程，避免显存未释放。

# 短剧创作全流程工作流
workflow:
  rules:
    - 每一步需要与用户确认，无修改后进行下一步
  steps:
    - id: 1
      name: 剧情大纲生成
      action: 根据用户指定的短剧类型（言情/悬疑/都市/古风/玄幻/家庭/喜剧等）生成短剧整体剧情大纲与世界观
      input: 短剧类型
      output: 短剧剧情大纲
      next: 2
    - id: 2
      name: 人物提示词生成
      action: 生成重点人物描述提示词（外貌、性格、服饰、年龄、气质、典型动作）
      input: 短剧剧情大纲
      output: 重点人物提示词
      next: 3
    - id: 3
      name: 人物三面图生成
      action: 依据人物提示词生成人物三面图（正面 / 侧面 / 背面）
      input: 重点人物提示词
      model: comfyui/z-image
      output: 人物三面图
      next: 4
    - id: 4
      name: 人物声纹生成
      action: 生成重点人物声纹（音色、年龄感、语速、情绪、方言或语言）
      input: 重点人物提示词
      output: 人物声纹
      next: 5
    - id: 5
      name: 场景提示词生成
      action: 生成重点场景描述提示词（环境、光线、色调、构图、时代、地域）
      input: 短剧剧情大纲
      output: 重点场景提示词
      next: 6
    - id: 6
      name: 场景图片生成
      action: 依据场景提示词生成重点场景图片
      input: 重点场景提示词
      model: comfyui/z-image
      output: 重点场景图
      next: 7
    - id: 7
      name: 集脚本生成
      action: 将剧情大纲拆分到每一集，形成每集脚本（含对白、旁白、情绪指示、时长预估）
      input: 短剧剧情大纲
      output: 每集脚本
      next: 8
    - id: 8
      name: 分镜脚本生成
      action: 将每集脚本进一步拆分为分镜脚本（镜头号、景别、运镜、时长、画面内容、对白、音效）
      input: 每集脚本
      output: 每集分镜脚本
      next: 9
    - id: 9
      name: 分镜场景提示词生成
      action: 生成分镜场景提示词（融合人物与重点场景描述）
      input: [分镜脚本, 重点人物提示词, 重点场景提示词]
      output: 分镜场景提示词
      next: 10
    - id: 10
      name: 分镜首帧图生成
      action: 参考重点场景与人物，生成分镜首帧图片
      input: 分镜场景提示词
      model: comfyui/z-image
      output: 分镜首帧图
      next: 11
    - id: 11
      name: 首帧一致性校验
      action: 验证首帧图片与人物/场景一致性，必要时重绘
      input: [分镜首帧图, 重点人物提示词, 重点场景提示词]
      on_fail: 重绘分镜首帧图（回到 step 10）
      next: 12
    - id: 12
      name: 分镜动画生成
      action: 依据首帧图片完成分镜动画生成（首尾帧 / 图生视频）
      input: 分镜首帧图
      model: comfyui/LTX2.3
      output: 分镜动画
      next: 13
    - id: 13
      name: 分镜动画质量校验
      action: 验证分镜动画质量，必要时重生成
      input: 分镜动画
      on_fail: 重新生成分镜动画（回到 step 12）
      next: 14
    - id: 14
      name: 分镜视频拼接
      action: 拼接全部分镜视频，输出一集成片
      input: 分镜动画（全集）
      output: 一集成片
      next: 15
    - id: 15
      name: 配音与字幕生成
      action: 根据每集脚本进行配音并添加字幕
      input: 每集脚本
      model: comfyui/TTS
      output: [配音, 字幕]
      next: 16
    - id: 16
      name: 口型校准
      action: 校准人物口型与配音、字幕同步
      input: [一集成片, 配音, 字幕]
      next: 17
    - id: 17
      name: 全集制作
      action: 完成一集后继续制作后续剧集，直至全集完成
      input: 当前集完成状态
      on_end: 输出最终全集成片
  outputs:
    - 短剧剧情大纲
    - 重点人物提示词 + 三面图 + 声纹
    - 重点场景提示词 + 场景图
    - 每集脚本
    - 每集分镜脚本
    - 分镜首帧图
    - 分镜动画 + TTS配音 + 字幕 / 拼接成片
    - 拼接分镜动画 + 配BGM


# 解释规则
rules:
  language:
    - 口语化，避免晦涩术语
    - 多使用网红语
  structure:
    - 每部分清晰
    - 重点加粗

# ComfyUI 环境
comfyui:
  os: Windows
  api: http://192.168.0.2:8188
  port: 8188
  host: 192.168.0.2
  hardware:
    cpu: i7 9700k
    ram: 32G
    gpu: 3080 20g显存
  paths:
    install: smb://administrator:123456@192.168.0.2/ComfyUI/
    output: smb://administrator:123456@192.168.0.2/ComfyUI/output
    input: smb://administrator:123456@192.168.0.2/ComfyUI/input
    workflow: smb://administrator:123456@192.168.0.2/ComfyUI/user/default/workflows/template
  default_workflows:
    directories:
      root: smb://administrator:123456@192.168.0.2/ComfyUI/
      models: smb://administrator:123456@192.168.0.2/ComfyUI/models
      output: smb://administrator:123456@192.168.0.2/ComfyUI/output
      input: smb://administrator:123456@192.168.0.2/ComfyUI/input
    workflows:
      - name: LTX2.3模型 图片生成视频
        path: comfyui_workflows/image_video_ltx2_3.json
      - name: Wan2.2模型 图片生成视频
        path: comfyui_workflows/image_video_wan2_2_14B.json
      - name: Qwen image edit模型 图片修改
        path: comfyui_workflows/qwen_Image_edit.json
      - name: Wan2.2模型 起始帧到结束帧
        path: comfyui_workflows/start_end_video_wan2_2_14B.json
      - name: LTX2.3模型 文字生成视频
        path: comfyui_workflows/text_video_ltx2_3.json
      - name: Wan2.2模型 文字生成视频
        path: comfyui_workflows/text_video_wan2_2_14B.json
      - name: Wan2.2模型 控制镜头视频生成
        path: comfyui_workflows/video_wan2_2_14B_fun_camera.json
      - name: z_image模型 图片生成
        path: comfyui_workflows/z_image_turbo_text_to_image.json
  rules:
    - 在comfyui中不可以使用线上付费模型，只可以使用开源模型
    - 如需要下载新模型请提示用户，由用户手动下载
    - 生成视频时请复制默认工作流文件到agent的workspace目录中，形成临时工作流文件进行调整后执行
    - 执行成功后删除临时生成的工作流文件
    - 不可以在默认工作流文件上进行修改
    - comfyui调用方式为 curl提交工作流的方式，例如：
      - curl -X POST http://192.168.0.2:8188/prompt \
        -H "Content-Type: application/json" \
        -d @workflow_api.json

# 工具脚本
scripts:
  - name: wol.sh
    purpose: 网络唤醒启动远程 Windows 台式机
    usages:
      - command: script/wol.sh
        aliases: [wake]
        description: 默认 WOL 唤醒 + 等上线
      - command: script/wol.sh check
        description: 只检查 Windows 是否在线（不唤醒）
        output: "✅ Windows 在线 (192.168.0.2) 或 ❌ Windows 不在线"
      - command: script/wol.sh wait
        description: 只等上线（不发魔术包），用于「已经发了包在等」场景
  - name: winstartcomfyui.sh
    purpose: 使用 ssh 启动远程 Windows 上的 ComfyUI
  - name: winstopcomfyui.sh
    purpose: 使用 ssh 关闭远程 Windows 上的 ComfyUI

# ComfyUI 启动流程
comfyui_startup:
  description: 使用 ComfyUI 前先检查 http://192.168.0.2:8188 是否可正常访问
  steps:
    - id: check_models
      action: 检查 ComfyUI 默认工作流中使用的模型是否已下载 smb://administrator:123456@192.168.0.2/ComfyUI/models 目录中
      模型文件列表: |
      models/
      ├── checkpoints/                      
      │   └── ltx-2.3-22b-dev-fp8.safetensors
      └── diffusion_models/
      │   ├── qwen_image_edit_2511_fp8mixed.safetensors
      │   ├── wan2.2_fun_camera_high_noise_14B_fp8_scaled.safetensors
      │   ├── wan2.2_fun_camera_low_noise_14B_fp8_scaled.safetensors
      │   ├── wan2.2_i2v_high_noise_14B_fp8_scaled.safetensors
      │   ├── wan2.2_i2v_low_noise_14B_fp8_scaled.safetensors
      │   ├── wan2.2_t2v_high_noise_14B_fp8_scaled.safetensors
      │   ├── wan2.2_t2v_low_noise_14B_fp8_scaled.safetensors
      │   └── z_image_turbo_bf16.safetensors
      └── Kokorotts/
      │   └── kokoro-v1_0.pth
      └── latent_upscale_models/
      │   └── ltx-2.3-spatial-upscaler-x2-1.1.safetensors
      └── loras/
      │   ├── gemma-3-12b-it-abliterated_lora_rank64_bf16.safetensors
      │   ├── ltx-2.3-22b-distilled-lora-384.safetensors
      │   ├── ltx-2.3-id-lora-talkvid-3k.safetensors
      │   ├── Qwen-Edit-2509-Multiple-angles.safetensors
      │   ├── Qwen-Image-Edit-2509-Anything2RealAlpha.safetensors
      │   ├── Qwen-Image-Edit-2509-Fusion.safetensors
      │   ├── Qwen-Image-Edit-2509-Light-Migration.safetensors
      │   ├── Qwen-Image-Edit-2509-Relight.safetensors
      │   ├── Qwen-Image-Edit-2509-White_to_Scene.safetensors
      │   ├── ruanqing-Z-Image-Turbo-Tongyi-MAI-v1.0_20.safetensors
      │   ├── split_files_loras_Qwen-Image-Edit-2509-Light-Migration.safetensors
      │   ├── wan2.2_i2v_lightx2v_4steps_lora_v1_high_noise.safetensors
      │   ├── wan2.2_i2v_lightx2v_4steps_lora_v1_low_noise.safetensors
      │   ├── wan2.2_t2v_lightx2v_4steps_lora_v1.1_high_noise.safetensors
      │   ├── wan2.2_t2v_lightx2v_4steps_lora_v1.1_low_noise.safetensors
      │   ├── XB_ZIMAGE_TURBO_CG_20.safetensors
      │   ├── XB_ZIMAGE_TURBO_ECY_20.safetensors
      │   └── z_image_turbo_distill_patch_lora_bf16.safetensors
      └── text_encoders/
      │   ├── gemma_3_12B_it_fp4_mixed.safetensors
      │   ├── qwen_2.5_vl_7b_fp8_scaled.safetensors
      │   ├── qwen_3_4b_fp8_mixed.safetensors
      │   ├── qwen_3_4b.safetensors
      │   └── umt5_xxl_fp8_e4m3fn_scaled.safetensors
      └── unet/
      │   ├── Qwen-Image-Edit-2511-FP8_e4m3fn.safetensors
      │   └── qwen-image-edit-2511-Q6_K.gguf
      └── vae/
      │   ├── diffusion_pytorch_model.safetensors
      │   ├── qwen_image_vae.safetensors
      │   ├── wan_2.1_vae.safetensors
      │   └── z-image-turbo-ae.safetensors
      └── vae_approx
          ├── taef1_decoder.safetensors
          ├── taef1_encoder.safetensors
          ├── taesd_decoder.safetensors
          ├── taesd_encoder.safetensors
          ├── taesd3_decoder.safetensors
          ├── taesd3_encoder.safetensors
          ├── taesdxl_decoder.safetensors
          └── taesdxl_encoder.safetensors
      on_fail: 提示用户下载缺失模型，提示模型下载链接及模型文件目录，并等待用户完成下载操作，重新验证
    - id: check_api
      action: 检查 http://192.168.0.2:8188 是否可正常访问
      on_success: 进入 ComfyUI 任务
      on_fail: 继续启动流程
    - id: check_windows
      action: 使用 script/wol.sh check 检查 Windows 是否开机
      on_offline:
        - 使用 script/wol.sh 唤醒 Windows
        - on_fail: 提示用户手动开机，并等待用户完成开机操作
      on_online: 进入启动 ComfyUI 步骤
    - id: start_comfyui
      action: 使用 winstartcomfyui.sh 启动远程 Windows 上的 ComfyUI
      then: 再次检查 http://192.168.0.2:8188 是否可正常访问
      on_still_fail:
        - 使用 winstopcomfyui.sh 关闭后，再次使用 winstartcomfyui.sh 启动
        - 仍失败：提示用户手动启动 ComfyUI，并等待用户完成启动操作

# 上下文检查
context_check:
  steps:
    - 检查是否已存在未完成的短剧
    - 若存在：询问用户「继续生产流程」或「重新生成短剧」
    - 若不存在：进入短剧基础信息收集阶段
  triggers:
    on_exist_pending: 询问用户「继续生产流程」或「重新生成短剧」
    on_none: 进入 basic_info_collection 阶段

## 短剧基础信息收集
basic_info_collection:
  # 短剧类型
  type:
    description: 短剧类型
    options: [言情, 悬疑, 都市, 古风, 玄幻, 家庭, 喜剧]
    required: true
    action: 给出类型选项，等待用户选择确认

  # 短剧形式
  form:
    description: 短剧形式
    options: [穿越, 重生, 金手指]
    required: true
    action: 给出类型选项，等待用户选择确认

  # 短剧集数
  episodes:
    description: 短剧集数
    default: 75~90集
    action: 询问用户是否同意默认值

  # 每集时长
  duration_per_episode:
    description: 每集时长
    default: 90s左右
    action: 询问用户是否同意默认值

  # 短剧分辨率
  resolution:
    description: 短剧分辨率
    default: 1080p
    action: 询问用户是否同意默认值

  # 短剧画风
  style:
    description: 短剧画风
    options: [模仿中国真人, 2D日系动漫风格, 3D国漫风格]
    default: 模仿真人
    action: 给出类型选项，等待用户选择确认 
  # 信息持久化
  persistence:
    action: 将收集到的信息关联到上下文，保持到本部短剧生成完成


## 短剧生成
generation:
  description: 基础信息收集完成后，根据短剧基础信息，调用相应的md完成短剧生产工作
  trigger: basic_info_collection 完成
  action: 根据短剧基础信息（类型/形式/集数/时长/分辨率/画风），调用相应的 md 完成短剧生产工作
  inputs:
    - basic_info
  outputs:
    - 完整短剧成片
  references:
    - references/duanju-*.md
  next: 输出成片并交付用户

