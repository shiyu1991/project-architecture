# 开发工作流（.agent/workflow.md）

## 分支策略

- 主分支：`main`
- 功能分支：`feature/<scope>-<desc>`
- 修复分支：`fix/<issue>-<desc>`
- 合入方式：PR/MR + 至少 1 人 review（个人项目可自审）

## Commit 规范

Conventional Commits：`feat(order): 支持订单取消原因备注`

type: feat | fix | refactor | docs | test | chore | perf | style

## 新功能开发流程

1. 检查 Core 与已有模块是否已有该能力（复用优先）
2. 在对应模块内按 DDD 分层实现
3. 补充单元测试 + 集成测试
4. 本地验证：Lint → Type Check → Test → Build
5. 提交 PR，描述改动范围与影响
6. 如涉及架构决策，新增 docs/adr/NNN-<title>.md

## 验证命令

```bash
# 按项目实际填写
npm run lint
npm run typecheck
npm run test
npm run build
```

## 发布流程

<!-- 打 tag / 发版环境 / 回滚方式 -->
