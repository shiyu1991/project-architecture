# <项目名>

<!-- 一句话项目介绍：是什么、给谁用、解决什么问题 -->

## 技术架构

本项目采用：Core + Business Module 架构（M/S 级项目删除本段，直接写技术栈列表）

- 技术栈：<!-- 前端 / 后端 / 数据库 / 部署 -->
- 架构决策记录：见 `docs/adr/`

核心原则：

- 公共能力统一维护（core/）
- 业务模块独立开发（modules/）
- 禁止重复建设

## 目录说明

```
├── core        # 公共能力（auth / http / utils / ...）
├── modules     # 业务模块（DDD 分层）
├── docs        # 文档与 ADR
└── tests       # 测试
```

## 开发环境

- 运行时：<!-- Node.js 20 LTS / JDK 17 / Go 1.x / Python 3.x -->
- 依赖安装：`<!-- npm install / mvn install / go mod tidy / pip install -r requirements.txt -->`

## 启动方式

```bash
# 开发
<command>

# 构建
<command>
```

## 部署方式

<!-- 部署目标、发布步骤、环境变量要求 -->

## 环境变量

| 变量名 | 说明 | 必填 | 默认值 |
|--------|------|------|--------|
|  |  |  |  |

> 敏感变量（密码、密钥）禁止写入仓库，使用 `.env.local` 或密钥管理服务。

## API 文档

<!-- 后端项目填写 -->
- 文档地址：<!-- Swagger UI / Postman / 其他 -->
- 规范：<!-- RESTful / GraphQL / gRPC -->

## 故障排查

| 问题 | 原因 | 解决方案 |
|------|------|----------|
|  |  |  |

## FAQ

<!-- 开发过程中常见问题 -->

## 开发规范

- 分支：`feature/*` 从 `main` 切出，PR 合入
- Commit：Conventional Commits
- 新功能必须包含测试，验证通过后方可提交

## AI Agent 规则

AI Agent 参与本项目开发时必须：

1. 先读 `.agent/` 目录与本 README
2. 新功能先检查 core/ 与已有模块，优先复用
3. 遵守 `.agent/coding-rule.md` 与 `.agent/workflow.md`
4. 重要技术决策必须新增 ADR
