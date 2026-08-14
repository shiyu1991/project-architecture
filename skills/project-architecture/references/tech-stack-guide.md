# 技术选型指南

> 项目初始化时进行技术选型的详细参考文档。
> 在执行技术选型或分析现有项目技术栈时加载本文档。

---

## 0. 动态决策协议（最高优先级）

本文档提供的是**候选方案与选择标准**，不是固定答案。AI Agent 必须遵守以下四条协议：

### 0.1 版本动态解析

- 本文档**故意不写死版本号**，防止推荐过期。
- 方案确定后，必须实时查询最新稳定版本：

| 生态 | 查询方式 |
|------|----------|
| Node | `npm view <package> version` |
| Java | Maven Central / mvnrepository.com |
| Go | `go list -m -versions <module>` / proxy.golang.org |
| Python | PyPI / pypi.org |

- 运行时（Node.js、JDK、Go、Python）一律选择**当前 LTS**。
- 刚发布的大版本建议观察 3 个月以上再用于生产。

### 0.2 上下文信号选择

同层候选之间根据以下信号决策，并向用户说明理由：

- **项目类型** — 中后台 / C 端应用 / API 服务 / 内容站 / AI 应用
- **团队背景** — 已有技术栈、语言偏好、维护能力
- **地区与语言** — 国内团队倾向中文文档完善的方案；国际化产品倾向全球主流方案
- **规模与性能** — 小型项目选轻量；高并发选性能优先
- **存量依赖** — 已有项目按现有生态延伸，不强行切换

### 0.3 兼容性实时验证

- 文中兼容性矩阵仅标注**结构性绑定**（长期不变的关系，如 Pinia 仅支持 Vue）。
- 版本级兼容性（插件支持的主框架版本范围），选择时查阅 `peerDependencies` 或官方文档实时确认。

### 0.4 候选方案动态调研（强制）

本文档中的候选方案表格是**编写时的参考基线**，不是封闭列表。技术生态持续演进，AI Agent 在选型时必须进行动态调研：

**强制调研流程：**

1. **实时搜索** — 在展示候选方案前，AI Agent 必须使用 `web_search` 工具搜索该层级的当前主流方案，查询关键词示例：
   - `"best [层级名称] framework 2025"`（如 `best Vue state management 2025`）
   - `"[技术名] alternatives 2025"`（如 `Prisma alternatives 2025`）
   - `"[层级] ecosystem trends"`（如 `frontend build tools trends`）

2. **合并候选** — 将搜索结果与文档中的参考基线合并：
   - 文档基线中的方案保留（除非搜索显示已废弃/维护停止）
   - 搜索发现的新兴方案加入候选（标注"新兴"）
   - 搜索显示已过时的方案从候选中移除或标注"已过时"

3. **活跃度验证** — 对每个候选方案验证活跃度：
   - GitHub star 数和近期 commit 频率
   - 最新版本发布时间（超过 1 年未更新标注"维护停滞"）
   - 社区讨论热度（npm 下载量 / Stack Overflow 活跃度）

4. **候选展示** — 最终向用户展示的候选列表为动态合并后的结果，每项标注：
   - "推荐" + 一句话理由（基于当前上下文和搜索结果）
   - "新兴"（搜索发现的冉冉升起的新方案）
   - "已过时"（不再活跃的旧方案，仅保留供参考）

**调研频率（强制）：**
- 每次用户确认一个选项后，下一次提问前都必须重新执行 `web_search`
- 搜索上下文必须包含全部已选技术、项目类型、规模、约束和刚确认的选项
- 不得因候选层级相同而复用旧结果；技术生态、版本和插件兼容性必须按当前上下文重新判断
- 调研结果只用于当前选型会话，不写入 skill 文档

**示例：**
```
# Layer 7: 状态管理（Vue 生态）

# AI Agent 执行 web_search: "best Vue state management 2025"
# 搜索结果：Pinia 仍为主流推荐，Vue 官方维护；新出现 X 状态管理库

# 合并后展示给用户：
options: [
  "Pinia（推荐：Vue 官方推荐、TypeScript 友好、生态最成熟）",
  "X 库（新兴：2025 年新方案，主打 XX 特性）",
  "Vuex（已过时：官方已推荐迁移到 Pinia，仅遗留项目使用）"
]
```

**关键原则：** 文档中的表格是"起点"不是"终点"。AI Agent 有责任确保推荐给用户的是当前最新的技术格局，而非文档编写时的快照。

---

## 1. 选型原则

技术选择必须综合考虑：

- **业务规模** — 根据实际需求选择技术，而非假设的规模
- **团队能力** — 选择团队能够维护的技术栈
- **维护成本** — 考虑长期运维负担
- **生态成熟度** — 优先选择成熟、活跃维护的技术
- **性能需求** — 基于真实性能需求选择
- **扩展性** — 确保架构能随业务增长
- **部署成本** — 考虑基础设施和运维复杂度

**禁止：** 为了"先进"而选择复杂技术。

### 分层选择原则（默认单选，AI 评估后可多选）

- 按**层级顺序**逐步选择，前序选择影响后序可选项
- 同一层级内**默认单选**；但 AI Agent 必须按「0.5 多选兼容评估协议」评估该层级是否适合多选
- 若评估结论为"可多选且多选能带来兼容性/稳定性收益"，该层级以 `multiSelect: true` 呈现给用户，让用户自行决定是否勾选多个
- 若评估结论为"互斥"（多选会冲突或无收益），该层级保持 `multiSelect: false` 单选
- 每次只生成 **3-5 个独立候选**（数量根据上下文和搜索结果动态决定，不保证固定 Top 3）
- 非必要层级、可选插件和扩展必须额外提供 `无（暂不需要）`
- 必要能力不得用“无”替代，若框架已内置则提供“使用内置能力”作为独立选项
- 用户可跳过推荐，自主输入任意方案；AI Agent 仅做兼容性提示，不强制覆盖

### 0.5 多选兼容评估协议（强制）

> **核心目标：** 放开"互斥选一"的硬性约束。当同一层级的多个方案不冲突，且各自有不可替代的长处时，允许用户多选并对各方案分别封装，取长补短，提升系统的兼容性和稳定性。AI Agent 必须对每个层级进行多选可行性评估。

#### 评估流程（每个层级展示候选前必须执行）

1. **冲突检测** — 该层级的候选方案之间是否存在结构性冲突？
   - 存在冲突（如 Vue 与 React 无法共存）→ 标注"互斥，仅可单选"，`multiSelect: false`
   - 不存在冲突 → 进入第 2 步
2. **互补性评估** — 多选是否能带来不可替代的收益？
   - 有互补收益（如 axios 擅长上传/下载进度监控，fetch 擅长 SSE/流式响应）→ 标注"可多选，取长补短"，`multiSelect: true`
   - 无互补收益（功能完全重叠，多选只是冗余）→ 标注"建议单选"，`multiSelect: false`
3. **封装要求** — 当用户多选后，AI Agent 必须在 Core 层为每个方案提供独立封装，并通过统一接口对外暴露，业务模块只调用 Core 接口，不直接依赖具体方案

#### 多选时的强制封装规范

当某层级被用户多选后，AI Agent 在项目初始化和后续开发中必须遵守：

- **Core 层独立封装** — 每个被选方案在 `core/` 下有独立封装模块（如 `core/http/axios.ts`、`core/http/fetch.ts`）
- **统一对外接口** — 通过 `core/http/index.ts` 暴露统一接口，业务模块只依赖接口，不直接依赖具体实现
- **按场景路由** — 封装层根据请求特性自动选择最合适的底层方案（如上传/下载用 axios，SSE/流式用 fetch）
- **ADR 记录** — 多选决策必须记录 ADR，说明每个方案的职责分工和路由规则
- **禁止业务层直连** — 业务模块禁止直接 import axios 或 fetch，必须通过 Core 封装接口调用

#### 典型可多选层级示例

| 层级 | 可多选组合 | 互补理由 | 封装策略 |
|------|-----------|----------|----------|
| 前端-网络请求库 | Axios + 原生 fetch | Axios 擅长拦截器、上传/下载进度监控、超时控制；fetch 擅长 SSE、流式响应、Service Worker 集成 | Core 层统一 `request()` 接口，按 Content-Type 和场景自动路由 |
| 前端-测试框架 | Vitest + Playwright | Vitest 负责单元/组件测试，Playwright 负责 E2E 跨浏览器测试 | 各自独立配置，互不干扰 |
| 前端-CSS 方案 | TailwindCSS + CSS Modules | TailwindCSS 负责原子化快速布局，CSS Modules 负责组件级样式隔离 | 主方案为 TailwindCSS，局部用 CSS Modules |
| 后端-API 规范 | RESTful + gRPC | RESTful 对外前端友好，gRPC 微服务内部高性能通信 | 对外网关暴露 RESTful，内部服务间用 gRPC |
| 后端-缓存 | Redis + 进程内缓存 | Redis 负责分布式共享缓存，进程内缓存负责单机高频读 | 二级缓存策略，先查进程内再查 Redis |
| 后端-文件存储 | S3/OSS + 本地存储 | 云存储负责持久化和 CDN，本地存储负责临时文件和缓存 | 分级存储，按文件类型路由 |
| 后端-认证 | JWT + Session | JWT 用于无状态 API 认证，Session 用于需要强制下线的传统 Web 场景 | 双认证通道，按路由区分 |

#### 典型互斥层级（不可多选）

| 层级 | 互斥理由 |
|------|----------|
| 前端-主框架 | Vue/React/Svelte 运行时互斥，无法共存 |
| 前端-开发语言 | TypeScript 是 JavaScript 的超集，二选一即可 |
| 前端-UI 组件库 | 同一项目混用多个 UI 库会导致样式冲突和包体膨胀 |
| 前端-状态管理 | 多套状态管理会导致数据流混乱 |
| 前端-路由 | 多套路由系统会冲突 |
| 后端-运行时 | 一个后端服务通常只使用一个主运行时 |
| 后端-开发语言 | 一个后端服务只选择一种主开发语言 |
| 后端-框架 | 同一服务不能同时跑 Spring Boot 和 NestJS |
| 后端-数据库（主库） | 主数据库只能一个，辅助库（Redis/ES）不算多选 |
| 后端-ORM | 多套 ORM 操作同一数据库会导致数据模型混乱 |

#### 评估结果展示规范

AI Agent 在展示候选时，必须在 header 或选项说明中标注评估结论：

