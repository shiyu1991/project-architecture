# project-architecture

让 AI Coding Agent 像资深架构师一样工作的 Skill：从一句"我想做个 XX"到可长期维护的企业级项目结构。

## 解决什么问题

用 AI 写代码的人越来越多，但 AI 生成项目的通病是：

- **一句话需求直接糊代码** — 不分析业务、不做选型，上来就是 Vue + SpringBoot
- **没有架构概念** — 所有代码堆在一起，第二次迭代就开始腐烂
- **重复造轮子** — 每个模块各写一套请求封装、错误处理、工具函数
- **技术选型拍脑袋** — 推荐过时版本、不兼容组合、为炫技上复杂方案
- **无法持续协作** — 换个 AI 会话就失忆，没有文档、没有决策记录

本 Skill 把资深架构师的工作方法固化为 AI Agent 的强制执行协议。

## 核心能力

| 能力 | 说明 |
|------|------|
| 三档用户模式 | 技术小白全程引导 / 产品经理业务建模 / 开发者快速过层，自动识别 |
| 规模分级 | S/M/L 三级判定，小项目不套大架构，反过度工程 |
| 交互式勾选选型 | 每轮使用 `ask_followup_question` 只询问一个问题；用户确认后重新动态调研并生成下一轮候选 |
| 多选兼容评估 | 每层默认单选，AI 每次根据最新上下文重新评估是否可多选；框架或库通常展示 5-8 个候选，插件通常展示 3-5 个候选 |
| 能力覆盖感知 | 动态检测已选框架自带能力，标注“已覆盖”，但仍让用户明确选择“使用内置”、独立方案或“无（暂不需要）” |
| 双触发配套推荐 | 每次选择后即时评估扩展；前端和后端基础选型收尾时，再基于完整技术栈动态推荐约 5 个配套插件，确认后才进入下一阶段 |
| 兼容性矩阵 | 结构性绑定即时校验，版本级兼容实时查证 |
| Core + DDD 架构 | 前后端分离的 Core 结构、DDD 业务模块、复用红线 |
| ADR 决策记录 | 重要决策留痕，AI 换会话不失忆 |
| 6 阶段生命周期 | 理解 → 分析 → 设计 → 实现 → 验证 → 总结 |
| 开箱模板 | `.agent/` 四件套、ADR 模板、README 模板，初始化即用 |

## 支持的 AI Agent

OpenAI Codex · Claude Code · CodeBuddy · Cursor Agent · OpenCode · Devin 类 Agent

## 安装

将整个 `project-architecture/` 目录复制到你的 Agent skills 目录：

```bash
# Claude Code
cp -r project-architecture ~/.claude/skills/

# CodeBuddy
cp -r project-architecture ~/.codebuddy/skills/
```

或在项目级 `.claude/skills/` / `.codebuddy/skills/` 下安装，仅对当前项目生效。

## 使用

安装后直接对 AI 说：

- "我想做一个宠物寄养小程序，我不懂技术"（触发引导模式）
- "这是我们的产品 PRD，帮我立项"（触发产品模式）
- "帮我初始化一个 React + NestJS 的中后台项目"（触发专家模式）
- "分析一下这个仓库的技术栈并给出优化建议"（触发反向分析）

## 目录结构

```
project-architecture/
├── SKILL.md                        # 主入口：模式识别、规模分级、执行协议
├── references/
│   ├── tech-stack-guide.md         # 技术选型详细指南（前后端 12 层 × Top 3）
│   ├── architecture-design.md      # Core / DDD / ADR 架构设计细节
│   └── dev-lifecycle.md            # 6 阶段生命周期、Git 工作流、测试安全规范
├── templates/
│   ├── agent-context.md            # .agent/context.md 模板
│   ├── agent-architecture.md       # .agent/architecture.md 模板
│   ├── agent-coding-rule.md        # .agent/coding-rule.md 模板
│   ├── agent-workflow.md           # .agent/workflow.md 模板
│   ├── adr-template.md             # 架构决策记录模板
│   ├── domain-model-template.md    # 领域模型草图模板（产品模式用）
│   └── project-readme-template.md  # 项目 README 模板
└── README.md
```

## 设计哲学

1. **先理解，再设计；先架构，再编码** — 禁止一句话需求直接生成完整功能
2. **版本不写死** — 所有版本号选型时实时查询，文档永远不过期
3. **交互式选型** — 每轮只询问一个问题，用户确认后重新调研并动态生成下一轮候选；多选兼容评估让不冲突的方案可组合使用
4. **配套收尾** — 前端和后端基础层级结束时分别动态推荐约 5 个兼容插件或工具，用户确认后才切换阶段
5. **能力感知** — 动态识别框架自带能力，提供“使用内置”、独立方案和“无（暂不需要）”供用户确认，不自动跳过
6. **用户有最终决定权** — AI 只做兼容性提示，不强制覆盖用户选择
7. **小项目不套大架构** — 能 50 行解决的不写 200 行

## License

MIT
