# 技术选型指南

> 项目初始化时进行技术选型的详细参考文档。
> 在执行技术选型或分析现有项目技术栈时加载本文档。

---

## 0. 动态决策协议（最高优先级）

本文档提供的是**候选方案与选择标准**，不是固定答案。AI Agent 必须遵守以下三条协议：

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

### 分层互斥选择原则

- 按**层级顺序**逐步选择，前序选择影响后序可选项
- 同一层级内**互斥**，只能选择一个方案
- 每层给出 **Top 3 常用候选**（候选顺序仅为常见度参考，非强制排名，最终由 AI 按 0.2 协议结合上下文决定）
- 用户可**跳过推荐**，自主输入任意方案
- AI Agent 对自定义选择仅做**兼容性提示**，不强制覆盖

---

## 2. 前端技术选型 — 分层互斥选择流程

### 选择流程图

```
Layer 1: 主框架      →  Layer 2: 开发语言   →  Layer 3: 构建工具
                                                      ↓
Layer 4: UI 组件库   →  Layer 5: CSS 方案   →  Layer 6: 网络请求库
                                                      ↓
Layer 7: 状态管理    →  Layer 8: 路由       →  Layer 9: 表单验证
                                                      ↓
Layer 10: 测试框架   →  Layer 11: 代码质量   →  Layer 12: 国际化（按需）
```

**规则：** 从 Layer 1 开始逐层选择，每层选一个，前序选择影响后序推荐。

---

### Layer 1: 主框架（互斥选一）

| 方案 | 特点 | 适用场景 |
|------|------|----------|
| React | 生态最大、社区最强、Meta 维护 | 大型应用、复杂交互、国际化产品 |
| Vue | 上手快、中文文档优秀、模板语法直观 | 企业后台、管理系统、国内团队 |
| Svelte | 编译时优化、无虚拟 DOM、包体最小 | 高性能轻量应用、个人项目 |

**选择信号：** 中后台 / 国内团队 / 快速交付 → 倾向 Vue；大型复杂交互 / 国际化 → 倾向 React；极致性能 / 小团队 → 倾向 Svelte。

**互斥原则：** 只能选择一个主框架，选择后锁定。

**用户自定义：** 可输入其他框架（如 Solid、Qwik、Angular），AI Agent 仅做兼容性提示。

---

### Layer 2: 开发语言（互斥选一）

| 方案 | 特点 | 适用场景 |
|------|------|----------|
| TypeScript | 类型安全、IDE 智能提示、重构友好 | 所有正式项目（默认推荐） |
| JavaScript | 无编译开销、学习门槛低 | 小型项目、快速原型、学习用途 |

**选择信号：** 除非是极小型项目或纯学习用途，一律推荐 TypeScript。

---

### Layer 3: 构建工具（互斥选一）

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

**互斥原则：** 只能选择一个 UI 组件库。

---

### Layer 5: CSS 方案（互斥选一）

| 方案 | 特点 | 适用场景 |
|------|------|----------|
| TailwindCSS | 原子化 CSS、开发效率高、包体可控 | 所有项目（默认推荐） |
| CSS Modules | 局部作用域、构建工具原生支持、零依赖 | 简单样式隔离需求 |
| CSS-in-JS（styled-components / Emotion 等） | 动态样式、组件级封装 | React 动态主题需求 |

**选择信号：** 默认 TailwindCSS；选择具体 CSS-in-JS 库前按 0.1/0.3 协议验证其维护状态（部分库已进入维护模式）。

**互斥原则：** 只能选择一个 CSS 主方案（可少量混用，但须明确主方案）。

---

### Layer 6: 网络请求库（互斥选一）

| 方案 | 特点 | 适用场景 |
|------|------|----------|
| Axios | 拦截器机制、请求/响应转换、社区最大 | 所有项目（通用首选） |
| TanStack Query | 数据获取/缓存/同步一体化、自动重试 | 数据驱动应用、需要缓存策略 |
| 原生 fetch 封装 | 零依赖、完全可控、轻量 | 极简项目、特殊请求需求 |

**互斥原则：** 只能选择一个网络请求主方案。

**搭配建议：** Axios + TanStack Query 可组合（Axios 做底层请求，Query 管数据状态），组合时主方案记为 TanStack Query。

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

**互斥原则：** 只能选择一个状态管理方案。

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