```
# 可多选的层级
ask_followup_question({
  questions: [{
    question: "前端-网络请求库？（可多选：Axios 擅长进度监控，fetch 擅长 SSE/流式，多选时 Core 层统一封装按场景路由）",
    header: "前端-网络请求库",
    multiSelect: true,
    options: [
      "Axios（推荐：拦截器、上传/下载进度、超时控制）",
      "原生 fetch 封装（推荐：SSE、流式响应、零依赖）",
      "TanStack Query（数据缓存与同步）"
    ]
  }]
})

# 互斥的层级
ask_followup_question({
  questions: [{
    question: "前端-主框架？（互斥，仅可单选：Vue/React/Svelte 运行时无法共存）",
    header: "前端-主框架",
    multiSelect: false,
    options: [...]
  }]
})
```

**关键原则：** 多选不是默认行为，而是 AI Agent 评估后的推荐。最终是否多选仍由用户决定。即使 AI 评估为"可多选"，用户也可以只选一个。

### 交互式选型原则（强制）

- AI Agent **必须使用 `ask_followup_question` 工具**让用户通过勾选完成选型，禁止仅用文字表格让用户口头确认
- 选型分四阶段导航：阶段一核心跨端项，阶段二前端层级，阶段三后端层级，阶段四跨端关注点；插件和扩展采用双触发推荐：每次选择后即时评估，且每一端基础层级结束时必须再做一次收尾推荐
- **前端和后端选型必须分离**：先完整选完前端所有基础层级和前端收尾配套推荐，再选后端所有基础层级和后端收尾配套推荐；禁止同一轮问题混合前后端层级，且每轮只能包含一个问题
- **所有问题 header 必须带"前端-"或"后端-"前缀**（阶段一全局决策除外），避免用户混淆
- **多选兼容评估（强制）**：每层展示候选前，AI Agent 必须按「0.5 多选兼容评估协议」评估该层是否适合多选；评估为"可多选"的层级以 `multiSelect: true` 呈现，评估为"互斥"的层级以 `multiSelect: false` 呈现
- 配套插件以**多选勾选**形式展示，用户按需勾选
- 每个选项标注"推荐"标签和一句话说明，降低决策成本

### 选择权原则（最高优先级，强制）

- **AI Agent 只给出推荐，不代替用户选择。** 除非用户明确要求"你帮我自动选择"，否则每一层都必须让用户自行勾选确认
- **禁止自动填充**任何层级的选择（即使看起来是"显而易见"的选择）
- **禁止自动锁定**任何层级（即使框架生态只有一个主流方案）
- **禁止跳过**任何层级不询问用户（即使已选框架已覆盖该能力）
- 推荐项仅通过标注"推荐"提示，不代替用户勾选
- 用户可随时说"剩下的你帮我自动选择"来授权 AI 选择，但 AI 仍需逐次说明并确认每个动态推荐

### 能力覆盖感知原则（强制）

- 用户选择某框架后，AI Agent **必须检查该框架是否已覆盖后续某层能力**
- 若已覆盖：该层仍需询问用户，但将"使用内置"作为推荐项标注"已覆盖"
- 若用户需求超出内置能力：推荐独立方案，并标注"内置能力不足时选择"
- 详见第 2.3 节「框架能力覆盖矩阵」

---

## 2. 前端技术选型 — 分层选择流程（默认单选，AI 评估后可多选）

> **强制规则：** 前端选型必须在阶段二完整完成所有层级后，才进入阶段三后端选型。禁止前后端层级混批。每层默认单选，AI Agent 必须按「0.5 多选兼容评估协议」评估该层是否适合多选。

### 选择流程图

```
Layer 1: 前端-主框架      →  Layer 2: 前端-开发语言   →  Layer 3: 前端-构建工具
                                                      ↓
Layer 4: 前端-UI 组件库   →  Layer 5: 前端-CSS 方案   →  Layer 6: 前端-网络请求库
                                                      ↓
Layer 7: 前端-状态管理    →  Layer 8: 前端-路由       →  Layer 9: 前端-表单验证
                                                      ↓
Layer 10: 前端-测试框架   →  Layer 11: 前端-代码质量   →  Layer 12: 前端-国际化（按需）
```

**规则：** 从 Layer 1 开始逐层选择，前序选择影响后序推荐。每层默认单选，AI Agent 按「0.5 多选兼容评估协议」评估后可开放多选。Layer 12 完成后不是直接进入后端，而是先执行“前端-配套插件推荐”收尾问题；用户确认后才结束前端阶段。

---

### Layer 1: 主框架（互斥，仅可单选）

| 方案 | 特点 | 适用场景 |
|------|------|----------|
| React | 生态最大、社区最强、Meta 维护 | 大型应用、复杂交互、国际化产品 |
| Vue | 上手快、中文文档优秀、模板语法直观 | 企业后台、管理系统、国内团队 |
| Svelte | 编译时优化、无虚拟 DOM、包体最小 | 高性能轻量应用、个人项目 |

**选择信号：** 中后台 / 国内团队 / 快速交付 → 倾向 Vue；大型复杂交互 / 国际化 → 倾向 React；极致性能 / 小团队 → 倾向 Svelte。

**多选评估：** ❌ 互斥 — Vue/React/Svelte 运行时无法共存，仅可单选。

**用户自定义：** 可输入其他框架（如 Solid、Qwik、Angular），AI Agent 仅做兼容性提示。

---

### Layer 2: 开发语言（互斥，仅可单选）

| 方案 | 特点 | 适用场景 |
|------|------|----------|
| TypeScript | 类型安全、IDE 智能提示、重构友好 | 所有正式项目（默认推荐） |
| JavaScript | 无编译开销、学习门槛低 | 小型项目、快速原型、学习用途 |

**选择信号：** 除非是极小型项目或纯学习用途，一律推荐 TypeScript。

---

### Layer 3: 构建工具（互斥，仅可单选）

| 方案 | 特点 | 适用场景 |
|------|------|----------|
| Vite | 极速 HMR、开箱即用、Vue/React 官方推荐 | 所有新项目（默认推荐） |
| Webpack | 生态最成熟、插件最丰富 | 遗留项目、特殊构建需求 |
| Turbopack | Rust 实现、Next.js 内置、构建极快 | Next.js 项目 |

**选择信号：** 普通 SPA/MPA → Vite；Next.js 项目 → Turbopack（Next 内置）；存量 Webpack 项目不强行迁移。

**兼容性提示：** Turbopack 与 Next.js 深度绑定，非 Next.js 场景选择前需验证生态支持（按 0.3 协议）。

---

### Layer 4: UI 组件库（根据主框架推荐）

#### Vue 生态

| 方案 | 特点 | 适用场景 |
|------|------|----------|
| Element Plus | Vue 3 生态成熟、中文社区大、组件全 | 企业后台、管理系统、国内团队 |
| Naive UI | TypeScript 原生、主题系统强大 | 定制化需求、TypeScript 项目 |
| Ant Design Vue | Ant Design 的 Vue 实现、设计规范完善 | 偏好 Ant Design 风格 |

#### React 生态

| 方案 | 特点 | 适用场景 |
|------|------|----------|
| Ant Design | 企业级 UI 库、组件全、中文文档好 | 企业后台、管理系统 |
| shadcn/ui | 基于 Radix UI、源码入项目、完全可定制 | 现代设计、高度定制需求 |
| MUI | Material Design 实现、国际化支持好 | 国际化产品、Material 风格 |

#### Svelte 生态

| 方案 | 特点 | 适用场景 |
|------|------|----------|
| shadcn-svelte | shadcn/ui 的 Svelte 版本、可定制 | 现代设计、定制需求 |
| Skeleton | TailwindCSS 驱动、主题系统 | TailwindCSS 项目 |
| Flowbite Svelte | 开箱即用、组件丰富 | 快速开发 |

**选择信号：** 国内企业后台 → Element Plus / Ant Design；国际化或强定制 → shadcn/ui 系；跟随 Material 设计体系 → MUI。

**多选评估：** ❌ 互斥 — 混用多个 UI 库会导致样式冲突和包体膨胀，仅可单选。

---

### Layer 5: CSS 方案（可多选，取长补短）

| 方案 | 特点 | 适用场景 |
|------|------|----------|
| TailwindCSS | 原子化 CSS、开发效率高、包体可控 | 所有项目（默认推荐） |
| CSS Modules | 局部作用域、构建工具原生支持、零依赖 | 简单样式隔离需求 |
| CSS-in-JS（styled-components / Emotion 等） | 动态样式、组件级封装 | React 动态主题需求 |

**选择信号：** 默认 TailwindCSS；选择具体 CSS-in-JS 库前按 0.1/0.3 协议验证其维护状态（部分库已进入维护模式）。

**多选评估：** ✅ 可多选 — TailwindCSS（原子化快速布局）+ CSS Modules（组件级样式隔离）不冲突，可组合使用。多选时须在 Core 层声明主方案，另一方案仅用于特定场景。`multiSelect: true`

---

### Layer 6: 网络请求库（可多选，取长补短）

| 方案 | 特点 | 适用场景 |
|------|------|----------|
| Axios | 拦截器机制、请求/响应转换、上传/下载进度监控、超时控制、社区最大 | 所有项目（通用首选） |
| TanStack Query | 数据获取/缓存/同步一体化、自动重试 | 数据驱动应用、需要缓存策略 |
| 原生 fetch 封装 | 零依赖、完全可控、轻量、SSE/流式响应友好、Service Worker 集成 | 极简项目、特殊请求需求 |

**多选评估：** ✅ 可多选 — Axios 与原生 fetch 不冲突，各自有不可替代的长处：
- **Axios 擅长：** 上传/下载进度监控、请求/响应拦截器、自动 JSON 转换、超时控制、取消请求
- **fetch 擅长：** SSE（Server-Sent Events）、流式响应（ReadableStream）、Service Worker 集成、零依赖
- **TanStack Query** 可与上述任一组合，负责数据缓存与同步层

**多选时封装规范（强制）：**
```
core/http/
├── axios.ts          # Axios 封装：拦截器、进度监控、超时
├── fetch.ts          # fetch 封装：SSE、流式响应、Service Worker
├── query.ts          # TanStack Query 配置（如选择）
└── index.ts          # 统一对外接口，按场景自动路由
```
- 业务模块只调用 `core/http` 暴露的统一接口，不直接 import axios 或 fetch
- 封装层根据请求特性自动路由：上传/下载 → Axios；SSE/流式 → fetch；普通请求 → 默认方案
- 多选决策必须记录 ADR，说明各方案职责分工和路由规则

