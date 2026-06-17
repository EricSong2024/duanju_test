---
name: duanju-scene-prompt
version: 1.0
trigger:
  - "生成场景参考图"
  - "场景概念图"
  - "场景三视图"
  - "参考素材"
inputs:
  required:
    - workspace_root: "工作空间根目录路径，存放 duanju 项目的目录"
    - project_name: "短剧项目名称，对应 workspace_root/duanju/<project_name>/"
  optional:
    - scenes: "预定义场景列表（跳过 3.1 大模型分析步骤）"
outputs:
  primary: "workspace_root/duanju/<project_name>/参考素材.md"
  per_scene:
    description: "workspace_root/duanju/<project_name>/<场景>/<场景>.md"
    concept: "workspace_root/duanju/<project_name>/<场景>/<场景>_concept.png"
    reference: "workspace_root/duanju/<project_name>/<场景>/<场景>.png"
dependencies:
  skills:
    - skill.md: "ComfyUI 远程调用参数与提示词模板"
  workflows:
    - comfyui_workflows/z_image_turbo_text_to_image.json
    - comfyui_workflows/qwen_Image_edit.json
  files:
    - workspace_root/duanju/<project_name>/大纲.md
entry_steps:
  - 3.1: "读取大纲并分析重点场景"
  - 3.2: "逐个生成场景图片"
  - 6: "汇总至参考素材.md"
downstream_skills:
  - 分镜生成
  - 视频剪辑
  - 道具 / 服装设计
pause_resume: true
idempotent: true
---

## 1. 概述
本 skill 用于在短剧制作流程中，根据 `workspace目录/duanju/<剧名>/大纲.md` 分析需要生成参考图片的重点场景，并使用 ComfyUI 逐个生成场景概念图与三视图，最终汇总至 `参考素材.md` 供后续分镜、剪辑等 skill 调用。

## 2. 前置条件
- 已存在 `workspace目录/duanju/<剧名>/大纲.md`
- `skill.md` 中已配置好 ComfyUI 远程调用参数（API 地址、参数模板等）
- 已存在工作流文件：
  - `comfyui_workflows/z_image_turbo_text_to_image.json`（文生图）
  - `comfyui_workflows/qwen_Image_edit.json`（图像编辑 / 三视图）

### 2.1 检查 ComfyUI 服务可用性
1. 检测 `skill.md` 中配置的 ComfyUI API 是否可访问，验证服务是否在线。
2. 可访问 → 直接进入 3.1。
3. 不可访问 → 询问用户是否使用脚本打开 Windows（唤醒主机 + SSH 远程启动 ComfyUI）。
4. 用户同意使用脚本：
   1. 执行开机脚本（Wake-on-LAN 等）唤醒 Windows 主机。
   2. 轮询等待 Windows 启动完成，直到可通过 SSH 连接。
   3. SSH 连接成功后，远程执行命令启动 ComfyUI 服务。
   4. 重新检测 ComfyUI API 是否可访问；可访问则继续 3.1，仍不可用则报错。
5. 用户拒绝使用脚本 → 提示用户手动开机 Windows 并启动 ComfyUI 服务后重试。

## 3. 工作流程

### 3.1 读取大纲并分析重点场景
1. 检查 `workspace目录/duanju/<剧名>/大纲.md` 是否存在：
   - 不存在 → 提示用户等待大纲就绪后重试，本 skill 不执行后续步骤。
2. 读取大纲内容，由大模型分析需要生成参考图片的「重点场景」列表。
3. 每个场景需附带：**场景名称**、**在剧情中的作用 / 重要性**、**涉及的主要剧情节点**。
4. 将分析结果通知用户，询问是否需要删减 / 调整。
5. 用户确认后，得到最终场景列表 `scenes = [scene1, scene2, ...]`。

### 3.2 逐个生成场景图片

对 `scenes` 列表中每个场景依次执行以下流程。

#### 3.2.1 创建场景描述文件
- 路径：`workspace/duanju/<剧名>/<场景>/<场景>.md`
- 同时创建同名目录 `workspace/duanju/<剧名>/<场景>/`。
- 文件结构：
  ```
  # 场景：<场景名称>

  ## 在剧情中的作用
  <简述该场景在短剧中的剧情节点与重要性>

  ## 场景描述
  <空间布局、风格、色调、关键元素、参考风格等详细描述>

  ## 场景参考图片
  <!-- 由后续步骤填充 -->
  ```

#### 3.2.2 文生图：生成 3 张场景概念图
1. 基于「场景描述」由大模型生成 ComfyUI 提示词（英文，侧重空间、风格、光照、构图）。
2. 加载 `comfyui_workflows/z_image_turbo_text_to_image.json` 作为工作流模板，生成临时工作流文件，不可以修改工作流模版。
3. 仅修改提示词字段，其余参数沿用 `skill.md` 中的 ComfyUI 配置与调用方式。
4. 远程 ComfyUI 一次生成 **3 张** 场景图片。
5. 大模型对比 3 张图片，结合剧情与场景设定分析哪张最契合。
6. 将 3 张图全部发送给用户，并附推荐意见，让用户最终选择 1 张。
7. 用户选择的图片保存为：`workspace/duanju/<剧名>/<场景>/<场景>_concept.png`。

