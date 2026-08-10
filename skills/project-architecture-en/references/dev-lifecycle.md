# Development Lifecycle & Standards

> Detailed reference for the AI development lifecycle, code modification rules, testing, security, and documentation.
> Load this document when writing code, creating tests, or establishing development standards.

---

## 1. AI Development Lifecycle

Project tasks MUST follow the lifecycle appropriate to their scale and risk:

- **Tier S, low risk**: Understand → Implement → Verify → Summarize
- **Tier M, low risk**: Understand → Analyze → Design → Implement → Verify → Summarize
- **Tier L or any high-risk project**: full six phases plus security, release, and rollback gates

Any trimmed phase MUST be explained in the summary; it must never be skipped silently.

Read:
- Project docs (README.md, .agent/context.md, .agent/architecture.md, .agent/coding-rule.md)
- Related modules
- Existing code

### Phase 2: Analyze

Confirm:
- Does a usable capability already exist?
- Can existing code be reused?
- Which modules are affected?
- Is new architecture needed?

### Phase 3: Design

Output:
- Files to modify
- Files to add
- Files to delete
- Impact scope
- Risks

### Phase 4: Implement

Requirements:
- Small-scope changes
- Match project style
- No unrelated refactoring

### Phase 5: Verify

Run:
- Lint (code style)
- Type Check (type safety)
- Test (unit, integration, core-flow tests)
- Build (compile & bundle)

### Phase 6: Summarize

Output:
- What changed
- Why it changed
- Impact scope
- Test results
- Follow-up suggestions

---

## 2. Git Workflow Standards

### Branching Strategy

| Branch | Purpose | Rules |
|--------|---------|-------|
| `main` / `master` | Production-ready code | Only accepts PR/MR merges; no direct pushes |
| `develop` | Integration branch (optional; small teams may skip) | Convergence point for feature branches |
| `feature/<scope>-<desc>` | New features | Cut from main/develop; merge back via PR |
| `fix/<issue>-<desc>` | Bug fixes | Same as above |
| `chore/<desc>` | Build, deps, housekeeping | Same as above |

Small teams / solo projects can use just `main + feature/*`; `develop` is not mandatory.

### Commit Convention (Conventional Commits)

```
<type>(<scope>): <subject>

type: feat | fix | refactor | docs | test | chore | perf | style
Example: feat(order): support cancellation reason note
```

Rules:

- One commit does one thing; the AI Agent should suggest a separate commit after each Phase 4 implementation
- Subject in imperative mood, ≤ 72 characters
- Mark breaking changes in the footer with `BREAKING CHANGE:`

---

## 3. Code Modification Rules

### Small-Scope Principle

**Forbidden:** modifying large amounts of unrelated code at once.

### Core Modification Rules

Every Core modification must record:

1. **Reason** — why the change is needed
2. **Impact scope** — which modules are affected
3. **Compatibility plan** — how existing code keeps working
4. **Migration plan** — how to transition to the new version

### Deletion Rules

Before deleting code, check:

- **References** — is the code referenced elsewhere?
- **Backward compatibility** — are there external dependents?
- **API impact** — does it affect public APIs?

---

## 4. Testing Standards

### Required Test Types

New features must include:

| Test type | Scope |
|-----------|-------|
| Unit tests | Individual functions, methods, classes |
| Integration tests | Module interactions, API endpoints |
| Core-flow tests | End-to-end critical business paths |

### Coverage Requirements

Tests must cover:

- **Happy path** — expected use cases
- **Error paths** — error handling, invalid input
- **Edge cases** — boundary conditions, extreme values

### Test Directory Structure

```
tests/
├── unit/               # Unit tests (mirrors source directory structure)
│   ├── core/
│   │   ├── auth/
│   │   └── http/
│   └── modules/
│       └── order/
├── integration/        # Integration tests (module interactions, API endpoints)
│   └── order-api.test.ts
└── e2e/                # End-to-end tests (critical business flows)
    └── order-flow.test.ts
```

**Rules:**
- Unit test files live alongside source or in `__tests__` subdirectories — follow project conventions
- Integration tests go in `tests/integration/`, named `<module>-api.test.ts`
- E2E tests go in `tests/e2e/`, named `<flow-name>-flow.test.ts`

### Mock Strategy

| Scenario | Mock strategy |
|----------|--------------|
| Unit tests | Mock external dependencies (database, HTTP, filesystem) |
| Integration tests | Use real database (test DB) or in-memory DB; mock external APIs |
| E2E tests | No mocks; use a full test environment |

**Rules:**
- Mocks are created at test boundaries — they must never invade business code
- Business code never hardcodes mock logic — testability is achieved via dependency injection
- External API mocks use record-replay (e.g., Pact / MSW) to preserve real response structures

### Test Data Management

- **Test data factories** — use factory functions or Builder pattern to generate test data; never hardcode in tests
- **Test database** — reset before each test run; initialize with migration scripts
- **Fixtures** — shared test data goes in `tests/fixtures/`, organized by module

---

## 5. Security Standards

### Forbidden

- Hardcoded passwords in code
- Committing API keys to the repository
- Exposing database credentials in source
- Logging sensitive information

### Required

- **Environment variables** — all secrets and config via env vars
- **Permission checks** — verify permissions on all sensitive operations
- **Input validation** — validate all external input
- **Log redaction** — mask sensitive data in logs
- **Security audits** — review access patterns periodically

---

## 6. README Standards

Every project must include a README.md with:

1. **Project introduction** — what it is and what it does
2. **Technical architecture** — stack and architecture overview
3. **Directory guide** — key directories explained
4. **Development environment** — prerequisites and setup
5. **Getting started** — how to run locally
6. **Deployment** — how to deploy to production
7. **Development standards** — coding conventions and rules
8. **AI Agent rules** — working guidelines for AI Agents

### Architecture Description Template

```
This project uses: Core + Business Module architecture

Core principles:
- Shared capabilities maintained centrally
- Business modules developed independently
- No duplicate infrastructure

Core directory responsibilities:
- auth: Authentication & authorization
- http: HTTP request handling
- ui: Shared UI components
- utils: Utility functions
- storage: Data persistence
- error: Error handling
- logger: Logging system
- config: Configuration management

New feature flow:
1. Check Core capabilities
2. Check existing modules
3. Prefer reuse
4. Add business code
5. Update documentation
```

---

## 7. AI Agent Behavior Protocol

### When Entering a Project

**Must:**

1. Read the documentation
2. Understand the architecture
3. Prefer reuse
4. Match project style
5. Record changes

**Forbidden:**

1. Creating duplicate structures
2. Reinventing the wheel
3. Breaking existing designs
4. Upgrading dependencies without justification

---

## 8. Architecture Evolution Principles

### Long-Term Layers

| Layer | Characteristics |
|-------|----------------|
| Stable core layer | Rarely changes, highly reused, foundation of all modules |
| Fast business layer | Rapid iteration, independent modules, DDD structure |
| Plugin extension layer | Optional capabilities, pluggable, isolated |
| AI automation layer | Automated testing, deployment, code quality checks |

### Ultimate Goal

Build an **AI Native Software System** that is:

- **Maintainable** — clear structure, documented decisions
- **Extensible** — modular design, plugin architecture
- **Reusable** — Core capabilities shared across modules
- **Testable** — comprehensive test coverage at every layer
- **AI-sustainable** — AI Agents can keep contributing without degrading quality