**单选时：** 选择一个作为主方案即可。`multiSelect: true`

---

### Layer 7: 状态管理（根据主框架推荐）

#### Vue 生态

| 方案 | 特点 | 适用场景 |
|------|------|----------|
| Pinia | Vue 官方推荐、TypeScript 友好、DevTools 集成 | 所有 Vue 项目（默认） |
| Vuex | 老牌方案、存量项目兼容 | 遗留 Vue 项目维护 |
| 简单 ref/reactive | 无额外依赖、极简 | 小型项目、局部状态 |

#### React 生态

| 方案 | 特点 | 适用场景 |
|------|------|----------|
| Zustand | 极简 API、无样板代码、TS 友好、包体小 | 中小型项目（默认推荐） |
| Redux Toolkit | 企业级、DevTools 强大、中间件生态丰富 | 大型项目、复杂状态流 |
| Jotai | 原子化状态、细粒度更新 | 细粒度状态管理需求 |

#### Svelte 生态

| 方案 | 特点 | 适用场景 |
|------|------|----------|
| Svelte Stores（内置） | 官方内置、零依赖、响应式 | 所有 Svelte 项目（默认） |
| 自定义 store 扩展 | 灵活封装自定义逻辑 | 复杂状态需求 |
| XState | 状态机、复杂流程控制 | 复杂状态流转 |

**选择信号：** Vue → Pinia 基本无争议；React 中小型 → Zustand，大型 / 多人协作复杂状态 → Redux Toolkit。

**多选评估：** ❌ 互斥 — 多套状态管理会导致数据流混乱，仅可单选。（注：局部 ref/reactive 与全局状态库不算多选，是不同层级的关注点）

---

### Layer 8: 路由（根据主框架推荐）

#### Vue 生态

| 方案 | 特点 | 适用场景 |
|------|------|----------|
| Vue Router | Vue 官方路由、功能完整、文档完善 | 所有 Vue 项目（默认） |
| unplugin-vue-router | 文件路由、类型安全路由 | 约定式路由偏好 |
| TanStack Router（Vue 版） | 类型安全、搜索参数状态管理 | 强类型路由需求 |

#### React 生态

| 方案 | 特点 | 适用场景 |
|------|------|----------|
| React Router | React 生态最成熟路由、支持 SSR | SPA 应用（默认） |
| Next.js App Router | 文件路由、SSR/SSG、全栈能力 | Next.js 项目 |
| TanStack Router（React 版） | 类型安全、搜索参数状态管理 | 强类型路由需求 |

#### Svelte 生态

| 方案 | 特点 | 适用场景 |
|------|------|----------|
| SvelteKit 内置路由 | 官方全栈框架、文件路由 | SvelteKit 项目（默认） |
| svelte-spa-router | 轻量 SPA 路由 | 纯 SPA 项目 |
| TanStack Router（Svelte 版） | 类型安全 | 强类型路由需求 |

**多选评估：** ❌ 互斥 — 多套路由系统会冲突，仅可单选。

---

### Layer 9: 表单验证（可能被 UI 组件库覆盖）

> **能力覆盖提示：** 以下 UI 组件库自带表单验证能力，选择后应动态标记“已覆盖”，但不得默认跳过；仍需询问用户选择“使用内置”、独立方案或“无（暂不需要）”：
> - **Element Plus** — 内置 `el-form` 验证规则，支持必填、长度、自定义校验器
> - **Ant Design** — 内置 `Form` 组件验证，支持声明式规则
> - **Naive UI** — 内置 `n-form` 验证，支持自定义校验
> - **Ant Design Vue** — 内置表单验证，与 Ant Design 一致
>
> **仅当以下情况需要独立表单验证库：**
> - 跨组件/跨表单的复杂联动验证
> - 需要 Schema 级别的类型推断（TypeScript 项目）
> - 需要前后端共享验证 Schema

| 方案 | 特点 | 适用场景 | 能力覆盖状态 |
|------|------|----------|-------------|
| 使用 UI 库内置验证 | 零额外依赖、与组件深度集成 | 大多数项目（默认推荐） | Element Plus / Ant Design / Naive UI 已覆盖 |
| Zod | Schema 验证、TypeScript 推断、框架无关 | 需要前后端共享 Schema、类型推断 | 独立方案，内置不足时选择 |
| React Hook Form | React 高性能表单状态管理 | React 项目复杂表单 | 独立选项，可与用户另选的 Zod 配合 |
| VeeValidate | Vue 生态表单验证 | Vue 项目复杂表单 | 独立选项，可与用户另选的 Zod 配合 |

**多选评估：** ✅ 可多选 — "使用 UI 库内置验证" + "Zod（Schema 验证）"不冲突。UI 库内置验证负责组件级即时校验，Zod 负责前后端共享 Schema 和类型推断。多选时 Core 层封装统一验证接口。`multiSelect: true`

**交互式勾选示例：**
```
options: [
  "使用 Element Plus 内置验证（推荐，已覆盖）",
  "VeeValidate（复杂 Vue 表单状态管理，可与另选的 Zod 配合）",
  "Zod（仅 Schema 验证，前后端共享）"
],
header: "前端-表单验证"
```

**搭配建议：** 简单表单用 UI 库内置验证；复杂表单 React 项目推荐 React Hook Form + Zod，Vue 项目推荐 VeeValidate + Zod。

---

### Layer 10: 测试框架（可多选，单元 + E2E 组合）

| 方案 | 特点 | 适用场景 |
|------|------|----------|
| Vitest | Vite 原生、极快、API 兼容 Jest、零配置 | Vite 项目（默认推荐） |
| Jest | 生态最成熟、社区最大、存量项目多 | 非 Vite 项目、遗留项目 |
| Playwright | E2E 测试、跨浏览器、自动等待 | E2E 测试需求 |

**多选评估：** ✅ 可多选 — 单元测试框架（Vitest/Jest）与 E2E 测试框架（Playwright）职责不同，可组合使用。主流组合：Vitest（单元/组件）+ Playwright（E2E）。但 Vitest 与 Jest 互斥（同为单元测试框架，二选一）。`multiSelect: true`

---

### Layer 11: 代码质量工具（默认启用）

| 方案 | 特点 | 适用场景 |
|------|------|----------|
| ESLint | 行业标准 Lint、生态最大、规则丰富、IDE 集成好 | 需要成熟规则生态的项目 |
| Prettier | 专注代码格式化、跨语言一致 | 可与用户另选的 ESLint 配合 |
| Biome | Rust 实现、极快、Lint 与 Format 一体化 | 追求极致速度、新项目 |
| oxlint | Rust 实现、兼容 ESLint 规则 | 大型项目、性能优先 |

**多选评估：** ⚠️ 条件可多选 — ESLint 与 Prettier 职责互补，可由用户分别勾选；Biome 与其他 Lint/Format 主方案通常互斥。不得把 `ESLint + Prettier` 写成一个固定候选。

**搭配建议：** TypeScript 项目加 `@typescript-eslint`；TailwindCSS 项目加官方类名排序插件。

---

### Layer 12: 国际化方案（按需，可跳过）

| 方案 | 特点 | 适用场景 |
|------|------|----------|
| vue-i18n | Vue 官方推荐、Composition API 支持 | Vue 项目 |
| react-intl | ICU MessageFormat、React 生态标准 | React 项目 |
| i18next | 框架无关、生态最大 | 通用、跨框架 |

**多选评估：** ❌ 互斥 — 多套 i18n 方案会导致翻译 key 管理混乱，仅可单选。

**跳过条件：** 纯单语言项目可选择"暂不需要"。

**搭配建议：** 需要翻译 key 自动提取时，i18next 系用 `i18next-parser`，react-intl 系用 `@formatjs/cli`。

---

### 移动端技术

移动端选型独立于前端 Web 选型流程。当项目类型判定为"小程序 / 移动端"时，使用以下逐层选型流程：

#### 移动端 Layer 1: 跨平台框架（互斥选一）

| 方案 | 特点 | 适用场景 |
|------|------|----------|
| UniApp | Vue 语法、小程序 + APP + H5 全覆盖、国内生态 | 国内小程序、多端发布（默认推荐） |
| Flutter | 跨平台、高性能 UI、Dart 语言 | 高性能跨平台 APP |
| React Native | JS/TS 团队、跨平台、React 生态 | JS/TS 团队、跨平台 APP |
| Android Native | Android 优先、最大平台集成 | Android 优先 |
| iOS Native | iOS 优先、最大平台集成 | iOS 优先 |

#### 移动端 Layer 2: 开发语言（根据框架推荐）

| 框架 | 语言 | 说明 |
|------|------|------|
| UniApp | JavaScript、TypeScript | 在独立语言问题中单选，与 Web 前端 Vue 生态一致 |
| Flutter | Dart | Flutter 专用语言 |
| React Native | JavaScript、TypeScript | 在独立语言问题中单选，与 Web 前端 React 生态一致 |
| Android Native | Kotlin、Java | 在独立语言问题中单选，Kotlin 为 Google 推荐 |
| iOS Native | Swift、Objective-C | 在独立语言问题中单选，Swift 为 Apple 推荐 |

#### 移动端 Layer 3: UI 组件库（根据框架推荐）

| 框架 | UI 组件库 | 说明 |
|------|----------|------|
| UniApp | uView / uni-ui / Vant Weapp | uView 组件全、uni-ui 官方、Vant 适合微信小程序 |
| Flutter | Material / Cupertino | Flutter 内置 |
| React Native | React Native Paper / NativeBase | Material Design / 跨平台组件 |
| Android Native | Material Components | Google 官方 |
| iOS Native | SwiftUI / UIKit | SwiftUI 为 Apple 推荐 |

#### 移动端 Layer 4: 状态管理（根据框架推荐）

| 框架 | 状态管理 | 说明 |
|------|----------|------|
| UniApp | Pinia / Vuex | 与 Web Vue 一致 |
| Flutter | Riverpod / Bloc / Provider | Riverpod 为现代推荐 |
| React Native | Zustand / Redux Toolkit | 与 Web React 一致 |
| Android Native | ViewModel + LiveData / Compose State | Jetpack 组件 |
| iOS Native | SwiftUI @State / Combine | SwiftUI 内置 |

