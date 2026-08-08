# 编码规范（.agent/coding-rule.md）

> 只写本项目特有的约定；行业通用规范（如 ESLint 已强制的）不重复写。

## 语言与风格

- 语言：<!-- TypeScript / Java / Go / Python -->
- 风格工具：<!-- ESLint + Prettier / Biome / gofmt / black -->
- 命名约定：
  - 文件：<!-- kebab-case / camelCase / snake_case -->
  - 组件/类：<!-- PascalCase -->
  - 函数/变量：<!-- camelCase -->
  - 常量：<!-- UPPER_SNAKE_CASE -->

## 项目特有规则

<!-- 示例：
- 所有 API 请求必须通过 core/http 的封装，禁止业务代码直接 import axios
- 日期处理统一用 dayjs，禁止 new Date() 直接格式化
- 错误抛出统一用 core/error 的 BusinessError
-->

1.

## 目录归属规则

| 代码类型 | 放置位置 |
|----------|----------|
| 通用工具函数 | core/utils |
| 业务逻辑 | modules/<模块>/domain |
| API 入口/控制器 | modules/<模块>/interfaces |
| 数据访问 | modules/<模块>/infrastructure |
| 共享组件 | core/ui/components |

## 禁止事项

-
