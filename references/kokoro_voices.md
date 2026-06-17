# Kokoro TTS 音色完整说明

> 适用于 ComfyUI-KokoroTTS 节点  
> 模型版本: Kokoro-82M v1.0  
> 音色来源: https://huggingface.co/hexgrad/Kokoro-82M  
> 部署路径: `E:\ComfyUI\ComfyUI\models\Kokorotts\`

---

## 📋 命名规则

每个 .pt 文件名遵循 **`X Y name.pt`** 三段式：

- **X** = 语言代码
  - `a` = 美式英语 (American)
  - `b` = 英式英语 (British)
  - `e` = 西班牙语 (Español)
  - `f` = 法语 (Français)
  - `h` = 印地语 (Hindi)
  - `i` = 意大利语 (Italiano)
  - `j` = 日语 (Japanese)
  - `p` = 葡萄牙语 (Português)
  - `z` = 中文 (Chinese)
- **Y** = 性别
  - `f` = 女 (female)
  - `m` = 男 (male)
- **name** = 风格/名字

---

## 🇺🇸 美式英语女声 (af_*) — 11 个

| 音色文件 | 风格 | 适合角色 |
|---|---|---|
| `af_alloy.pt` | 平稳 / 金属感 | 旁白 / AI 助手 |
| `af_aoede.pt` | 优雅 / 柔和 | 文艺女主 |
| `af_bella.pt` | 温暖 / 亲切 | 邻家女孩 |
| `af_heart.pt` | ⭐ **甜美 / 温柔** | 浪漫女主（Kokoro 主推音色） |
| `af_jessica.pt` | 活泼 / 明亮 | 喜剧角色 |
| `af_kore.pt` | 自然 / 清新 | 通用女声 |
| `af_nicole.pt` | 性感 / 成熟 | 霸道女主 |
| `af_nova.pt` | 活力 / 年轻 | 少女 |
| `af_river.pt` | 流畅 / 柔和 | 治愈系 |
| `af_sarah.pt` | 端庄 / 职业 | 商务女性 |
| `af_sky.pt` | 清亮 / 年轻 | 学生 |

## 🇺🇸 美式英语男声 (am_*) — 9 个

| 音色文件 | 风格 | 适合角色 |
|---|---|---|
| `am_adam.pt` | 自然 / 中性 | 通用男声 |
| `am_echo.pt` | 沉稳 / 共鸣 | 播音员 |
| `am_eric.pt` | 友好 / 温和 | 暖男 |
| `am_fenrir.pt` | 强烈 / 粗犷 | 反派 / 战士 |
| `am_liam.pt` | 清晰 / 职业 | 商务男性 |
| `am_michael.pt` | 权威 / 低沉 | 霸道总裁 |
| `am_onyx.pt` | 深沉 / 暗色 | 反派 / 神秘角色 |
| `am_puck.pt` | 活泼 / 调皮 | 喜剧角色 |
| `am_santa.pt` | 圣诞老人 | 节日 / 特殊角色 |

## 🇬🇧 英式英语女声 (bf_*) — 4 个

| 音色文件 | 风格 | 适合角色 |
|---|---|---|
| `bf_alice.pt` | 优雅 / 英国淑女 | 古典女主 |
| `bf_emma.pt` | 温和 / 英伦 | 知性女主 |
| `bf_isabella.pt` | 高贵 / 英式 | 贵族角色 |
| `bf_lily.pt` | 清纯 / 年轻 | 少女 |

## 🇬🇧 英式英语男声 (bm_*) — 4 个

| 音色文件 | 风格 | 适合角色 |
|---|---|---|
| `bm_daniel.pt` | 沉稳 / 英伦 | 绅士 |
| `bm_fable.pt` | 故事感 / 温暖 | 旁白 / 爷爷 |
| `bm_george.pt` | 权威 / 英式 | 侦探 / 律师 |
| `bm_lewis.pt` | 自然 / 友好 | 暖男 |

## 🇪🇸 西班牙语 (ef_* / em_*) — 2 个

| 音色文件 | 风格 |
|---|---|
| `ef_dora.pt` | 温柔 / 西语女声 |
| `em_alex.pt` | 沉稳 / 西语男声 |

## 🇫🇷 法语 (ff_*) — 1 个

| 音色文件 | 风格 |
|---|---|
| `ff_siwis.pt` | 优雅 / 法语女声 |

## 🇮🇳 印地语 (hf_* / hm_*) — 4 个

| 音色文件 | 风格 |
|---|---|
| `hf_alpha.pt` | 印地语女声 1 |
| `hf_beta.pt` | 印地语女声 2 |
| `hm_omega.pt` | 印地语男声 1 |
| `hm_psi.pt` | 印地语男声 2 |

## 🇮🇹 意大利语 (if_* / im_*) — 2 个

| 音色文件 | 风格 |
|---|---|
| `if_sara.pt` | 意大利语女声 |
| `im_nicola.pt` | 意大利语男声 |

## 🇯🇵 日语 (jf_* / jm_*) — 5 个

| 音色文件 | 风格 | 适合角色 |
|---|---|---|
| `jf_alpha.pt` | 动漫女声 | 二次元角色 |
| `jf_gongitsune.pt` | 狐妖 / 古典 | 奇幻角色 |
| `jf_nezumi.pt` | 老鼠 / 年幼 | 可爱角色 |
| `jf_tebukuro.pt` | 手套 / 故事 | 旁白 |
| `jm_kumo.pt` | 蜘蛛 / 沉稳 | 反派 |

## 🇵🇹 葡萄牙语 (pf_* / pm_*) — 2 个

| 音色文件 | 风格 |
|---|---|
| `pf_dora.pt` | 葡语女声 |
| `pm_alex.pt` | 葡语男声 |

---

## 🇨🇳 ⭐ 中文女声 (zf_*) — 4 个

| 音色文件 | 风格 | 推荐短剧角色 |
|---|---|---|
| `zf_xiaobei.pt` | 甜妹 / 可爱 | 女二号 / 妹妹 |
| `zf_xiaoni.pt` | 温柔 / 活泼 | 女主（日常对话） |
| **`zf_xiaoxiao.pt`** | ⭐ **温柔 / 成熟** | **女主（首推）** |
| `zf_xiaoyi.pt` | 播音员 / 专业 | 旁白 / 解说 |

## 🇨🇳 ⭐ 中文男声 (zm_*) — 4 个

| 音色文件 | 风格 | 推荐短剧角色 |
|---|---|---|
| **`zm_yunjian.pt`** | ⭐ **磁性 / 低沉** | **男主（首推）** |
| `zm_yunxi.pt` | 青年 / 温和 | 暖男男二 |
| `zm_yunxia.pt` | 少年 / 青涩 | 小鲜肉 / 学弟 |
| `zm_yunyang.pt` | 中年 / 沧桑 | 反派 / 父亲 / 师父 |

---

## 🎬 短剧配音推荐方案

### 方案 1：都市言情（5-6 个角色）

| 角色 | 音色文件 | 备注 |
|---|---|---|
| 女主 | `zf_xiaoxiao.pt` | 温柔 / 成熟 |
| 男主 | `zm_yunjian.pt` | 磁性 / 低沉 |
| 女主闺蜜 | `zf_xiaoni.pt` | 温柔 / 活泼 |
| 男主兄弟 | `zm_yunxi.pt` | 青年 / 温和 |
| 旁白 | `zf_xiaoyi.pt` | 播音员 |
| 反派女 | `zf_xiaobei.pt` | 甜妹 / 可爱（反串） |
| 反派男 | `zm_yunyang.pt` | 中年 / 沧桑 |

### 方案 2：古风 / 玄幻（6 个角色）

| 角色 | 音色文件 | 备注 |
|---|---|---|
| 女主 | `zf_xiaoxiao.pt` | 温柔 / 成熟 |
| 男主 | `zm_yunjian.pt` | 磁性 / 低沉 |
| 师父 | `zm_yunyang.pt` | 中年 / 沧桑 |
| 小师妹 | `zf_xiaoni.pt` | 温柔 / 活泼 |
| 师兄 | `zm_yunxi.pt` | 青年 / 温和 |
| 大反派 | `zm_yunyang.pt` | 中年 / 沧桑（沧桑感更强） |
| 旁白 | `zf_xiaoyi.pt` | 播音员 |

### 方案 3：现代悬疑（多语言）

| 角色 | 音色文件 | 备注 |
|---|---|---|
| 女侦探（中文） | `zf_xiaoxiao.pt` | 温柔 / 成熟 |
| 男警察（中文） | `zm_yunjian.pt` | 磁性 / 低沉 |
| 神秘反派（英文） | `am_onyx.pt` | 深沉 / 暗色 |
| 旁白（中文） | `zf_xiaoyi.pt` | 播音员 |
| 受害者（中文） | `zf_xiaobei.pt` | 甜妹 / 可爱 |
| 外国证人（英文） | `af_sarah.pt` | 端庄 / 职业 |

---

## 💡 感情控制参数

| 场景 | speed | pitch | 备注 |
|---|---|---|---|
| 平静叙事 | 1.0 | 0 | 默认 |
| 激动 | 1.3 | +0.3 | 加快 + 升调 |
| 悲伤 | 0.8 | -0.2 | 放慢 + 降调 |
| 惊讶 | 1.4 | +0.5 | 大幅加快 + 大幅升调 |
| 温柔 | 0.9 | +0.1 | 稍慢 + 微升调 |
| 神秘 | 0.85 | -0.1 | 慢 + 微降调 |
| 愤怒 | 1.2 | -0.3 | 加快 + 大幅降调（低沉怒吼） |
| 恐惧 | 1.3 | +0.2 | 加快 + 升调 |
| 撒娇 | 0.95 | +0.4 | 略慢 + 升调（甜腻） |
| 播报 | 1.0 | -0.1 | 标准 + 微降调（沉稳） |

---

## 🎯 短剧主力 6 个音色（推荐组合）

适合 80 集短剧的最小集合：

1. **`zf_xiaoxiao.pt`** — 女主标配
2. **`zm_yunjian.pt`** — 男主标配
3. **`zf_xiaoyi.pt`** — 旁白
4. **`zf_xiaoni.pt`** — 活泼女配
5. **`zm_yunxi.pt`** — 温和男配
6. **`zm_yunyang.pt`** — 反派

---

## 📁 文件清单

### Windows 端模型目录

```
E:\ComfyUI\ComfyUI\models\Kokorotts\
├── kokoro-v1_0.pth         主模型 (327 MB)
├── config.json             配置文件
├── Kokoro-82M\             完整 HuggingFace 仓库
└── voices\                 音色包目录 (55 个 .pt 文件)
    ├── af_*.pt             11 个美式英语女声
    ├── am_*.pt              9 个美式英语男声
    ├── bf_*.pt              4 个英式英语女声
    ├── bm_*.pt              4 个英式英语男声
    ├── ef_*.pt              1 个西班牙语女声
    ├── em_*.pt              1 个西班牙语男声
    ├── ff_*.pt              1 个法语女声
    ├── hf_*.pt              2 个印地语女声
    ├── hm_*.pt              2 个印地语男声
    ├── if_*.pt              1 个意大利语女声
    ├── im_*.pt              1 个意大利语男声
    ├── jf_*.pt              4 个日语女声
    ├── jm_*.pt              1 个日语男声
    ├── pf_*.pt              1 个葡萄牙语女声
    ├── pm_*.pt              1 个葡萄牙语男声
    ├── zf_*.pt              4 个中文女声
    └── zm_*.pt              4 个中文男声