#### 移动端 Layer 5: 网络请求（可多选，取长补短）

| 方案 | 特点 | 适用场景 |
|------|------|----------|
| 框架内置请求 | UniApp uni.request / Flutter http / RN fetch | 默认推荐，零额外依赖 |
| Axios | 拦截器机制、上传/下载进度监控、社区大 | JS/TS 项目（UniApp/RN） |
| Dio | Flutter 最流行 HTTP 客户端、拦截器、进度监控 | Flutter 项目 |

**多选评估：** ✅ 可多选 — 框架内置请求 + Axios（或 Dio）不冲突。内置请求处理简单场景，Axios/Dio 处理需要拦截器和进度监控的复杂场景。多选时 Core 层统一封装。`multiSelect: true`

#### 移动端 Layer 6: 本地存储（可多选，分级存储）

| 方案 | 特点 | 适用场景 |
|------|------|----------|
| 框架内置存储 | UniApp uni.setStorage / Flutter shared_preferences / RN AsyncStorage | 默认推荐 |
| 本地数据库 | SQLite / Realm / WatermelonDB | 离线数据、大量本地数据 |
| MMKV | 高性能 KV 存储 | 高性能 KV 需求 |

**多选评估：** ✅ 可多选 — 框架内置存储（简单 KV）+ 本地数据库（结构化数据）+ MMKV（高性能 KV）不冲突，可分级使用。多选时 Core 层封装统一存储接口，按数据类型路由。`multiSelect: true`

#### 移动端 Layer 7: 测试框架（根据框架推荐）

| 框架 | 测试框架 | 说明 |
|------|----------|------|
| UniApp | Vitest / Jest | 与 Web Vue 一致 |
| Flutter | Flutter test（内置） | 官方内置 |
| React Native | Jest / Detox | Jest 单元测试、Detox E2E |
| Android Native | JUnit / Espresso | Google 推荐 |
| iOS Native | XCTest | Apple 官方 |

#### 移动端兼容性矩阵（结构性绑定）

| | UniApp | Flutter | React Native | Android Native | iOS Native |
|---|---|---|---|---|---|
| **Vue** | ✅ | ❌ | ❌ | ❌ | ❌ |
| **Dart** | ❌ | ✅ | ❌ | ❌ | ❌ |
| **JS/TS** | ✅ | ❌ | ✅ | ❌ | ❌ |
| **Kotlin** | ❌ | ❌ | ❌ | ✅ | ❌ |
| **Swift** | ❌ | ❌ | ❌ | ❌ | ✅ |

---

## 2.1 子插件联动推荐

配套插件采用双触发推荐：用户确认某项技术后可即时触发一次局部推荐；前端所有基础层级完成后，还必须基于完整前端技术栈执行一次收尾推荐。收尾推荐应动态筛选约 5 个与当前项目需求和全部已选技术兼容的插件或开发工具，不足 5 个时宁缺毋滥。每个插件必须作为独立选项展示；表格中的多个已选技术仅表示触发条件，不是一个可选组合，也不得自动勾选任何插件。收尾问题使用 `multiSelect: true`，并提供“无（暂不需要）”。若交互工具的单题候选上限不足以同时容纳约 5 个插件与“无”，必须按职责拆成连续 2 个收尾问题，不得删掉“无”、绑定插件或减少关键推荐；全部确认前不得进入后端选型。

### Vue 生态

| 已选技术条件 | 独立插件选项 | 用途 | 推荐级别 |
|--------------|--------------|------|----------|
| Vue + Pinia | `pinia-plugin-persistedstate` | 状态持久化（localStorage/sessionStorage） | 推荐 |
| Vue + Pinia | `@pinia/nuxt` | Nuxt 集成（仅 Nuxt 项目） | Nuxt 项目必装 |
| Vue + Vue Router | `unplugin-vue-router` | 文件路由、类型安全路由 | 可选 |
| Vue + Vite | `unplugin-auto-import` | API 自动导入 | 推荐 |
| Vue + Vite | `unplugin-vue-components` | 组件自动导入 | 推荐 |

### React 生态

| 已选技术条件 | 独立插件选项 | 用途 | 推荐级别 |
|--------------|--------------|------|----------|
| React + Zustand | `zustand/middleware`（persist） | 状态持久化 | 推荐 |
| React + Redux Toolkit | `redux-persist` | 状态持久化 | 推荐 |
| React + Jotai | `jotai/utils`（atomWithStorage） | 状态持久化 | 推荐 |
| React + React Router | 路由级代码分割方案 | 路由懒加载 | 可选 |
| React + Next.js | `next-auth` | 认证方案 | 按需 |

### Svelte 生态

| 已选技术条件 | 独立插件选项 | 用途 | 推荐级别 |
|--------------|--------------|------|----------|
| Svelte + SvelteKit | `@sveltejs/adapter-auto` | 自动部署适配 | 必装 |
| Svelte + Svelte Stores | 自定义 persist store | 状态持久化 | 推荐 |

### 通用推荐（不限框架）

| 插件 | 用途 | 是否必装 |
|------|------|----------|
| `@tanstack/query` | 数据获取与缓存（如未在 Layer 6 选择） | 按需 |
| `dayjs` | 日期处理（轻量） | 推荐 |
| `lodash-es` | 工具函数（按需引入） | 按需 |
| 图标库（按 UI 框架选配套） | UI 图标方案，禁止用 emoji 充当 UI 图标。React → Lucide React / Heroicons；Vue → Lucide Vue / Heroicons；Svelte → Lucide Svelte；跨框架 → Iconify（按需加载）或 Phosphor / Tabler Icons | 推荐 |
| `@typescript-eslint` | TypeScript ESLint 规则（如 Layer 11 选 ESLint） | 推荐 |
| `i18next-parser` / `@formatjs/cli` | 翻译 key 自动提取（如 Layer 12 启用） | 按需 |

---

## 2.2 兼容性矩阵（结构性绑定）

仅标注**长期不变的生态绑定关系**；版本级兼容性按 0.3 协议实时验证。

### 主框架 × UI 组件库

| | Element Plus | Naive UI | Ant Design Vue | Ant Design | shadcn/ui | MUI | shadcn-svelte |
|---|---|---|---|---|---|---|---|
| **Vue** | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| **React** | ❌ | ❌ | ❌ | ✅ | ✅ | ✅ | ❌ |
| **Svelte** | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ✅ |

### 主框架 × 状态管理

| | Pinia | Vuex | Zustand | Redux Toolkit | Jotai | Svelte Stores |
|---|---|---|---|---|---|---|
| **Vue** | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| **React** | ❌ | ❌ | ✅ | ✅ | ✅ | ❌ |
| **Svelte** | ❌ | ❌ | ❌ | ❌ | ❌ | ✅ |

### 主框架 × 路由

| | Vue Router | React Router | Next.js App Router | SvelteKit | TanStack Router |
|---|---|---|---|---|---|
| **Vue** | ✅ | ❌ | ❌ | ❌ | ✅（Vue 版） |
| **React** | ❌ | ✅ | ✅ | ❌ | ✅（React 版） |
| **Svelte** | ❌ | ❌ | ❌ | ✅ | ✅（Svelte 版） |

### 主框架 × 国际化方案

| | vue-i18n | react-intl | i18next |
|---|---|---|---|
| **Vue** | ✅ | ❌ | ✅（有 Vue 集成包） |
| **React** | ❌ | ✅ | ✅（react-i18next） |
| **Svelte** | ❌ | ❌ | ✅（svelte-i18next） |

### 构建工具 × 测试框架（参考规律，需实时验证）

一般规律：Vite → Vitest 集成最顺；Webpack → Jest 最成熟；Turbopack 场景遵循 Next.js 官方测试指南。

具体版本兼容性随生态演进变化，选择时按 0.3 协议查阅对应测试框架的官方集成文档确认，不以本文档为准。

**图例：** ✅ 兼容 | ❌ 不兼容（结构性） | ⚠️ 需额外配置（以实时验证为准）

---

## 2.3 框架能力覆盖矩阵（消除冗余推荐）

> **核心目标：** 用户选择某框架后，AI Agent 动态检测该框架已覆盖的能力，对后续层级标记"已覆盖"，并将"使用内置"作为独立候选；不得默认跳过，必须让用户明确选择内置、独立方案或“无（暂不需要）”。

### 前端框架能力覆盖

| 已选框架 | 覆盖的层级 | 覆盖能力说明 | 默认策略 |
|----------|-----------|-------------|----------|
| **Element Plus** (Vue) | L9 表单验证 | `el-form` + `el-form-item` 内置验证规则 | 推荐“使用内置”，仍需用户确认；复杂校验可选择独立方案 |
| **Ant Design** (React) | L9 表单验证 | `Form` + `Form.Item` 内置验证规则 | 推荐“使用内置”，仍需用户确认；复杂校验可选择独立方案 |
| **Ant Design Vue** (Vue) | L9 表单验证 | 与 Ant Design 一致的表单验证 | 推荐“使用内置”，仍需用户确认；复杂校验可选择独立方案 |
| **Naive UI** (Vue) | L9 表单验证 | `n-form` 内置验证 | 推荐“使用内置”，仍需用户确认；复杂校验可选择独立方案 |
| **MUI** (React) | L9 表单验证 | `FormControl` + `TextField` 验证 | 推荐“使用内置”，仍需用户确认；复杂校验可选择独立方案 |
| **Vue Router** | L8 路由 | 官方路由方案 | 推荐“使用内置”，标注“已覆盖”，仍需用户确认 |
| **React Router** | L8 路由 | React 生态标准路由 | 推荐“使用内置”，标注“已覆盖”，仍需用户确认 |
| **Next.js** | L3 构建 + L8 路由 | 内置构建与 App Router | 推荐“使用内置”，标注“已覆盖”，仍需用户确认 |
| **SvelteKit** | L3 构建 + L8 路由 | 内置 Vite 构建与文件路由 | 推荐“使用内置”，标注“已覆盖”，仍需用户确认 |
| **Nuxt** (Vue) | L3 构建 + L8 路由 | 内置 Vite 构建与文件路由 | 推荐“使用内置”，标注“已覆盖”，仍需用户确认 |

### 后端框架能力覆盖

