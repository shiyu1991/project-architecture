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