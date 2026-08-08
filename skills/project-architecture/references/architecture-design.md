# 架构设计指南

> 项目架构设计、Core 层、DDD 模块、ADR 的详细参考文档。
> 在设计项目架构或规划模块结构时加载本文档。

---

## 1. 项目目录结构

统一架构模式：Core + Business Module + Plugin + Infrastructure + Documentation + Test

> **适用范围：** 本完整结构仅适用于 L 级项目（正式产品 / 团队协作 / 长期维护）。S/M 级项目的简化策略见 SKILL.md 第三节"规模分级"，禁止给小项目套完整架构。

```
project
├── core              # 核心基础能力
├── modules           # 业务模块（DDD）
├── plugins           # 插件扩展
├── infrastructure    # 基础设施层
├── config            # 全局配置
├── docs              # 文档（含 ADR）
├── tests             # 测试
└── README.md
```

---

## 2. Core 层设计

### Core 目标

- **稳定** — 一旦建立极少变更
- **通用** — 适用于所有业务模块
- **低变化** — 修改需要理由和迁移方案
- **高复用** — 为复用而设计，不为特定业务

### Core 禁止

- 绑定具体业务逻辑
- 存放业务代码
- 频繁修改

### Core 目录结构（前端）

```
core
├── auth          # 认证与授权
│   ├── permission
│   ├── role
│   └── token
├── http          # 网络请求层
│   ├── request
│   ├── response
│   └── interceptor
├── ui            # 共享 UI 组件
│   ├── components
│   ├── theme
│   └── layout
├── utils         # 工具函数
│   ├── formatter
│   ├── validator
│   └── helpers
├── storage       # 数据持久化
│   ├── cache
│   └── persistence
├── error         # 异常处理
│   ├── exception
│   └── handler
├── logger        # 日志系统
├── config        # 配置管理
└── index         # 公共导出
```

### Core 目录结构（后端）

后端没有 UI/浏览器存储，Core 结构不同：

```
core
├── auth          # 认证与授权（JWT 签发/校验、权限中间件、角色）
├── middleware    # 全局中间件（CORS、限流、请求日志、链路追踪）
├── database      # 数据访问基座（连接池、事务、基础 Repository）
├── cache         # 缓存抽象（Redis 客户端封装、缓存注解）
├── error         # 统一异常与错误码（全局异常处理器、业务错误码）
├── logger        # 日志系统（结构化日志、脱敏）
├── config        # 配置管理（多环境配置加载、配置校验）
├── utils         # 工具函数（纯函数，无业务）
├── event         # 事件/消息抽象（可选，有消息队列时启用）
└── index         # 公共导出
```

**规则：** 前后端同仓（Monorepo）时，`core/` 拆为 `core/client` 与 `core/server`，禁止混用。

### Core 修改规则

修改 Core 必须记录：

1. **修改原因** — 为什么需要修改
2. **影响范围** — 哪些模块受影响
3. **兼容方案** — 现有代码如何继续工作
4. **迁移方案** — 如何过渡到新版本

---

## 3. 业务模块设计（DDD）

业务模块采用领域驱动设计原则。

### 模块结构

```
modules
└── order
    ├── domain          # 业务规则、实体、值对象
    ├── application      # 业务流程编排、用例
    ├── infrastructure   # 技术实现、数据访问
    ├── interfaces       # API 入口、控制器
    └── tests            # 模块测试
```

### 各层职责

| 层 | 职责 |
|----|------|
| domain | 业务规则、领域模型、实体、值对象 |
| application | 业务流程编排、用例执行 |
| infrastructure | 技术实现、数据库访问、外部服务调用 |
| interfaces | API 入口、控制器、DTO、请求/响应处理 |

---

## 4. 公共能力复用规则

### 新增功能前

必须按顺序检查：

1. **Core** — 该能力是否已存在于 Core？
2. **已有模块** — 能否复用其他模块的能力？
3. **Plugins** — 是否有插件提供该能力？

### 禁止重复创建

- 请求/HTTP 封装（使用 core/http）
- 认证/权限系统（使用 core/auth）
- 日志系统（使用 core/logger）
- 工具函数（使用 core/utils）
- 组件库（使用 core/ui）
- 异常处理（使用 core/error）

### 示例：网络请求

**正确：** 业务代码调用 `api.getUser()`、`api.createOrder()` — 只关注业务逻辑。

**错误：** 业务模块直接调用 `axios.create()`、处理 token、实现错误处理。

---

## 5. 架构决策记录（ADR）

所有重要技术决策必须记录。

### ADR 目录

```
docs
└── adr
    ├── 001-tech-stack.md
    ├── 002-auth.md
    └── 003-database.md
```

### ADR 格式

每个 ADR 文档必须包含：

1. **背景** — 上下文和情况
2. **问题** — 需要做什么决策
3. **候选方案** — 考虑过的选项
4. **最终选择** — 选择了什么及原因
5. **影响范围** — 受影响的模块
6. **未来变化** — 可能导致反转的条件

---

## 6. 前端业务模块结构

前端业务模块与后端 DDD 结构不同，采用功能导向组织：

```
modules
└── order
    ├── api              # 模块 API 调用（调用 core/http）
    ├── components/      # 模块专属组件
    │   ├── OrderList.vue
    │   ├── OrderDetail.vue
    │   └── OrderForm.vue
    ├── composables/     # 组合式逻辑（Vue）/ hooks（React）
    │   ├── useOrder.ts
    │   └── useOrderStatus.ts
    ├── stores/          # 模块状态（Pinia / Zustand）
    │   └── orderStore.ts
    ├── types/           # 模块类型定义
    │   └── order.d.ts
    ├── views/           # 页面级组件
    │   ├── OrderListView.vue
    │   └── OrderDetailView.vue
    ├── routes.ts        # 模块路由定义
    └── index.ts         # 模块公共导出
```