| 已选框架 | 覆盖的层级 | 覆盖能力说明 | 默认策略 |
|----------|-----------|-------------|----------|
| **NestJS** | L8 认证 | `@nestjs/passport` 集成 Passport 策略 | 推荐框架插件，仍需用户确认 |
| **Spring Boot** | L8 认证 | Spring Security 生态 | 推荐 Spring Security，仍需用户确认 |
| **Spring Boot** | L9 日志 | Logback 集成 | 推荐“使用框架默认”，仍需用户确认是否需要独立日志方案 |
| **Spring Boot** | L12 定时任务 | `@Scheduled` 内置 | 简单场景推荐“使用内置”；分布式场景选择独立调度方案；仍需用户确认 |
| **NestJS** | L12 定时任务 | `@nestjs/schedule` 集成 | 简单场景推荐框架插件；分布式场景选择独立调度方案；仍需用户确认 |
| **Django** (Python) | L4 ORM | Django ORM 内置 | 推荐“使用内置”；其他数据库类型需重新检查适配性；仍需用户确认 |
| **Django** (Python) | L8 认证 | Django Auth 内置 | 推荐“使用内置”；复杂身份体系可选择独立方案；仍需用户确认 |
| **FastAPI** (Python) | L9 日志 | Uvicorn 日志集成 | 简单场景推荐“使用框架默认”；仍需用户确认是否需要独立日志方案 |

### 能力覆盖决策流程

```
用户选择框架 X
    ↓
AI Agent 查询能力覆盖矩阵
    ↓
框架 X 覆盖了层级 L？
    ├── 是 → 在 L 层推荐"使用内置"，标注"已覆盖"
    │        └── 仍需用户确认是否使用内置还是选择独立方案
    │            ├── 用户选"使用内置" → 使用框架内置能力
    │            └── 用户选"独立方案" → 推荐独立方案，标注"内置能力不足时选择"
    └── 否 → 正常展示 L 的候选方案，让用户选择
```

---

## 2.4 分层联动规则（选A推荐B，但仍需用户确认）

> **核心目标：** 前序选择筛选后序可选项，联动推荐配套框架和插件，以交互式勾选展示。**推荐不等于自动选择，所有层级仍需用户确认。**

### 前端联动规则

| 已选（前序） | 联动推荐（后序） | 联动方式 |
|-------------|----------------|----------|
| Vue | L4 展示 Vue 生态组件库候选 | 过滤候选 |
| Vue | L7 推荐 Pinia | 标注推荐，用户确认 |
| Vue | L8 推荐 Vue Router | 标注推荐，用户确认 |
| Vue | L10 推荐 Vitest | 标注推荐，用户确认 |
| React | L4 展示 React 生态组件库候选 | 过滤候选 |
| React | L7 推荐 Zustand（中小型）/ Redux Toolkit（大型） | 标注推荐，用户确认 |
| React | L8 推荐 React Router | 标注推荐，用户确认 |
| Svelte | L4 展示 Svelte 生态组件库候选 | 过滤候选 |
| Svelte | L7 推荐 Svelte Stores | 标注推荐，用户确认 |
| Svelte | L8 推荐 SvelteKit 路由 | 标注推荐，用户确认 |
| Vite (L3) | L10 推荐 Vitest | 标注推荐，用户确认 |
| Next.js (L1+L3) | L8 推荐 App Router | 标注推荐，用户确认 |
| TailwindCSS (L5) | L11 推荐 TailwindCSS 类名排序插件 | 推荐插件 |

### 后端联动规则

| 已选（前序） | 联动推荐（后序） | 联动方式 |
|-------------|----------------|----------|
| Node.js | L4 展示 Node 生态 ORM 候选 | 过滤候选 |
| Node.js | L9 推荐 Pino | 标注推荐，用户确认 |
| NestJS | L8 推荐 `@nestjs/passport` | 推荐插件 |
| NestJS | L10 推荐 Jest | 标注推荐，用户确认 |
| Java | L4 展示 Java 生态 ORM 候选 | 过滤候选 |
| Spring Boot | L9 推荐 Logback | 标注推荐，用户确认 |
| Spring Boot | L8 推荐 Spring Security | 标注推荐，用户确认 |
| Go | L4 展示 Go 生态 ORM 候选 | 过滤候选 |
| Go | L9 推荐 Zap | 标注推荐，用户确认 |
| Gin | L8 推荐 `golang-jwt/jwt` | 推荐插件 |
| Prisma | L5 兼容 MySQL / PostgreSQL / MongoDB | 过滤候选 |
| MyBatis Plus | L5 兼容 MySQL / PostgreSQL | 过滤候选 |

### 配套插件联动（多选勾选展示）

用户选择主框架后，配套插件以**多选勾选**形式展示，用户按需勾选。各生态完整插件表见 **2.1 节（前端）与 3.1 节（后端）**，此处不重复。

**动态推荐交互示例（仅示意，不是固定清单）：**
```
# 用户刚确认 Pinia 后，先执行 web_search，以下选项必须由实时结果生成
ask_followup_question({
  questions: [{
    question: "前端-Pinia 配套插件？",
    header: "前端-Pinia-插件",
    multiSelect: true,
    options: [
      "实时调研候选 A（标注用途与兼容性）",
      "实时调研候选 B（标注用途与兼容性）",
      "无（暂不需要）"
    ]
  }]
})
```

---

## 2.5 用户自定义入口

### 自定义规则

- 用户可在任意层级输入推荐之外的方案
- AI Agent **不拒绝**用户自定义选择
- AI Agent 仅做**兼容性提示**和**潜在风险说明**
- 最终决定权归用户

### AI Agent 处理流程

1. 用户输入自定义方案
2. AI Agent 检查与已选方案的兼容性
3. 如兼容：接受选择，继续下一层
4. 如不兼容：提示风险，提供替代方案建议，但尊重用户选择
5. 如无法判断兼容性：标注"未知兼容性，请用户自行验证"

### 自定义示例

```
用户：前端-UI 组件库 我想用 Arco Design
AI Agent：Arco Design 是字节跳动的 UI 库，支持 React 和 Vue。
         - 与 Vue 兼容 ✅
         - 与 React 兼容 ✅
         - 与 Svelte 不兼容 ❌
         请确认是否使用。
用户：确认
AI Agent：已锁定 前端-UI 组件库: Arco Design。进入 前端-CSS 方案...
```

---

## 3. 后端技术选型 — 分层选择流程（默认单选，AI 评估后可多选）

> **强制规则：** 后端选型在阶段三进行，必须在前端基础层级和“前端-配套插件推荐”全部完成后才开始。禁止与前端层级混批。每层默认单选，AI Agent 必须按「0.5 多选兼容评估协议」评估该层是否适合多选。后端 Layer 12 完成后必须执行“后端-配套插件推荐”，确认后才能进入跨端关注点。

### 选择流程图

```
Layer 1: 后端-运行时 → Layer 1-A: 后端-开发语言 → Layer 2: 后端-框架 → Layer 3: 后端-API 规范
                                                      ↓
Layer 4: 后端-ORM/数据访问 →  Layer 5: 后端-数据库     →  Layer 6: 后端-缓存方案
                                                      ↓
Layer 7: 后端-消息队列    →  Layer 8: 后端-认证方案   →  Layer 9: 后端-日志系统
                                                      ↓
Layer 10: 后端-测试框架   →  Layer 11: 后端-文件存储   →  Layer 12: 后端-定时任务（按需）
```

**规则：** 从 Layer 1 开始逐层选择，每层选一个，前序选择影响后序推荐。

---

### Layer 1: 运行时（互斥，仅可单选）

| 方案 | 特点 | 适用场景 |
|------|------|----------|
| Node.js | JavaScript/TypeScript 服务端运行时，生态成熟 | 全栈同语言、快速迭代、中小型服务 |
| JDK | Java 应用运行时与标准库基础 | 企业级系统、大型项目 |
| Go Runtime | Go 编译程序的运行环境 | 高性能服务、微服务、云原生 |
| Python Runtime | Python 解释器运行环境 | AI/ML、数据分析、快速原型 |

> **新兴运行时（Node.js 生态）：** Bun 和 Deno 可作为独立运行时选项调研，不与 TypeScript 绑定。它们应在用户选择运行时后作为独立候选推荐，并标注"新兴，生产环境建议观察"。

**多选评估：** ❌ 互斥 — 一个后端服务通常只选择一个主运行时，仅可单选。运行时版本按 0.1 协议实时确认。

### Layer 1-A: 开发语言（互斥，仅可单选）

| 方案 | 特点 | 适用场景 |
|------|------|----------|
| TypeScript | 类型安全、IDE 智能提示、重构友好 | Node.js 或其他支持 TS 的运行时项目 |
| JavaScript | 无类型编译要求、学习门槛低 | Node.js 快速原型和轻量服务 |
| Java | 企业级生态成熟、工具链完善 | JDK 运行时项目 |
| Go | 编译型、高性能、原生并发 | Go Runtime 项目 |
| Python | AI/ML 友好、生态丰富、开发效率高 | Python Runtime 项目 |

**选择信号：** 运行时与语言是两个独立决策。Node.js 可搭配 TypeScript 或 JavaScript；JDK 通常搭配 Java；Go Runtime 搭配 Go；Python Runtime 搭配 Python。AI Agent 只能提示兼容性，不得把它们合并成一个选项。

**多选评估：** ❌ 互斥 — 一个服务的主开发语言仅可单选。

**用户自定义：** 可输入其他运行时或语言（如 Rust、C#），AI Agent 仅做兼容性提示。

---

### Layer 2: 后端框架（根据主语言推荐）

#### Java 生态

| 方案 | 特点 | 适用场景 |
|------|------|----------|
| Spring Boot | Java 后端事实标准、生态最全 | 企业级系统（默认推荐） |
| Quarkus | 云原生、启动快、内存占用低、GraalVM 支持 | 云原生、Serverless |
| Vert.x | 响应式、事件驱动、高并发 | 高并发实时系统 |

#### Node.js 生态

| 方案 | 特点 | 适用场景 |
|------|------|----------|
| NestJS | 模块化、TypeScript 原生、IoC 容器、文档优秀 | 企业级 Node 项目（默认推荐） |
| Express | 最轻量、生态最大、中间件丰富 | 小型项目、快速原型 |
| Fastify | 性能优先、Schema 验证、插件系统 | 高性能 API 服务 |

#### Go 生态

| 方案 | 特点 | 适用场景 |
|------|------|----------|
| Gin | 最流行、中间件丰富、文档好、性能优秀 | 通用 Go 后端（默认推荐） |
| Fiber | Express 风格 API、极速路由 | 高性能 API 服务 |
| Echo | 简洁、高性能、中间件丰富 | 中型项目 |

