---
name: duanju-character-prompt
description: 为短剧中的重点人物生成形象参考图、全身三面图与头部特写三面图，确保全剧角色一致性，并选择人物 TTS 音色、语速以及全剧旁白音色
version: 1.0.0
author: duanju-skill
tags:
  - 短剧
  - 人物形象
  - 三面图
  - TTS 音色
  - 旁白
triggers:
  - 生成短剧人物形象
  - 制作人物三面图
  - 制作人物头部三面图
  - 选择人物 TTS 音色
  - 选择全剧旁白音色
  - 汇总全剧人物素材
inputs:
  - 剧名（duanju 名称）
  - 重点人物清单及每人的人物设定/特点
outputs:
  - 人物档案：workspace/duanju/<剧名>/<人名>/<人名>.md
  - 人物全身三面图：workspace/duanju/<剧名>/<人名>/<人名>.png
  - 人物头部三面图：workspace/duanju/<剧名>/<人名>/<人名>_head.png
  - 人物试听音频：workspace/duanju/<剧名>/<人名>/<人名>
  - 全剧参考素材汇总：workspace/duanju/<剧名>/参考素材.md
dependencies:
  - 远程 ComfyUI 服务
  - 主 skill.md（ComfyUI 配置与调用方式）
  - comfyui_workflows/z_image_turbo_text_to_image.json
  - comfyui_workflows/qwen_Image_edit.json
  - comfyui_workflows/kokoro_voices.md
  - TTS 试听生成能力（Kokoro）
scope:
  workspace_only: true
  allowed_dirs:
    - workspace/duanju/<剧名>/
cleanup:
  delete_temp_workflow: true
  delete_temp_candidate_images: true
  delete_narrator_preview: true
constraints:
  - 同一短剧内不同人物 TTS 音色必须互不重复
  - 旁白音色必须与所有人物音色互不重复
  - 三面图必须包含正面、侧面、背面，白背景，保持人物一致性
  - 头部三面图须为肩部以上裁切的特写
  - 流程中产生的中间文件应在结束后删除
  - 用户未确认时不得自行决定
---

# 短剧人物形象生成 Skill

## 职责
- 只在 agent 的 workspace 目录中创建/写入文件
- 使用远程 ComfyUI 生成人物形象图与三面图
- ComfyUI 配置与调用方式继承自主 `skill.md`
- 为每一个重点人物产出形象参考图与三面图，用于整部短剧的角色一致性

## 输入
- 剧名（duanju 名称）
- 重点人物清单及每人的人物设定/特点

## 输出
- `workspace/duanju/<剧名>/<人名>/<人名>.md`：人物档案
  - 人物设定与特点
  - 人物 TTS 语音信息
  - 人物三面图文件目录
- `workspace/duanju/<剧名>/<人名>/<人名>.png`：人物三面图
- `workspace/duanju/<剧名>/参考素材.md`：全剧人物素材汇总，按以下格式记录所有人物素材：
  ```
  人物参考素材：
  人物：小红
  路径：`workspace/duanju/<剧名>/<人名>/<人名>`
  人物文件：`workspace/duanju/<剧名>/<人名>/<人名>.md`
  人物参考图：`workspace/duanju/<剧名>/<人名>/<人名>.png`
  ```
- 流程中产生的中间文件应在结束后删除

## 主流程
对每一个重点人物，按以下步骤循环执行：

### 1. 撰写人物提示词
- 依据人物设定/特点撰写英文（或 ComfyUI 所需语言）提示词
- 提示词要求：
  - 白背景（white background）
  - 充分体现人物特点（年龄、性别、服饰、气质等）
  - 正面、全身（full body, front view）
  - 不要夸张动作（no exaggerated pose）

### 2. 生成人物形象图片
- 参考 `comfyui_workflows/z_image_turbo_text_to_image.json`，生成临时工作流文件，不可以修改工作流模版。
- 仅修改提示词，其余参数沿用主 `skill.md` 中的 ComfyUI 配置与调用方式
- 远程 ComfyUI 一次生成 3 张人物图片
- 大模型对比 3 张图片，结合人物设定分析哪张最契合剧情
- 将 3 张图全部发送给用户，给出推荐意见，并让用户最终选择 1 张

### 3. 生成人物三面图
- 基于用户选择的人物图片作为参考
- 参考 `comfyui_workflows/qwen_Image_edit.json`，修改提示词，生成临时工作流文件，不可以修改工作流模版。
- 提示词需明确：三面（正面 / 侧面 / 背面）、白背景、保持人物一致性、全身
- 远程 ComfyUI 调用，生成人物三面图
- 生成后发送给用户确认

### 3.5 生成人物头部形象特写三面图
- 基于用户选择的人物图片作为参考
- 参考 `comfyui_workflows/qwen_Image_edit.json`，修改提示词，生成临时工作流文件，不可以修改工作流模版。
- 提示词需明确：三面（正面 / 侧面 / 背面）、白背景、保持人物一致性、头部特写（head close-up, face-focused, 从肩部以上裁切）
- 远程 ComfyUI 调用，生成人物头部形象特写三面图
- 生成后发送给用户确认
- 保存路径：`workspace/duanju/<剧名>/<人名>/<人名>_head.png`

### 4. 选择 TTS 语音
- 音色必须可阅读中文
- 参考 `comfyui_workflows/kokoro_voices.md` 中的音色/语气描述
- 结合人物年龄、性别、性格选择最契合的音色
- 选择音色同时输出语速（speed，参考值范围 0.5 ~ 2.0，默认 1.0），并结合人物性格与场景情绪给出推荐语速
- **同一短剧内不同人物必须选择不同音色**