#### 3.2.3 图生图：生成场景三视图
1. 以用户选择的 `场景_concept.png` 作为参考图。
2. 加载 `comfyui_workflows/qwen_Image_edit.json` 作为工作流模板，生成临时工作流文件，不可以修改工作流模版。
3. 修改提示词，提示词需明确：
   - **三视图**：正面（front view）/ 侧面（side view）/ 俯视（top-down view）
   - **白背景**
   - **保持场景一致性**
   - **全场景**
4. 远程 ComfyUI 调用，生成场景三视图。
5. 将生成结果发送给用户确认。
6. 用户确认后保存为：`workspace/duanju/<剧名>/<场景>/<场景>.png`。
7. 同时在「场景描述文件」的 `## 场景参考图片` 一节中追加引用：
   ```
   ![场景参考图](<场景>.png)
   ```

### 3.3 循环
回到 3.2，对下一个场景重复执行，直至所有场景均完成。

## 4. 错误与异常
| 异常 | 处理方式 |
| --- | --- |
| ComfyUI 调用失败 | 保留临时文件以便排查，重试 1 次；仍失败则向用户报错并继续下一场景 |
| 用户未选择图像 | 等待用户输入，不得自行决定 |
| 场景概念图与场景描述冲突 | 重新生成提示词并重试一次，仍不符合则与用户确认调整 |
| 三视图与概念图风格不一致 | 重新调整提示词并重试一次，仍不一致则与用户确认 |
| 场景目录已存在 | 沿用已有目录，必要时询问用户是否覆盖 |

## 5. 暂停 / 恢复
- 任一步骤可暂停，下次执行从当前场景继续。
- 已完成的场景无需重复生成。

## 6. 全剧参考素材汇总

### 6.1 创建汇总文件
- 路径：`workspace/duanju/<剧名>/参考素材.md`
- 写入时机：所有重点场景的三视图与档案全部经用户确认后
- 若文件已存在，则在末尾追加，不覆盖已有内容

### 6.2 汇总格式
按以下固定模板逐个记录每一位重点场景：

```
场景参考素材：
场景：<场景>
路径：`workspace/duanju/<剧名>/<场景>/<场景>`
场景文件：`workspace/duanju/<剧名>/<场景>/<场景>.md`
场景参考图：`workspace/duanju/<剧名>/<场景>/<场景>.png`
```

### 6.3 记录示例
```
场景参考素材：
场景：大殿
路径：`workspace/duanju/我的短剧/大殿/大殿`
场景文件：`workspace/duanju/我的短剧/大殿/大殿.md`
场景参考图：`workspace/duanju/我的短剧/大殿/大殿.png`

场景参考素材：
场景：主峰
路径：`workspace/duanju/我的短剧/主峰/主峰`
场景文件：`workspace/duanju/我的短剧/主峰/主峰.md`
场景参考图：`workspace/duanju/我的短剧/主峰/主峰.png`
```

### 6.4 注意事项
- 每个场景之间使用一个空行分隔
- 路径使用反引号包裹，便于后续解析
- 汇总完成后向用户输出最终目录清单
- 该文件是后续 skill（分镜生成、视频剪辑等）查找场景资料的索引，必须保持准确

## 7. 示例

### 7.1 场景描述文件示例
`workspace/duanju/我的短剧/大殿/大殿.md`：

```
# 场景：大殿

## 在剧情中的作用
皇帝早朝、主角受封、最终决战等关键剧情均发生于此，是全剧最核心的权力与冲突中心。

## 场景描述
- 古代中式宫殿大殿
- 高耸的雕龙金柱、红色立柱与黑色匾额
- 大殿纵深约 50 米，前方为龙椅高台
- 整体庄严恢宏，光线偏暗，带有肃杀氛围
- 风格参考：宋代宫廷 + 玄幻写实

## 场景参考图片
![场景参考图](大殿.png)
```

### 7.2 参考素材汇总示例
`workspace/duanju/我的短剧/参考素材.md`：

```
场景参考素材：
场景：大殿
路径：`workspace/duanju/我的短剧/大殿/大殿`
场景文件：`workspace/duanju/我的短剧/大殿/大殿.md`
场景参考图：`workspace/duanju/我的短剧/大殿/大殿.png`

场景参考素材：
场景：主峰
路径：`workspace/duanju/我的短剧/主峰/主峰`
场景文件：`workspace/duanju/我的短剧/主峰/主峰.md`
场景参考图：`workspace/duanju/我的短剧/主峰/主峰.png`
```

## 8. 与其他 Skill 的衔接
- 本 skill 输出供以下 skill 使用：
  - **分镜生成**：根据场景参考图与场景描述进行分镜头设计
  - **视频剪辑**：根据场景参考图统一全剧视觉风格
  - **道具 / 服装设计**：参考场景风格生成配套物料

## 9. 版本与变更
- v1.0：初版，生成场景概念图 + 三视图并汇总至参考素材.md

