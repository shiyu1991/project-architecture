# Development Workflow (.agent/workflow.md)

## Branching Strategy

- Main branch: `main`
- Feature branches: `feature/<scope>-<desc>`
- Fix branches: `fix/<issue>-<desc>`
- Merge method: PR/MR + at least 1 reviewer (self-review acceptable for solo projects)

## Commit Convention

Conventional Commits: `feat(order): support cancellation reason note`

type: feat | fix | refactor | docs | test | chore | perf | style

## New Feature Flow

1. Check whether Core or existing modules already provide the capability (reuse first)
2. Implement within the module following DDD layering
3. Add unit tests + integration tests
4. Verify locally: Lint → Type Check → Test → Build
5. Open a PR describing the change scope and impact
6. If an architectural decision is involved, add docs/adr/NNN-<title>.md

## Verification Commands

```bash
# Fill in per project
npm run lint
npm run typecheck
npm run test
npm run build
```

## Release Process

<!-- Tagging / release environments / rollback procedure -->