### 5. 用户确认后落档
- 创建人物描述文件：
  - 路径：`workspace/duanju/<剧名>/<人名>/<人名>.md`
  - 内容：
    - 人物设定与特点
    - 人物 TTS 信息（音色 id / 名称 / 语气备注 / 语速）
    - 人物三面图文件目录
- 保存人物三面图：
  - 路径：`workspace/duanju/<剧名>/<人名>/<人名>.png`
  - 路径：`workspace/duanju/<剧名>/<人名>/<人名>_head.png`
- 人物音色试听：
  - 生成一个人物试听音频
  - 路径：`workspace/duanju/<剧名>/<人名>/<人名>`
- 删除临时文件：
  - 临时生成的工作流脚本
  - 临时生成的中间图片（3 张候选形象图、过程图等）

## 循环
对清单中的每一位重点人物重复执行「主流程」1~5，直至所有人物三面图全部生成完毕。

## 错误与异常
- ComfyUI 调用失败：保留临时文件以便排查，重试一次后仍失败则向用户报错并继续下一人物
- 用户未选择图像：等待用户输入，不得自行决定
- 音色冲突（与已确认人物重复）：重新选择并提示用户确认


## 6. 旁白音色选择
全部重点人物的三面图与档案生成完毕后，需要为整部剧选择一个旁白音色。

### 6.1 选择要求
- 音色必须可阅读中文
- 参考 `comfyui_workflows/kokoro_voices.md` 中的音色/语气描述
- 结合剧情氛围选择最契合的音色（沉稳、清晰、有代入感等）
- **旁白音色必须与所有已确认人物音色不同**，避免与角色混淆
- 输出语速（speed，参考值范围 0.5 ~ 2.0，默认 1.0），结合剧情节奏给出推荐语速

### 6.2 试听与确认
- 生成一段旁白试听音频，使用选定音色朗读一句剧情旁白
- 路径：`workspace/duanju/<剧名>/narrator_preview.wav`（临时文件）
- 向用户展示并推荐音色及语速
- 用户未选择时等待用户输入，不得自行决定

### 6.3 音色冲突处理
- 若用户选择的旁白音色与已有人物音色重复，必须重新选择并提示用户
- 同一短剧内旁白音色与所有人物音色必须互不重复

### 6.4 落档
- 确认后将旁白音色与语速记录到全剧参考素材汇总中（见第 7 节）
- 删除临时试听音频 `narrator_preview.wav`


## 7. 全剧参考素材汇总
全部人物素材生成完毕后，需要在 `workspace/duanju/<剧名>/参考素材.md` 中汇总所有人物素材目录，供后续 skill（分镜、剪辑等）调用。

### 7.1 创建汇总文件
- 路径：`workspace/duanju/<剧名>/参考素材.md`
- 写入时机：所有重点人物的三面图与档案全部经用户确认后、旁白音色确认后
- 若文件已存在，则在末尾追加，不覆盖已有内容

### 7.2 汇总格式
按以下固定模板逐个记录每一位重点人物，并在末尾追加全剧旁白音色记录：

```
人物参考素材：
人物：<人名>
路径：`workspace/duanju/<剧名>/<人名>/<人名>`
人物文件：`workspace/duanju/<剧名>/<人名>/<人名>.md`
人物参考图：`workspace/duanju/<剧名>/<人名>/<人名>.png`
人物形象参考图：`workspace/duanju/<剧名>/<人名>/<人名>_head.png`
人物 TTS 音色：<音色 id>（<音色名称>）
人物 TTS 语速：<speed>


全剧旁白音色：
旁白音色：<音色 id>（<音色名称>）
旁白语速：<speed>
```

### 7.3 记录示例
```
人物参考素材：
人物：小红
路径：`workspace/duanju/我的短剧/小红/小红`
人物文件：`workspace/duanju/我的短剧/小红/小红.md`
人物参考图：`workspace/duanju/我的短剧/小红/小红.png`
人物形象参考图：`workspace/duanju/我的短剧/小红/小红_head.png`
人物 TTS 音色：zf_xiaoxiao（女声·温柔）
人物 TTS 语速：1.0


人物参考素材：
人物：小明
路径：`workspace/duanju/我的短剧/小明/小明`
人物文件：`workspace/duanju/我的短剧/小明/小明.md`
人物参考图：`workspace/duanju/我的短剧/小明/小明.png`
人物形象参考图：`workspace/duanju/我的短剧/小明/小明_head.png`
人物 TTS 音色：zm_xiangyu（男声·磁性）
人物 TTS 语速：0.9


全剧旁白音色：
旁白音色：zm_yunxi（男声·沉稳）
旁白语速：0.95
```

### 7.4 注意事项
- 每位人物之间使用一个空行分隔
- 路径使用反引号包裹，便于后续解析
- 汇总完成后向用户输出最终目录清单
- 该文件是后续 skill（分镜生成、视频剪辑等）查找人物资料的索引，必须保持准确
- 旁白音色与所有人物音色必须互不重复

## 示例
人物参考素材：
人物：小红
路径：`workspace/duanju/<剧名>/<人名>/<人名>`
人物文件：`workspace/duanju/<剧名>/<人名>/<人名>.md`
人物参考图：`workspace/duanju/<剧名>/<人名>/<人名>.png`
人物形象参考图：`workspace/duanju/<剧名>/<人名>/<人名>_head.png`


全剧旁白音色：
旁白音色：zm_yunxi（男声·沉稳）
旁白语速：0.95

