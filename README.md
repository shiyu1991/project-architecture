# project-architecture

[English](#english) | [中文](#中文)

---

<a id="中文"></a>

## 让 AI Coding Agent 像资深架构师一样工作

一个开源 Skill：从一句"我想做个 XX"，到可长期维护的企业级项目结构。

### 解决什么问题

用 AI 写代码的人越来越多，但 AI 生成项目的通病是：

- **一句话需求直接糊代码** — 不分析业务、不做选型，上来就是 Vue + SpringBoot
- **没有架构概念** — 所有代码堆在一起，第二次迭代就开始腐烂
- **重复造轮子** — 每个模块各写一套请求封装、错误处理、工具函数
- **技术选型拍脑袋** — 推荐过时版本、不兼容组合、为炫技上复杂方案
- **无法持续协作** — 换个 AI 会话就失忆，没有文档、没有决策记录

本 Skill 把资深架构师的工作方法固化为 AI Agent 的强制执行协议。

### 核心能力

| 能力 | 说明 |
|------|------|
| 三档用户模式 | 技术小白全程引导 / 产品经理业务建模 / 开发者快速过层，自动识别 |
| 规模分级 | S/M/L 三级判定，小项目不套大架构，反过度工程 |
| 交互式勾选选型 | 使用 `ask_followup_question` 工具让用户勾选技术栈，分三阶段：核心选择 + 前端全部层级 + 后端全部层级 |
| 多选兼容评估 | 每层默认单选，AI 评估后可开放多选——不冲突的方案可组合使用（如 Axios + fetch），Core 层统一封装 |
| 能力覆盖感知 | 自动检测已选框架自带能力，提供“使用内置”、独立方案或“无（暂不需要）”，不得静默跳过用户决策 |
| 分层联动推荐 | 选 A 推荐 B，前序选择筛选后序候选；配套插件按需推荐并由用户确认 |
| 兼容性矩阵 | 结构性绑定即时校验，版本级兼容实时查证 |
| 动态调研 | 每层候选展示前执行 `web_search` 动态调研，文档表格仅为参考基线 |
| 安全扫描 | SAST / 依赖漏洞 / 容器镜像 / DAST 多维度安全扫描推荐 |
| Core + DDD 架构 | 前后端分离的 Core 结构、DDD 业务模块、复用红线 |
| ADR 决策记录 | 重要决策留痕，AI 换会话不失忆 |
| 分级生命周期 | S/M 低风险项目可裁剪流程；L 级或高风险项目执行完整六阶段及安全、发布门禁 |
| 开箱模板 | 按项目级别生成 `.agent/` 文件、根目录 `docs/adr/`、ADR 模板和 README 模板 |

### 支持的 AI Agent

OpenAI Codex · Claude Code · CodeBuddy · Cursor Agent · OpenCode · Devin 类 Agent

### 安装

```bash
# Claude Code
cp -r skills/project-architecture ~/.claude/skills/

# CodeBuddy
cp -r skills/project-architecture ~/.codebuddy/skills/
```

或在项目级 `.claude/skills/` / `.codebuddy/skills/` 下安装，仅对当前项目生效。

### 使用

安装后直接对 AI 说：

- "我想做一个宠物寄养小程序，我不懂技术"（触发引导模式）
- "这是我们的产品 PRD，帮我立项"（触发产品模式）
- "帮我初始化一个 React + NestJS 的中后台项目"（触发专家模式）
- "分析一下这个仓库的技术栈并给出优化建议"（触发反向分析）

### 仓库结构

```
project-architecture-skill/
├── skills/
│   ├── project-architecture/      # 中文版 Skill
│   │   ├── SKILL.md               # 主入口：模式识别、规模分级、执行协议
│   │   ├── references/            # 技术选型指南 / 架构设计 / 开发生命周期
│   │   ├── templates/             # .agent 四件套、ADR、README 模板
│   │   └── README.md
│   └── project-architecture-en/   # English version
│       └── ...
├── CHANGELOG.md                    # 版本变更记录
├── CONTRIBUTING.md                 # 贡献指南
├── LICENSE                         # MIT
└── README.md                       # 本文件
```

详细文档见 [skills/project-architecture/README.md](skills/project-architecture/README.md)。

---

<a id="english"></a>

## Make AI Coding Agents work like senior architects

An open-source Skill: from "I want to build X" to an enterprise-grade, long-term maintainable project structure.

### The problem

More people than ever code with AI, but AI-generated projects share common flaws:

- **One-line requirement → instant code dump** — no business analysis, no tech selection
- **No architecture at all** — everything piles up; rot begins at the second iteration
- **Reinventing the wheel** — every module gets its own HTTP wrapper and error handling
- **Arbitrary tech choices** — stale versions, incompatible combinations
- **No continuity** — a new AI session means total amnesia

This Skill encodes a senior architect's working method as an enforceable protocol for AI Agents.

### Core capabilities

| Capability | Description |
|-----------|-------------|
| Three user modes | Fully-guided for beginners / business modeling for PMs / fast-track for developers |
| Scale tiers | S/M/L classification with risk-aware gates; small projects avoid big architectures and high-risk projects are not underestimated |
| Interactive checkbox selection | Uses `ask_followup_question` for one decision at a time; next candidates are researched from accumulated context |
| Multi-select compatibility evaluation | Each layer defaults to single-select; after AI evaluation, multi-select can be opened — non-conflicting options can combine (e.g., Axios + fetch), Core layer encapsulates each separately |
| Capability awareness | Detects built-in capabilities and offers “use built-in,” standalone, or `None (not needed)`; never silently skips a user decision |
| Layered linkage recommendations | Earlier choices filter later candidates; companion plugins are recommended as needed and confirmed by the user |
| Compatibility matrices | Instant structural checks; version-level compatibility verified live |
| Dynamic research | Mandatory `web_search` before presenting candidates at each layer; document tables are only a reference baseline |
| Security scanning | SAST / dependency vulnerability / container image / DAST multi-dimensional security scanning recommendations |
| Core + DDD architecture | Separate Core structures for FE & BE, DDD modules, reuse red lines |
| ADR decision records | Decisions persist across AI sessions |
| Tiered lifecycle | Tier S/M low-risk projects may use a trimmed lifecycle; Tier L or high-risk projects use all six phases plus security and release gates |
| Ready-to-use templates | Tier-appropriate `.agent/` files, root `docs/adr/`, ADR template, and README template |

### Supported AI Agents

OpenAI Codex · Claude Code · CodeBuddy · Cursor Agent · OpenCode · Devin-like agents

### Installation

```bash
# Claude Code
cp -r skills/project-architecture-en ~/.claude/skills/project-architecture

# CodeBuddy
cp -r skills/project-architecture-en ~/.codebuddy/skills/project-architecture
```

### Usage

- "I want to build a pet-boarding app, and I'm not technical" (Guided mode)
- "Here's our product PRD — help me bootstrap the project" (Product mode)
- "Initialize a React + NestJS admin project" (Expert mode)
- "Analyze this repo's tech stack and suggest improvements" (reverse analysis)

Full docs: [skills/project-architecture-en/README.md](skills/project-architecture-en/README.md).

---

## License

[MIT](LICENSE)