#### Python 生态

| 方案 | 特点 | 适用场景 |
|------|------|----------|
| FastAPI | 异步、自动文档、类型安全、性能好 | API 服务、AI 后端 |
| Django | 全栈框架、admin 后台、ORM 内置 | 内容管理、全栈项目 |
| Flask | 轻量、灵活、生态丰富 | 小型项目、微服务 |

**多选评估：** ❌ 互斥 — 同一服务不能同时跑多个后端框架，仅可单选。

---

### Layer 3: API 规范（可多选，对外/对内分工）

| 方案 | 特点 | 适用场景 |
|------|------|----------|
| RESTful | 通用标准、生态最广、前端友好、学习成本低 | 所有项目（通用首选） |
| GraphQL | 灵活查询、按需获取、减少过度请求 | 复杂数据查询、多端适配 |
| gRPC | 高性能、Protobuf 序列化、强类型 | 微服务内部通信、高性能场景 |

**多选评估：** ✅ 可多选 — RESTful（对外前端友好）+ gRPC（微服务内部高性能通信）不冲突，是微服务架构的常见组合。多选时对外网关暴露 RESTful，内部服务间用 gRPC。Core 层封装统一的 API 接口层。`multiSelect: true`

**单选时：** 纯单体服务选 RESTful 即可。

---

### Layer 4: ORM/数据访问（根据主语言推荐）

#### Java 生态

| 方案 | 特点 | 适用场景 |
|------|------|----------|
| MyBatis Plus | 国内流行、代码生成、Lambda 查询、SQL 灵活 | 企业级项目（国内团队推荐） |
| Spring Data JPA | Spring 官方、标准 JPA、Repository 模式 | 国际化项目、标准 ORM |
| jOOQ | 类型安全 SQL、代码生成、数据库优先 | 复杂 SQL、类型安全需求 |

#### Node.js 生态

| 方案 | 特点 | 适用场景 |
|------|------|----------|
| Prisma | 类型安全、Schema 优先、迁移工具、DX 好 | TypeScript 项目（默认推荐） |
| TypeORM | 装饰器风格、Active Record / Data Mapper | 装饰器风格偏好 |
| Drizzle ORM | 轻量、SQL 风格、性能好 | 极简项目、SQL 风格偏好 |

#### Go 生态

| 方案 | 特点 | 适用场景 |
|------|------|----------|
| Gorm | Go 最流行 ORM、功能全、文档好 | 通用 Go 项目（默认推荐） |
| sqlx | 轻量、原生 SQL、struct 扫描 | 原生 SQL 偏好 |
| ent | Schema 优先、代码生成 | 复杂关系数据 |

#### Python 生态

| 方案 | 特点 | 适用场景 | 能力覆盖状态 |
|------|------|----------|-------------|
| SQLAlchemy | Python 生态标准 ORM、功能强大、支持多种模式 | 通用 Python 项目（默认推荐） | 独立方案 |
| Django ORM | Django 内置、与 Admin 深度集成 | Django 项目 | Django 已内置，标记"已覆盖" |
| Tortoise ORM | 异步 ORM、Django 风格 API | FastAPI / 异步项目 | 独立方案 |

**选择信号：** 国内 Java 团队 → MyBatis Plus；国际化 Java 团队 → JPA；Node 项目 → Prisma 优先；Django 项目 → 使用内置 Django ORM；FastAPI 项目 → SQLAlchemy 或 Tortoise ORM。

**多选评估：** ⚠️ 视场景 — 同一数据库多套 ORM 会导致数据模型混乱（互斥）；但"MyBatis Plus（复杂 SQL）+ Spring Data JPA（简单 CRUD）"或"Prisma（主 ORM）+ 原生 SQL（复杂查询）"可组合。默认单选，仅当用户明确需要分工时才多选。多选时 Core 层封装统一数据访问接口。默认 `multiSelect: false`

---

### Layer 5: 数据库（主库互斥，辅助库可多选）

| 方案 | 特点 | 适用场景 |
|------|------|----------|
| MySQL | 最流行关系型数据库、生态成熟、运维成本低 | 通用业务（默认推荐） |
| PostgreSQL | 高级查询、JSON 支持、扩展性强、GIS | 高级查询、数据分析、GIS |
| MongoDB | 文档型、Schema 灵活、水平扩展 | 文档数据、内容管理、快速迭代 |

**多选评估：** ⚠️ 主库互斥 — 主数据库只能一个。但"关系型主库 + MongoDB（文档型辅助）+ ElasticSearch（搜索）"是常见组合，属于不同用途的辅助库多选。主库选择 `multiSelect: false`；辅助库（Redis/ES/MongoDB）在各自层级单独选择。

**AI Agent 必须说明每个数据库选择的理由。**

---

### Layer 6: 缓存方案（可多选，二级缓存）

| 方案 | 特点 | 适用场景 |
|------|------|----------|
| Redis | 最流行缓存、数据结构丰富、持久化、集群 | 所有项目（默认推荐） |
| Memcached | 纯内存缓存、极简、高性能 | 纯缓存场景、极简需求 |
| 进程内缓存（如 Caffeine） | 零网络开销、延迟最低 | 单机缓存、读多写少 |

**多选评估：** ✅ 可多选 — Redis（分布式共享缓存）+ 进程内缓存（单机高频读）不冲突，是二级缓存策略的常见组合。多选时 Core 层封装二级缓存接口：先查进程内缓存，未命中再查 Redis，最后回源数据库。`multiSelect: true`

---

### Layer 7: 消息队列（可多选，按场景分工）

| 方案 | 特点 | 适用场景 |
|------|------|----------|
| RabbitMQ | 成熟、路由灵活、AMQP 标准、管理界面好 | 企业级消息（默认推荐） |
| Kafka | 高吞吐、日志流、分布式 | 日志流、大数据、高吞吐 |
| Redis Streams | 无额外组件、轻量、与 Redis 复用 | 小型项目、简单消息 |

**多选评估：** ✅ 可多选 — RabbitMQ（业务消息，路由灵活）+ Kafka（日志流/大数据，高吞吐）不冲突，各自负责不同场景。多选时 Core 层封装统一消息接口，按消息类型路由到不同队列。`multiSelect: true`

**单选时：** 小型项目用 Redis Streams 即可；中大型项目用 RabbitMQ；日志/大数据场景用 Kafka。

---

### Layer 8: 认证方案（可多选，双认证通道）

> **能力覆盖提示：** 以下后端框架自带认证集成，选择后优先推荐框架内置方案：
> - **NestJS** — `@nestjs/passport` 集成 Passport 策略，推荐使用而非独立方案
> - **Spring Boot** — Spring Security 生态，推荐使用而非独立方案
> - **Django** — Django Auth 内置认证系统，简单场景跳过此层

| 方案 | 特点 | 适用场景 | 能力覆盖状态 |
|------|------|----------|-------------|
| JWT | 无状态、跨域友好、移动端适配、生态广 | 前后端分离、移动端（推荐） | NestJS 用 `@nestjs/passport` + JWT 策略 |
| OAuth2 / OIDC | 第三方认证标准、SSO、社交登录 | SSO、第三方登录、企业认证 | Spring Security OAuth2 |
| Session + Cookie | 传统方案、服务端控制、可强制下线 | 传统 Web 应用、服务端渲染 | Django Auth 内置 |

**多选评估：** ✅ 可多选 — JWT（无状态 API 认证）+ Session（需要强制下线的传统 Web 场景）+ OAuth2（第三方登录）不冲突，可按路由区分认证方式。多选时 Core 层封装统一认证接口，按请求路由自动选择认证策略。`multiSelect: true`

**单选时：** 前后端分离用 JWT；需要 SSO 或社交登录用 OAuth2/OIDC；传统 SSR 用 Session。NestJS 项目推荐 `@nestjs/passport` + JWT 策略。

---

### Layer 9: 日志系统（根据主语言推荐）

> **能力覆盖提示：** 以下框架自带日志系统，简单场景可跳过此层：
> - **Spring Boot** — Logback 内置，默认覆盖
> - **NestJS** — 内置 Logger，简单场景可跳过
> - **FastAPI** — Uvicorn 日志集成，简单场景可跳过

#### Java 生态

| 方案 | 特点 | 适用场景 | 能力覆盖状态 |
|------|------|----------|-------------|
| Logback | Spring Boot 默认、性能好、配置灵活 | Spring Boot 项目（默认） | Spring Boot 已内置 |
| Log4j2 | 异步日志、性能最优 | 高性能日志需求 | 内置不足时选择 |
| SLF4J + 自选实现 | 接口标准、可切换实现 | 需要灵活切换日志实现 | 内置不足时选择 |

#### Node.js 生态

| 方案 | 特点 | 适用场景 | 能力覆盖状态 |
|------|------|----------|-------------|
| Pino | 性能最优、JSON 日志、传输流 | 高性能服务（推荐） | 独立方案 |
| Winston | 最流行、多传输、灵活配置 | 通用项目 | 独立方案 |
| 框架内置 Logger | 零依赖、框架集成 | 小型项目 | NestJS 已内置，简单场景可跳过 |

#### Go 生态

| 方案 | 特点 | 适用场景 |
|------|------|----------|
| Zap | Uber 出品、零分配、性能最优 | 高性能 Go 服务（推荐） |
| Logrus | 结构化日志、API 友好 | 通用 Go 项目 |
| slog（标准库） | 官方内置、零依赖、结构化 | 新版本 Go 项目 |

#### Python 生态

| 方案 | 特点 | 适用场景 | 能力覆盖状态 |
|------|------|----------|-------------|
| Loguru | 开箱即用、结构化、文件轮转、异常追踪 | 通用 Python 项目（推荐） | 独立方案 |
| structlog | 结构化日志、JSON 输出 | 结构化日志需求 | 独立方案 |
| 框架内置日志 | Django logging / Uvicorn 日志 | 小型项目 | Django/FastAPI 已内置，简单场景可跳过 |

**多选评估：** ❌ 互斥 — 多套日志系统会导致日志格式和输出冲突，仅可单选。（注：SLF4J 是接口标准，其实现如 Logback/Log4j2 仍互斥）

---

### Layer 10: 测试框架（根据主语言推荐）

#### Java 生态