**互斥原则：** 只能选择一个路由方案。

---

### Layer 9: 表单验证（互斥选一）

| 方案 | 特点 | 适用场景 |
|------|------|----------|
| Zod | Schema 验证、TypeScript 推断、框架无关 | 所有项目（通用推荐） |
| React Hook Form | React 表单性能最佳、与 Zod 搭配 | React 项目 |
| VeeValidate | Vue 生态表单验证、组件式 API | Vue 项目 |

**互斥原则：** 只能选择一个表单验证方案。

**搭配建议：** React 项目推荐 React Hook Form + Zod；Vue 项目推荐 VeeValidate + Zod。

---

### Layer 10: 测试框架（互斥选一）

| 方案 | 特点 | 适用场景 |
|------|------|----------|
| Vitest | Vite 原生、极快、API 兼容 Jest、零配置 | Vite 项目（默认推荐） |
| Jest | 生态最成熟、社区最大、存量项目多 | 非 Vite 项目、遗留项目 |
| Playwright | E2E 测试、跨浏览器、自动等待 | E2E 测试需求 |

**互斥原则：** 单元测试框架只能选一个；E2E 测试框架可与单元测试框架共存。

**建议：** Vitest（单元测试）+ Playwright（E2E）是当前主流组合。

---

### Layer 11: 代码质量工具（默认启用）

| 方案 | 特点 | 适用场景 |
|------|------|----------|
| ESLint + Prettier | 行业标准、生态最大、规则丰富、IDE 集成好 | 所有项目（默认推荐） |
| Biome | Rust 实现、极快、Lint + Format 一体化 | 追求极致速度、新项目 |
| oxlint | Rust 实现、兼容 ESLint 规则 | 大型项目、性能优先 |

**互斥原则：** 只能选择一个 Lint/Format 主方案（ESLint + Prettier 作为一组方案与其他互斥）。

**搭配建议：** TypeScript 项目加 `@typescript-eslint`；TailwindCSS 项目加官方类名排序插件。

---

### Layer 12: 国际化方案（按需，可跳过）

| 方案 | 特点 | 适用场景 |
|------|------|----------|
| vue-i18n | Vue 官方推荐、Composition API 支持 | Vue 项目 |
| react-intl | ICU MessageFormat、React 生态标准 | React 项目 |
| i18next | 框架无关、生态最大 | 通用、跨框架 |

**互斥原则：** 只能选择一个国际化方案。

**跳过条件：** 纯单语言项目可选择"暂不需要"。

**搭配建议：** 需要翻译 key 自动提取时，i18next 系用 `i18next-parser`，react-intl 系用 `@formatjs/cli`。

---

### 移动端技术

移动端选型独立于前端 Web 选型流程：

| 选项 | 适用场景 |
|------|----------|
| Flutter | 跨平台、高性能 UI |
| React Native | JS/TS 团队、跨平台 |
| UniApp | 小程序 + 移动端、国内市场 |
| Android Native | Android 优先、最大平台集成 |
| iOS Native | iOS 优先、最大平台集成 |

---

## 2.1 子插件自动推荐

用户选择主框架和状态管理后，AI Agent 自动推荐以下配套插件：

### Vue 生态

| 主框架 + 状态管理 | 推荐插件 | 用途 | 是否必装 |
|-------------------|----------|------|----------|
| Vue + Pinia | `pinia-plugin-persistedstate` | 状态持久化（localStorage/sessionStorage） | 推荐 |
| Vue + Pinia | `@pinia/nuxt` | Nuxt 集成（仅 Nuxt 项目） | Nuxt 项目必装 |
| Vue + Vue Router | `unplugin-vue-router` | 文件路由、类型安全路由 | 可选 |
| Vue + Vite | `unplugin-auto-import` | API 自动导入 | 推荐 |
| Vue + Vite | `unplugin-vue-components` | 组件自动导入 | 推荐 |

### React 生态

| 主框架 + 状态管理 | 推荐插件 | 用途 | 是否必装 |
|-------------------|----------|------|----------|
| React + Zustand | `zustand/middleware`（persist） | 状态持久化 | 推荐 |
| React + Redux Toolkit | `redux-persist` | 状态持久化 | 推荐 |
| React + Jotai | `jotai/utils`（atomWithStorage） | 状态持久化 | 推荐 |
| React + React Router | 路由级代码分割方案 | 路由懒加载 | 可选 |
| React + Next.js | `next-auth` | 认证方案 | 按需 |