```

### 关键文件大小

| 文件类型 | 单个大小 |
|---|---|
| 主模型 `kokoro-v1_0.pth` | ~327 MB |
| 单个音色 `*.pt` | ~520 KB |

---

## 🚀 快速开始

### ComfyUI 节点调用示例

```python
# 在 ComfyUI 工作流中配置 KokoroTextToSpeech 节点
node_config = {
    "text": "你好，这是一段测试语音。",
    "voice": "zf_xiaoxiao",  # 音色 ID（不要带 .pt）
    "speed": 1.0,
    "pitch": 0,
    "model_path": "E:\\ComfyUI\\ComfyUI\\models\\Kokorotts\\kokoro-v1_0.pth",
    "voices_json": "E:\\ComfyUI\\ComfyUI\\models\\Kokorotts\\voices"
}
```

### Python 直接调用示例

```python
from kokoro import KPipeline

# 中文女声
pipeline = KPipeline(lang_code='z', voice='zf_xiaoxiao')
text = "这辆车真漂亮。"
generator = pipeline(text, speed=1.0)

for i, (gs, ps, audio) in enumerate(generator):
    # audio 是 numpy 数组，可以保存为 wav
    import soundfile as sf
    sf.write(f"output_{i}.wav", audio, 24000)
```

---

## 🔗 相关链接

- **GitHub 节点**: https://github.com/benjiyaya/ComfyUI-KokoroTTS
- **模型仓库**: https://huggingface.co/hexgrad/Kokoro-82M
- **镜像站**: https://hf-mirror.com/hexgrad/Kokoro-82M
- **官方文档**: https://kokorotts.com

---

**最后更新**: 2026-06-08  
**部署人**: 小T (IT Engineer)  
**状态**: 全部 55 个音色就绪 ✅
