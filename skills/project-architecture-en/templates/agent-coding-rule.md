# Coding Rules (.agent/coding-rule.md)

> Only project-specific conventions go here. Don't repeat industry standards already enforced by tools (e.g., ESLint).

## Language & Style

- Language: <!-- TypeScript / Java / Go / Python -->
- Style tooling: <!-- ESLint + Prettier / Biome / gofmt / black -->
- Naming:
  - Files: <!-- kebab-case / camelCase / snake_case -->
  - Components/Classes: <!-- PascalCase -->
  - Functions/Variables: <!-- camelCase -->
  - Constants: <!-- UPPER_SNAKE_CASE -->

## Project-Specific Rules

<!-- Examples:
- All API requests must go through core/http; business code must never import axios directly
- Dates are handled with dayjs only; never format new Date() inline
- Throw errors via core/error's BusinessError
-->

1.

## Directory Ownership

| Code type | Location |
|-----------|----------|
| Generic utilities | core/utils |
| Business logic | modules/<module>/domain |
| API entry / controllers | modules/<module>/interfaces |
| Data access | modules/<module>/infrastructure |
| Shared components | core/ui/components |

## Forbidden

-