### Svelte 生态

| 主框架 + 状态管理 | 推荐插件 | 用途 | 是否必装 |
|-------------------|----------|------|----------|
| Svelte + SvelteKit | `@sveltejs/adapter-auto` | 自动部署适配 | 必装 |
| Svelte + Svelte Stores | 自定义 persist store | 状态持久化 | 推荐 |

### 通用推荐（不限框架）

| 插件 | 用途 | 是否必装 |
|------|------|----------|
| `@tanstack/query` | 数据获取与缓存（如未在 Layer 6 选择） | 按需 |
| `dayjs` | 日期处理（轻量） | 推荐 |
| `lodash-es` | 工具函数（按需引入） | 按需 |
| Iconify 系列 | 图标方案（按需加载，按框架选对应集成包） | 推荐 |
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

## 2.3 用户自定义入口

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
用户：Layer 4 我想用 Arco Design
AI Agent：Arco Design 是字节跳动的 UI 库，支持 React 和 Vue。
         - 与 Vue 兼容 ✅
         - 与 React 兼容 ✅
         - 与 Svelte 不兼容 ❌
         请确认是否使用。
用户：确认
AI Agent：已锁定 Layer 4: Arco Design。进入 Layer 5: CSS 方案...
```

---

## 3. 后端技术选型 — 分层互斥选择流程

### 选择流程图

```
Layer 1: 主语言      →  Layer 2: 后端框架   →  Layer 3: API 规范
                                                      ↓
Layer 4: ORM/数据访问 →  Layer 5: 数据库     →  Layer 6: 缓存方案
                                                      ↓
Layer 7: 消息队列    →  Layer 8: 认证方案   →  Layer 9: 日志系统
                                                      ↓