| 方案 | 特点 | 适用场景 |
|------|------|----------|
| JUnit 5 | Java 测试标准、Spring Boot 集成 | Java 项目（默认） |
| TestNG | 参数化测试、依赖测试、并行 | 复杂测试场景 |
| Spock | Groovy DSL、BDD 风格 | BDD 风格偏好 |

#### Node.js 生态

| 方案 | 特点 | 适用场景 |
|------|------|----------|
| Jest | 最流行、零配置、快照测试、Mock 丰富 | Node.js 项目（默认推荐） |
| Vitest | Vite 原生、极快、API 兼容 Jest | Vite 全栈项目 |
| Mocha | 灵活的测试运行器、社区成熟 | 自定义测试运行流程 |
| Chai | 独立断言库 | 可与用户另选的 Mocha 配合 |

#### Go 生态

| 方案 | 特点 | 适用场景 |
|------|------|----------|
| Go testing（标准库） | 官方内置、零依赖、基准测试 | 所有 Go 项目（默认） |
| testify | 断言库、Mock、Suite | 增强标准库 |
| Ginkgo | BDD 风格测试框架 | BDD 风格偏好 |

#### Python 生态

| 方案 | 特点 | 适用场景 |
|------|------|----------|
| Pytest | 最流行、插件丰富、fixture 机制、参数化测试 | Python 项目（默认推荐） |
| Unittest | 标准库内置、零依赖 | 简单项目、标准库偏好 |
| Robot Framework | 关键字驱动、BDD 风格 | BDD 风格偏好 |

**多选评估：** ⚠️ 视场景 — 同类型的单元测试框架互斥（如 Jest 与 Vitest 二选一）；但"单元测试框架 + E2E/集成测试框架"可组合（如 JUnit 5 + RestAssured、Pytest + Behave）。默认单选，仅当需要分层测试时才多选。默认 `multiSelect: false`

---

### Layer 11: 文件存储方案（可多选，分级存储）

| 方案 | 特点 | 适用场景 |
|------|------|----------|
| S3 / OSS / COS | 云存储、无限容量、CDN 加速、按量付费 | 云部署项目（默认推荐） |
| MinIO | S3 兼容、自建对象存储、开源免费 | 私有部署、内网项目、成本敏感 |
| 本地文件存储 | 零依赖、最简单、无网络开销 | 单机部署、小型项目、内网工具 |

**多选评估：** ✅ 可多选 — S3/OSS（持久化和 CDN）+ 本地存储（临时文件和缓存）不冲突，是分级存储的常见组合。多选时 Core 层封装统一存储接口，按文件类型和用途路由：持久化文件 → 云存储；临时文件 → 本地存储。`multiSelect: true`

**跳过条件：** 纯 API 项目、无文件上传需求可选择"暂不需要"。

**单选时：** S3/OSS + 本地缓存是常见组合；MinIO 适合开发环境替代 S3。

---

### Layer 12: 定时任务（按需，可跳过）

> **能力覆盖提示：** 以下框架自带定时任务能力，简单场景可跳过此层：
> - **Spring Boot** — `@Scheduled` 内置，简单定时任务已覆盖
> - **NestJS** — `@nestjs/schedule` 内置，简单定时任务已覆盖

#### Java 生态

| 方案 | 特点 | 适用场景 | 能力覆盖状态 |
|------|------|----------|-------------|
| Spring @Scheduled | Spring Boot 内置、零依赖、注解式 | 单机定时任务（简单场景） | Spring Boot 已内置 |
| XXL-Job | 分布式调度、可视化界面、动态配置 | 分布式定时任务（国内团队推荐） | 内置不足时选择 |
| Quartz | 功能全、集群支持、持久化 | 复杂调度需求 | 内置不足时选择 |

#### Node.js 生态

| 方案 | 特点 | 适用场景 |
|------|------|----------|
| @nestjs/schedule | NestJS 内置、注解式、Cron 表达式 | NestJS 项目（推荐） |
| Bull 系 | Redis 队列、定时任务、重试机制 | 需要队列 + 定时场景 |
| node-cron | 轻量、Cron 表达式、无依赖 | 简单定时任务 |

#### Go 生态

| 方案 | 特点 | 适用场景 |
|------|------|----------|
| robfig/cron | Go 最流行 Cron 库、API 简洁 | 通用 Go 项目（推荐） |
| gocron | 链式 API、简单易用 | 偏好链式 API |
| 标准库 time.Ticker | 零依赖、最简单 | 固定间隔任务 |

#### Python 生态

| 方案 | 特点 | 适用场景 | 能力覆盖状态 |
|------|------|----------|-------------|
| Celery | 分布式任务队列、定时任务、重试 | 分布式定时任务（推荐） | 独立方案 |
| APScheduler | 轻量定时任务、Cron 表达式 | 单机定时任务 | 独立方案 |
| Django cron | Django 内置定时任务 | Django 项目简单场景 | Django 可选内置 |

**多选评估：** ⚠️ 视场景 — 同类型定时任务方案互斥（如 XXL-Job 与 Quartz 二选一）；但"框架内置（简单单机定时）+ 分布式调度（复杂场景）"可组合。默认单选，仅当简单任务和复杂分布式任务并存时才多选。默认 `multiSelect: false`

**跳过条件：** 无定时任务需求可选择"暂不需要"。

---

## 3.1 后端子插件联动推荐

配套插件采用双触发推荐：用户确认某项技术后可即时触发一次局部推荐；后端所有基础层级完成后，还必须基于完整后端技术栈执行一次收尾推荐。收尾推荐应动态筛选约 5 个与当前项目需求、部署方式和全部已选技术兼容的插件或开发工具，不足 5 个时宁缺毋滥。每个插件必须作为独立选项展示；表格中的多个技术仅表示触发条件，不是固定组合选项，也不得自动勾选。收尾问题使用 `multiSelect: true`，并提供“无（暂不需要）”。若交互工具的单题候选上限不足以同时容纳约 5 个插件与“无”，必须按职责拆成连续 2 个收尾问题，不得删掉“无”、绑定插件或减少关键推荐；全部确认前不得进入跨端关注点。

### Java 生态

| 已选技术条件 | 独立插件选项 | 用途 | 推荐级别 |
|--------------|--------------|------|----------|
| Spring Boot + MyBatis Plus | `mybatis-plus-join` | 多表联查 | 推荐 |
| Spring Boot + MyBatis Plus | `dynamic-datasource` | 多数据源支持 | 按需 |
| Spring Boot + JPA | `spring-data-envers` | 审计日志、数据版本 | 按需 |
| Spring Boot | `spring-boot-starter-actuator` | 健康检查、监控 | 推荐 |
| Spring Boot | `springdoc-openapi` | OpenAPI 文档自动生成 | 推荐 |
| Spring Boot + Spring Cloud | Nacos 等注册/配置中心组件 | 服务注册与配置 | 微服务必装 |
| Spring Boot + 文件存储 | S3 兼容 SDK / MinIO SDK | 对象存储集成 | 文件存储必装 |
| Spring Boot + 定时任务 | `xxl-job-core` | 分布式调度中心 | 分布式定时任务推荐 |

### Node.js 生态

| 已选技术条件 | 独立插件选项 | 用途 | 推荐级别 |
|--------------|--------------|------|----------|
| NestJS + Prisma | Prisma NestJS 集成模块 | Prisma 集成 | 推荐 |
| NestJS | `@nestjs/swagger` | Swagger 文档自动生成 | 推荐 |
| NestJS | `@nestjs/throttler` | 限流保护 | 推荐 |
| NestJS | `@nestjs/passport` | 认证策略集成 | 认证必装 |
| NestJS + 文件存储 | S3 SDK / MinIO SDK | 对象存储集成 | 文件存储必装 |
| NestJS + 定时任务 | `@nestjs/schedule` | 定时任务装饰器 | 定时任务必装 |
| Fastify | `@fastify/swagger` | Swagger 文档 | 推荐 |
| Fastify | `@fastify/rate-limit` | 限流保护 | 推荐 |

### Go 生态

| 已选技术条件 | 独立插件选项 | 用途 | 推荐级别 |
|--------------|--------------|------|----------|
| Gin + Gorm | `gorm/datatypes` | 扩展数据类型 | 按需 |
| Gin + Gorm | `gorm/hints` | 优化器提示 | 按需 |
| Gin | `swaggo/swag` | Swagger 文档自动生成 | 推荐 |
| Gin | `gin-contrib/cors` | CORS 中间件 | 推荐 |
| Gin | `golang-jwt/jwt` | JWT 认证 | 认证必装 |
| Gin + 文件存储 | S3 / MinIO 的 Go SDK | 对象存储集成 | 文件存储必装 |
| Gin + 定时任务 | `robfig/cron` | 定时任务调度 | 定时任务必装 |

### Python 生态

| 已选技术条件 | 独立插件选项 | 用途 | 推荐级别 |
|--------------|--------------|------|----------|
| FastAPI | `uvicorn[standard]` | ASGI 服务器 | 必装 |
| FastAPI | `python-multipart` | 文件上传支持 | 文件上传必装 |
| FastAPI + SQLAlchemy | `alembic` | 数据库迁移 | 推荐 |
| Django | `django-rest-framework` | REST API 开发 | API 项目推荐 |
| Django | `django-cors-headers` | CORS 支持 | 前后端分离必装 |
| FastAPI / Django + 文件存储 | `boto3` (S3) / `minio` SDK | 对象存储集成 | 文件存储必装 |
| Python + 定时任务 | `celery[redis]` | Celery + Redis 后端 | 定时任务必装 |

### 通用推荐（不限语言）

| 插件/工具 | 用途 | 是否必装 |
|-----------|------|----------|
| Swagger / OpenAPI | API 文档 | 推荐 |
| Docker | 容器化部署 | 推荐 |
| Prometheus + Grafana | 监控告警 | 生产环境推荐 |
| ELK / Loki | 日志收集与分析 | 生产环境推荐 |

---

## 3.2 后端兼容性矩阵（结构性绑定）

仅标注**长期不变的生态绑定关系**；版本级兼容性按 0.3 协议实时验证。

### 主语言 × 后端框架

| | Spring Boot | Quarkus | NestJS | Express | Gin | Fiber | FastAPI | Django | Flask |
|---|---|---|---|---|---|---|---|---|---|
| **Java** | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ |
| **Node.js** | ❌ | ❌ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ |
| **Go** | ❌ | ❌ | ❌ | ❌ | ✅ | ✅ | ❌ | ❌ | ❌ |
| **Python** | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ✅ | ✅ | ✅ |