**规则：**
- 模块内组件不直接引用其他模块组件，跨模块通信走 Core 或事件机制
- 模块 API 调用必须通过 `core/http`，禁止直接 import axios/fetch
- 模块状态独立管理，全局共享状态放 Core

---

## 7. 模块通信模式

### 7.1 后端模块间通信

| 模式 | 适用场景 | 示例 |
|------|----------|------|
| 直接调用（同进程） | 同一服务内模块间 | Order 模块调用 Inventory 模块的 Application Service |
| 事件驱动（异步） | 解耦、跨模块通知 | Order 创建后发事件，Inventory 消费扣减库存 |
| API 调用（跨服务） | 微服务架构 | Order 服务调用 Payment 服务的 REST API |
| 消息队列（跨服务异步） | 微服务异步通信 | Order 服务发消息到 MQ，Shipping 服务消费 |

**规则：**
- 同进程模块间直接调用，走 Application Service 层，不走 interfaces 层
- 跨模块直接调用必须通过依赖注入，禁止硬编码依赖
- 事件驱动必须定义清晰的事件 Schema（推荐用 ADR 记录）

### 7.2 前端模块间通信

| 模式 | 适用场景 | 示例 |
|------|----------|------|
| Props / Events | 父子组件通信 | OrderList 向父组件 emit 选中事件 |
| 全局状态（Core Store） | 跨模块共享状态 | 用户信息、权限在 Core/auth store |
| 事件总线（轻量级） | 无状态依赖的跨组件通知 | 显示全局 Toast、刷新数据列表 |
| 路由参数 | 页面间数据传递 | 订单列表跳详情页传 orderId |

**规则：**
- 跨模块共享状态放 Core Store（如用户信息、权限、全局配置）
- 模块私有状态放模块内 Store
- 禁止模块间直接 import 组件，需要复用则提升到 Core/ui

---

## 8. 数据库迁移策略

### 8.1 迁移工具选择

| 技术栈 | 迁移工具 | 说明 |
|--------|----------|------|
| Node.js + Prisma | Prisma Migrate | 内置，Schema 优先 |
| Node.js + TypeORM | TypeORM Migrations | 内置 |
| Java + MyBatis Plus / JPA | Flyway / Liquibase | Flyway 简单、Liquibase 功能强 |
| Go + Gorm | golang-migrate / Gorm AutoMigrate | golang-migrate 更规范 |
| Python + SQLAlchemy | Alembic | SQLAlchemy 官方推荐 |
| Python + Django | Django Migrations | 内置 |

### 8.2 迁移规范

- **每次 Schema 变更必须生成迁移脚本**，禁止手动改数据库
- **迁移脚本一旦提交不可修改**，需要回滚则新建反向迁移
- **破坏性变更（删列、改类型）必须分两步**：先标记废弃 → 下个版本删除
- **迁移脚本必须可回滚**（除非数据丢失不可避免，需在 ADR 中说明）
- **生产环境迁移前必须在测试环境验证**

---

## 9. API 版本策略

| 策略 | 适用场景 | 示例 |
|------|----------|------|
| URL 版本 | RESTful API 通用 | `/api/v1/orders`、`/api/v2/orders` |
| Header 版本 | 对 URL 洁净度有要求 | `Accept: application/vnd.api+json;version=1` |
| 不版本化 | 内部 API、快速迭代期 | 直接 `/api/orders`，用功能开关控制 |

**规则：**
- 对外公开 API 必须版本化
- 内部 API 可不版本化，但必须文档化破坏性变更
- 版本废弃必须提前通知，保留至少 2 个版本的过渡期

---

## 10. 依赖注入（DI）

### 后端 DI

| 技术栈 | DI 方案 | 说明 |
|--------|---------|------|
| NestJS | 内置 IoC 容器 | `@Injectable()` + 构造函数注入 |
| Spring Boot | Spring IoC | `@Component` / `@Service` + `@Autowired` |
| Go | 手动注入 / wire / fx | 推荐 wire 编译时生成 |
| FastAPI | FastAPI Depends | 函数级依赖注入 |

**规则：**
- 依赖注入在 Application 层完成，Domain 层不依赖具体实现
- 接口定义在 Domain 层，实现在 Infrastructure 层
- 禁止在 Domain 层直接 new 具体类

---

## 11. Monorepo 结构（L 级可选）

当项目包含前端 + 后端 + 共享类型时，采用 Monorepo：

```
project
├── packages/
│   ├── shared/          # 前后端共享类型、常量、工具函数
│   ├── client/          # 前端应用
│   │   ├── core/
│   │   ├── modules/
│   │   └── ...
│   ├── server/          # 后端应用
│   │   ├── core/
│   │   ├── modules/
│   │   └── ...
│   └── admin/           # 管理后台（可选）
├── package.json         # Monorepo 根配置
├── turbo.json / nx.json # 构建编排配置
└── README.md
```

**工具选择：**
- **pnpm workspaces** — 通用 Monorepo 管理（推荐）
- **Turborepo** — 构建缓存、并行任务
- **Nx** — 代码生成、依赖图分析

**规则：**
- `packages/shared/` 放前后端共享的 TypeScript 类型、枚举、常量
- 前端 Core 和后端 Core 独立，不混用
- 每个包有自己的 `package.json`，通过 workspace 协议引用