Layer 10: 测试框架   →  Layer 11: 文件存储   →  Layer 12: 定时任务（按需）
```

**规则：** 从 Layer 1 开始逐层选择，每层选一个，前序选择影响后序推荐。

---

### Layer 1: 主语言（互斥选一）

| 方案 | 特点 | 适用场景 |
|------|------|----------|
| Java | 企业级首选、生态最成熟、Spring 生态强大、人才储备多 | 企业级系统、大型项目 |
| Node.js（TypeScript） | 全栈同语言、开发效率高、前后端统一 | 快速开发、全栈团队、中小型项目 |
| Go | 编译型高性能、原生并发、部署简单 | 高性能服务、微服务、云原生 |

**选择信号：** 大型企业系统 / 国内传统企业 → Java；前后端同构 / 快速迭代 → Node.js；高并发 / 云原生 / 基础设施工具 → Go。

**互斥原则：** 只能选择一种主语言，选择后锁定。版本一律选择当前 LTS（按 0.1 协议实时确认）。

**用户自定义：** 可输入其他语言（如 Python、Rust、C#），AI Agent 仅做兼容性提示；Python 的框架候选见 Layer 2。

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

#### Python 生态（用户自定义主语言时推荐）

| 方案 | 特点 | 适用场景 |
|------|------|----------|
| FastAPI | 异步、自动文档、类型安全、性能好 | API 服务、AI 后端 |
| Django | 全栈框架、admin 后台、ORM 内置 | 内容管理、全栈项目 |
| Flask | 轻量、灵活、生态丰富 | 小型项目、微服务 |

**互斥原则：** 只能选择一个后端框架。

---

### Layer 3: API 规范（互斥选一）

| 方案 | 特点 | 适用场景 |
|------|------|----------|
| RESTful | 通用标准、生态最广、前端友好、学习成本低 | 所有项目（通用首选） |
| GraphQL | 灵活查询、按需获取、减少过度请求 | 复杂数据查询、多端适配 |
| gRPC | 高性能、Protobuf 序列化、强类型 | 微服务内部通信、高性能场景 |

**互斥原则：** 只能选择一个 API 主规范（可同时提供 RESTful + gRPC，但主规范只能一个）。

**建议：** 对外 API 用 RESTful，微服务内部通信用 gRPC。

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

**选择信号：** 国内 Java 团队 → MyBatis Plus；国际化 Java 团队 → JPA；Node 项目 → Prisma 优先。

**互斥原则：** 只能选择一个 ORM/数据访问方案。

---

### Layer 5: 数据库（互斥选一）

| 方案 | 特点 | 适用场景 |
|------|------|----------|
| MySQL | 最流行关系型数据库、生态成熟、运维成本低 | 通用业务（默认推荐） |
| PostgreSQL | 高级查询、JSON 支持、扩展性强、GIS | 高级查询、数据分析、GIS |
| MongoDB | 文档型、Schema 灵活、水平扩展 | 文档数据、内容管理、快速迭代 |

**互斥原则：** 只能选择一个主数据库（可搭配辅助数据库如 Redis、ES，但主数据库只能一个）。

**AI Agent 必须说明每个数据库选择的理由。**

---

### Layer 6: 缓存方案（互斥选一）

| 方案 | 特点 | 适用场景 |
|------|------|----------|
| Redis | 最流行缓存、数据结构丰富、持久化、集群 | 所有项目（默认推荐） |
| Memcached | 纯内存缓存、极简、高性能 | 纯缓存场景、极简需求 |
| 进程内缓存（如 Caffeine） | 零网络开销、延迟最低 | 单机缓存、读多写少 |

**互斥原则：** 只能选择一个缓存主方案（Redis + 进程内缓存可组合，但主方案只能一个）。

---

### Layer 7: 消息队列（互斥选一）

| 方案 | 特点 | 适用场景 |
|------|------|----------|
| RabbitMQ | 成熟、路由灵活、AMQP 标准、管理界面好 | 企业级消息（默认推荐） |
| Kafka | 高吞吐、日志流、分布式 | 日志流、大数据、高吞吐 |
| Redis Streams | 无额外组件、轻量、与 Redis 复用 | 小型项目、简单消息 |

**互斥原则：** 只能选择一个消息队列方案。

**建议：** 小型项目用 Redis Streams 即可；中大型项目用 RabbitMQ；日志 / 大数据场景用 Kafka。

---

### Layer 8: 认证方案（互斥选一）

| 方案 | 特点 | 适用场景 |
|------|------|----------|
| JWT | 无状态、跨域友好、移动端适配、生态广 | 前后端分离、移动端（推荐） |
| OAuth2 / OIDC | 第三方认证标准、SSO、社交登录 | SSO、第三方登录、企业认证 |
| Session + Cookie | 传统方案、服务端控制、可强制下线 | 传统 Web 应用、服务端渲染 |

**互斥原则：** 只能选择一个认证主方案。

**建议：** 前后端分离用 JWT；需要 SSO 或社交登录用 OAuth2/OIDC；传统 SSR 用 Session。

---

### Layer 9: 日志系统（根据主语言推荐）

#### Java 生态

| 方案 | 特点 | 适用场景 |
|------|------|----------|
| Logback | Spring Boot 默认、性能好、配置灵活 | Spring Boot 项目（默认） |
| Log4j2 | 异步日志、性能最优 | 高性能日志需求 |
| SLF4J + 自选实现 | 接口标准、可切换实现 | 需要灵活切换日志实现 |

#### Node.js 生态

| 方案 | 特点 | 适用场景 |
|------|------|----------|
| Pino | 性能最优、JSON 日志、传输流 | 高性能服务（推荐） |
| Winston | 最流行、多传输、灵活配置 | 通用项目 |
| 框架内置 Logger | 零依赖、框架集成 | 小型项目 |

#### Go 生态

| 方案 | 特点 | 适用场景 |
|------|------|----------|
| Zap | Uber 出品、零分配、性能最优 | 高性能 Go 服务（推荐） |
| Logrus | 结构化日志、API 友好 | 通用 Go 项目 |
| slog（标准库） | 官方内置、零依赖、结构化 | 新版本 Go 项目 |

**互斥原则：** 只能选择一个日志系统。

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
| Mocha + Chai | 灵活组合、社区成熟 | 自定义测试栈 |

#### Go 生态

| 方案 | 特点 | 适用场景 |
|------|------|----------|
| Go testing（标准库） | 官方内置、零依赖、基准测试 | 所有 Go 项目（默认） |
| testify | 断言库、Mock、Suite | 增强标准库 |
| Ginkgo | BDD 风格测试框架 | BDD 风格偏好 |

**互斥原则：** 只能选择一个测试框架。

---

### Layer 11: 文件存储方案（按需，可跳过）

| 方案 | 特点 | 适用场景 |
|------|------|----------|
| S3 / OSS / COS | 云存储、无限容量、CDN 加速、按量付费 | 云部署项目（默认推荐） |
| MinIO | S3 兼容、自建对象存储、开源免费 | 私有部署、内网项目、成本敏感 |
| 本地文件存储 | 零依赖、最简单、无网络开销 | 单机部署、小型项目、内网工具 |

**互斥原则：** 只能选择一个主文件存储方案（可本地 + 云存储分级，但主方案只能一个）。

**跳过条件：** 纯 API 项目、无文件上传需求可选择"暂不需要"。

**搭配建议：** S3/OSS + 本地缓存是常见组合；MinIO 适合开发环境替代 S3。

---

### Layer 12: 定时任务（按需，可跳过）

#### Java 生态

| 方案 | 特点 | 适用场景 |
|------|------|----------|
| Spring @Scheduled | Spring Boot 内置、零依赖、注解式 | 单机定时任务（简单场景） |
| XXL-Job | 分布式调度、可视化界面、动态配置 | 分布式定时任务（国内团队推荐） |
| Quartz | 功能全、集群支持、持久化 | 复杂调度需求 |

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

**互斥原则：** 只能选择一个定时任务方案。

**跳过条件：** 无定时任务需求可选择"暂不需要"。

---

## 3.1 后端子插件自动推荐

用户选择后端框架和 ORM 后，AI Agent 自动推荐以下配套插件：

### Java 生态

| 框架 + ORM | 推荐插件 | 用途 | 是否必装 |
|------------|----------|------|----------|
| Spring Boot + MyBatis Plus | `mybatis-plus-join` | 多表联查 | 推荐 |
| Spring Boot + MyBatis Plus | `dynamic-datasource` | 多数据源支持 | 按需 |
| Spring Boot + JPA | `spring-data-envers` | 审计日志、数据版本 | 按需 |
| Spring Boot | `spring-boot-starter-actuator` | 健康检查、监控 | 推荐 |
| Spring Boot | `springdoc-openapi` | OpenAPI 文档自动生成 | 推荐 |
| Spring Boot + Spring Cloud | Nacos 等注册/配置中心组件 | 服务注册与配置 | 微服务必装 |
| Spring Boot + 文件存储 | S3 兼容 SDK / MinIO SDK | 对象存储集成 | 文件存储必装 |
| Spring Boot + 定时任务 | `xxl-job-core` | 分布式调度中心 | 分布式定时任务推荐 |

### Node.js 生态

| 框架 + ORM | 推荐插件 | 用途 | 是否必装 |
|------------|----------|------|----------|
| NestJS + Prisma | Prisma NestJS 集成模块 | Prisma 集成 | 推荐 |
| NestJS | `@nestjs/swagger` | Swagger 文档自动生成 | 推荐 |
| NestJS | `@nestjs/throttler` | 限流保护 | 推荐 |
| NestJS | `@nestjs/passport` | 认证策略集成 | 认证必装 |
| NestJS + 文件存储 | S3 SDK / MinIO SDK | 对象存储集成 | 文件存储必装 |
| NestJS + 定时任务 | `@nestjs/schedule` | 定时任务装饰器 | 定时任务必装 |
| Fastify | `@fastify/swagger` | Swagger 文档 | 推荐 |
| Fastify | `@fastify/rate-limit` | 限流保护 | 推荐 |

### Go 生态

| 框架 + ORM | 推荐插件 | 用途 | 是否必装 |
|------------|----------|------|----------|
| Gin + Gorm | `gorm/datatypes` | 扩展数据类型 | 按需 |
| Gin + Gorm | `gorm/hints` | 优化器提示 | 按需 |
| Gin | `swaggo/swag` | Swagger 文档自动生成 | 推荐 |
| Gin | `gin-contrib/cors` | CORS 中间件 | 推荐 |
| Gin | `golang-jwt/jwt` | JWT 认证 | 认证必装 |
| Gin + 文件存储 | S3 / MinIO 的 Go SDK | 对象存储集成 | 文件存储必装 |
| Gin + 定时任务 | `robfig/cron` | 定时任务调度 | 定时任务必装 |

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

| | Spring Boot | Quarkus | NestJS | Express | Gin | Fiber | FastAPI | Django |
|---|---|---|---|---|---|---|---|---|
| **Java** | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ |
| **Node.js** | ❌ | ❌ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| **Go** | ❌ | ❌ | ❌ | ❌ | ✅ | ✅ | ❌ | ❌ |
| **Python** | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ✅ | ✅ |

### 后端框架 × ORM

| | MyBatis Plus | JPA | Prisma | TypeORM | Gorm | sqlx | SQLAlchemy |
|---|---|---|---|---|---|---|---|
| **Spring Boot** | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ |
| **NestJS** | ❌ | ❌ | ✅ | ✅ | ❌ | ❌ | ❌ |
| **Express** | ❌ | ❌ | ✅ | ✅ | ❌ | ❌ | ❌ |
| **Gin** | ❌ | ❌ | ❌ | ❌ | ✅ | ✅ | ❌ |
| **FastAPI** | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ✅ |

### ORM × 数据库

| | MySQL | PostgreSQL | MongoDB |
|---|---|---|---|
| **MyBatis Plus** | ✅ | ✅ | ❌ |
| **JPA/Hibernate** | ✅ | ✅ | ❌ |
| **Prisma** | ✅ | ✅ | ✅ |
| **TypeORM** | ✅ | ✅ | ✅ |
| **Gorm** | ✅ | ✅ | ✅ |
| **sqlx** | ✅ | ✅ | ❌ |
| **SQLAlchemy** | ✅ | ✅ | ✅ |

### 主语言 × 测试框架

| | JUnit 5 | TestNG | Jest | Vitest | Go testing | Pytest |
|---|---|---|---|---|---|---|
| **Java** | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| **Node.js** | ❌ | ❌ | ✅ | ✅ | ❌ | ❌ |
| **Go** | ❌ | ❌ | ❌ | ❌ | ✅ | ❌ |
| **Python** | ❌ | ❌ | ❌ | ❌ | ❌ | ✅ |

### 主语言 × 定时任务方案

| | @Scheduled / @nestjs/schedule | XXL-Job | Quartz | Bull 系 | robfig/cron |
|---|---|---|---|---|---|
| **Java** | ✅ | ✅ | ✅ | ❌ | ❌ |
| **Node.js** | ✅（NestJS） | ❌ | ❌ | ✅ | ❌ |
| **Go** | ❌ | ❌ | ❌ | ❌ | ✅ |

**图例：** ✅ 兼容 | ❌ 不兼容（结构性） | ⚠️ 需额外配置（以实时验证为准）

---

## 3.3 后端用户自定义入口

### 自定义规则

与前端一致：

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
用户：Layer 2 我想用 Hono
AI Agent：Hono 是超轻量 Web 框架，支持 Node.js/Bun/Deno/Edge。
         - 与 Node.js 兼容 ✅
         - 与 TypeScript 兼容 ✅
         - 适合 Edge/Serverless 场景
         请确认是否使用。
用户：确认
AI Agent：已锁定 Layer 2: Hono。进入 Layer 3: API 规范...
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

**互斥原则：** 只能选择一个 CI/CD 主方案。

---

### 错误监控 / APM（互斥选一）

| 方案 | 特点 | 适用场景 |
|------|------|----------|
| Sentry | 前后端通用、开源、生态大、可自托管 | 所有项目（通用推荐） |
| Datadog | 全栈监控、APM + 日志 + 指标、商业方案 | 企业级全栈监控 |
| SkyWalking | Apache 开源、Java 生态强、免费 | Java 微服务、私有化部署 |

**选择信号：** 预算有限/私有化 → Sentry 自托管或 SkyWalking；企业级一体化监控 → Datadog。

**互斥原则：** 只能选择一个错误监控/APM 主方案。

**搭配建议：** 错误监控 + Prometheus + Grafana（指标监控）是开源组合常见实践。

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
| 云平台托管 | 托管服务、减少运维负担 |

---

## 6. 已有项目反向分析

当用户提供 GitHub 地址、Git 仓库或项目压缩包时，AI Agent 必须：

### 分析内容

- 项目结构
- 技术栈
- 依赖版本
- 目录规范
- 架构模式
- 公共组件
- 代码质量

### 输出内容

- 当前项目技术画像
- 推荐优化方案
- 可复用模块
- 待重构模块
- 未来架构建议