### 后端框架 × ORM

| | MyBatis Plus | JPA | Prisma | TypeORM | Gorm | sqlx | SQLAlchemy | Django ORM | Tortoise ORM |
|---|---|---|---|---|---|---|---|---|---|
| **Spring Boot** | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ |
| **NestJS** | ❌ | ❌ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ |
| **Express** | ❌ | ❌ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ |
| **Gin** | ❌ | ❌ | ❌ | ❌ | ✅ | ✅ | ❌ | ❌ | ❌ |
| **FastAPI** | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ✅ | ❌ | ✅ |
| **Django** | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ✅ | ✅ | ❌ |
| **Flask** | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ✅ | ❌ | ❌ |

### ORM × 数据库

| | MySQL | PostgreSQL | MongoDB |
|---|---|---|---|
| **MyBatis Plus** | ✅ | ✅ | ❌ |
| **JPA/Hibernate** | ✅ | ✅ | ❌ |
| **Prisma** | ✅ | ✅ | ✅ |
| **TypeORM** | ✅ | ✅ | ✅ |
| **Gorm** | ✅ | ✅ | ❌ |
| **sqlx** | ✅ | ✅ | ❌ |
| **SQLAlchemy** | ✅ | ✅ | ❌ |
| **Django ORM** | ✅ | ✅ | ❌ |
| **Tortoise ORM** | ✅ | ✅ | ❌ |

### 主语言 × 测试框架

| | JUnit 5 | TestNG | Jest | Vitest | Go testing | Pytest |
|---|---|---|---|---|---|---|
| **Java** | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| **Node.js** | ❌ | ❌ | ✅ | ✅ | ❌ | ❌ |
| **Go** | ❌ | ❌ | ❌ | ❌ | ✅ | ❌ |
| **Python** | ❌ | ❌ | ❌ | ❌ | ❌ | ✅ |

### 主语言 × 定时任务方案

| | @Scheduled / @nestjs/schedule | XXL-Job | Quartz | Bull 系 | robfig/cron | Celery | APScheduler |
|---|---|---|---|---|---|---|---|
| **Java** | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| **Node.js** | ✅（NestJS） | ❌ | ❌ | ✅ | ❌ | ❌ | ❌ |
| **Go** | ❌ | ❌ | ❌ | ❌ | ✅ | ❌ | ❌ |
| **Python** | ❌ | ❌ | ❌ | ❌ | ❌ | ✅ | ✅ |

**图例：** ✅ 兼容 | ❌ 不兼容（结构性） | ⚠️ 需额外配置（以实时验证为准）

---

## 3.3 后端用户自定义入口

规则与 2.5 节前端一致：接受用户自定义方案 → 检查与已选方案的兼容性 → 兼容则继续、不兼容则提示风险并提供替代建议、无法判断则标注"未知兼容性，请用户自行验证"。最终决定权归用户。

### 自定义示例

```
用户：后端-框架 我想用 Hono
AI Agent：Hono 是超轻量 Web 框架，支持 Node.js/Bun/Deno/Edge。
         - 与 Node.js 兼容 ✅
         - 与 TypeScript 兼容 ✅
         - 适合 Edge/Serverless 场景
         请确认是否使用。
用户：确认
AI Agent：已锁定 后端-框架: Hono。进入 后端-API 规范...
```

---

## 3.4 跨端关注点（前后端通用选型）

以下选型不区分前后端，为项目整体架构关注点。AI Agent 在完成前端和后端选型后，应引导用户选择：

### CI/CD 方案（互斥选一）

| 方案 | 特点 | 适用场景 |
|------|------|----------|
| GitHub Actions | GitHub 内置、免费额度、生态大、配置简单 | GitHub 托管项目 |
| GitLab CI/CD | GitLab 内置、功能全面、Runner 自管理 | GitLab 托管项目、私有化部署 |
| Jenkins | 老牌方案、插件最多、完全自控 | 传统企业、高度定制需求 |

**选择信号：** 跟随代码托管平台选择；自托管 Gitea 等场景可评估其内置 CI 或 Jenkins。

**多选评估：** ❌ 互斥 — CI/CD 主流程只能一套，避免流水线冲突，仅可单选。

---

### 错误监控 / APM（互斥选一）

| 方案 | 特点 | 适用场景 |
|------|------|----------|
| Sentry | 前后端通用、开源、生态大、可自托管 | 所有项目（通用推荐） |
| Datadog | 全栈监控、APM + 日志 + 指标、商业方案 | 企业级全栈监控 |
| SkyWalking | Apache 开源、Java 生态强、免费 | Java 微服务、私有化部署 |

**选择信号：** 预算有限/私有化 → Sentry 自托管或 SkyWalking；企业级一体化监控 → Datadog。

**多选评估：** ⚠️ 视场景 — 同类型 APM 互斥（如 Sentry 与 Datadog 二选一）；但"错误监控（Sentry）+ 指标监控（Prometheus+Grafana）+ 日志收集（ELK/Loki）"不冲突，属于不同维度的监控，可组合。错误监控主方案单选，其他维度监控在通用推荐中单独选择。默认 `multiSelect: false`

**搭配建议：** 错误监控 + Prometheus + Grafana（指标监控）是开源组合常见实践。

---

### 安全扫描 / SAST / DAST（可多选，不同维度组合）

| 方案 | 特点 | 适用场景 |
|------|------|----------|
| SonarQube / SonarCloud | 代码质量 + 安全漏洞静态扫描、CI 集成 | 所有项目（通用推荐） |
| Snyk | 依赖漏洞扫描、自动修复 PR、多语言支持 | 依赖安全审计 |
| Trivy | 容器镜像 + IaC + 依赖扫描、开源免费 | 容器化部署项目 |
| OWASP ZAP | 动态安全扫描（DAST）、API 安全测试 | 安全测试需求 |

**多选评估：** ✅ 可多选 — SAST（静态扫描）+ 依赖漏洞扫描 + 容器镜像扫描 + DAST（动态扫描）不冲突，属于不同安全维度，可组合使用。多选时在 CI/CD 流水线中分阶段执行。`multiSelect: true`

**搭配建议：** SonarQube（代码质量 + SAST）+ Snyk（依赖漏洞）+ Trivy（镜像扫描）是开源安全组合常见实践。

---

## 4. 数据库选择

| 类别 | 选项 |
|------|------|
| 关系型 | MySQL、PostgreSQL、Oracle |
| 缓存 | Redis |
| 搜索 | ElasticSearch |
| 文档 | MongoDB |

**规则：** AI Agent 必须说明每个数据库选择的理由。

---

## 5. 部署方案

| 选项 | 适用场景 |
|------|----------|
| Docker | 容器化单服务 |
| Docker Compose | 多容器本地/开发环境 |
| Kubernetes | 大规模生产、编排 |
| Serverless | 事件驱动、自动伸缩、按量付费 |
| 腾讯云 / 阿里云 / 华为云 | 国内项目首选，备案便捷、国内访问快、合规友好 |
| Vercel / Netlify / Cloudflare Pages | 境外前端项目，自动 CI/CD、边缘网络 |
| AWS / GCP | 境外全球化项目，生态完善 |

> **部署候选必须同时包含国内与境外方案**，由用户根据备案要求、用户地域和合规需求选择。不因网络环境默认排除任一方。

---

## 6. 已有项目反向分析

当用户提供 GitHub 地址、Git 仓库或项目压缩包时，AI Agent 必须按以下流程执行反向分析。

### 6.1 分析步骤（强制按序执行）

**Step 1: 读取项目元信息**
- 读取 `README.md`、`.agent/` 目录（如存在）、`package.json` / `pom.xml` / `go.mod` / `requirements.txt`
- 识别项目定位、业务目标、技术栈、规模级别

**Step 2: 分析目录结构**
- 列出一级和二级目录树
- 识别架构模式（Core + DDD / 分层 / MVC / 无结构）
- 检查是否有 `core/` / `modules/` / `tests/` / `docs/adr/` 等规范目录
- 判断是否符合 SKILL.md 规模分级对应的架构策略

**Step 3: 分析技术栈**
- 从依赖文件提取技术栈和版本
- 对照 `references/tech-stack-guide.md` 兼容性矩阵，检查是否存在不兼容组合
- 检查版本是否过时（按 0.1 协议实时查询最新版本对比）

**Step 4: 分析代码质量**
- 检查是否有 ESLint / Prettier / Biome 等代码质量工具配置
- 检查是否有测试目录和测试覆盖率配置
- 检查是否有 `.env` 管理和环境变量使用规范
- 检查是否有硬编码敏感信息（快速扫描）

**Step 5: 分析公共能力复用**
- 检查是否有 `core/` 层和公共能力封装
- 检查业务模块是否直接调用底层库（如 axios / fetch）而非通过 Core
- 识别重复造轮子的模块

### 6.2 分析内容

- 项目结构
- 技术栈
- 依赖版本
- 目录规范
- 架构模式
- 公共组件
- 代码质量
- 测试覆盖
- 安全实践

### 6.3 输出格式（强制）

```
## 项目反向分析报告

### 1. 项目概况
- 项目名：
- 项目定位：
- 规模级别：S / M / L（判定依据）
- 当前阶段：原型 / MVP / 增长期 / 稳定维护期

### 2. 技术栈画像
| 层 | 选型 | 版本 | 最新版本 | 状态 |
|----|------|------|----------|------|
|  |  |  |  | ✅ 最新 / ⚠️ 过时 / ❌ 不兼容 |

### 3. 架构评估
- 架构模式：
- 是否符合规模分级策略：
- 目录规范度：✅ 规范 / ⚠️ 部分 / ❌ 混乱
- Core 层完整度：
- 模块化程度：

### 4. 代码质量评估
- 代码质量工具：
- 测试覆盖：
- 安全实践：
- 文档完整度：

### 5. 问题清单
| # | 问题 | 严重度 | 建议方案 |
|---|------|--------|----------|
| 1 |  | 高/中/低 |  |

### 6. 可复用模块
| 模块 | 能力 | 复用价值 |
|------|------|----------|
|  |  |  |

### 7. 待重构模块
| 模块 | 问题 | 优先级 |
|------|------|--------|
|  |  |  |

### 8. 优化建议（按优先级排序）
1. **P0（必须修复）** — 
2. **P1（建议修复）** — 
3. **P2（可优化）** — 
```
