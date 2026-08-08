# Architecture Design Guide

> Detailed reference for project architecture design, the Core layer, DDD modules, and ADRs.
> Load this document when designing project architecture or planning module structure.

---

## 1. Project Directory Structure

Unified architecture pattern: Core + Business Modules + Plugins + Infrastructure + Documentation + Tests

> **Applicability:** This full structure applies ONLY to Tier-L projects (real products / team collaboration / long-term maintenance). Simplified strategies for S/M tiers are in SKILL.md section 3 "Scale Tiers". Never force the full architecture onto small projects.

```
project
├── core              # Core foundational capabilities
├── modules           # Business modules (DDD)
├── plugins           # Plugin extensions
├── infrastructure    # Infrastructure layer
├── config            # Global configuration
├── docs              # Documentation (incl. ADRs)
├── tests             # Tests
└── README.md
```

---

## 2. Core Layer Design

### Core Goals

- **Stable** — changes rarely once established
- **Generic** — applies to all business modules
- **Low-churn** — modifications require justification and a migration plan
- **Highly reused** — designed for reuse, not for a specific business

### Core Forbidden

- Binding to specific business logic
- Hosting business code
- Frequent modification

### Core Directory Structure (Frontend)

```
core
├── auth          # Authentication & authorization
│   ├── permission
│   ├── role
│   └── token
├── http          # HTTP layer
│   ├── request
│   ├── response
│   └── interceptor
├── ui            # Shared UI components
│   ├── components
│   ├── theme
│   └── layout
├── utils         # Utility functions
│   ├── formatter
│   ├── validator
│   └── helpers
├── storage       # Data persistence
│   ├── cache
│   └── persistence
├── error         # Error handling
│   ├── exception
│   └── handler
├── logger        # Logging system
├── config        # Configuration management
└── index         # Public exports
```

### Core Directory Structure (Backend)

The backend has no UI or browser storage — its Core structure differs:

```
core
├── auth          # Authentication & authorization (JWT issue/verify, permission middleware, roles)
├── middleware    # Global middleware (CORS, rate limiting, request logging, tracing)
├── database      # Data access foundation (connection pool, transactions, base Repository)
├── cache         # Cache abstraction (Redis client wrapper, cache annotations)
├── error         # Unified exceptions & error codes (global exception handler, business error codes)
├── logger        # Logging system (structured logs, redaction)
├── config        # Configuration management (multi-env loading, config validation)
├── utils         # Utility functions (pure functions, no business logic)
├── event         # Event/messaging abstraction (optional; enable when a message queue exists)
└── index         # Public exports
```

**Rule:** In a monorepo containing both frontend and backend, split `core/` into `core/client` and `core/server`. Never mix them.

### Core Modification Rules

Every Core modification must record:

1. **Reason** — why the change is needed
2. **Impact scope** — which modules are affected
3. **Compatibility plan** — how existing code keeps working
4. **Migration plan** — how to transition to the new version

---

## 3. Business Module Design (DDD)

Business modules follow Domain-Driven Design principles.

### Module Structure

```
modules
└── order
    ├── domain          # Business rules, entities, value objects
    ├── application      # Business flow orchestration, use cases
    ├── infrastructure   # Technical implementation, data access
    ├── interfaces       # API entry points, controllers
    └── tests            # Module tests
```

### Layer Responsibilities

| Layer | Responsibility |
|-------|---------------|
| domain | Business rules, domain models, entities, value objects |
| application | Business flow orchestration, use case execution |
| infrastructure | Technical implementation, database access, external service calls |
| interfaces | API entry points, controllers, DTOs, request/response handling |

---

## 4. Shared Capability Reuse Rules

### Before Adding a Feature

Check in this order:

1. **Core** — does the capability already exist in Core?
2. **Existing modules** — can another module's capability be reused?
3. **Plugins** — does a plugin provide this capability?

### Never Re-create

- Request/HTTP wrappers (use core/http)
- Auth/permission systems (use core/auth)
- Logging systems (use core/logger)
- Utility functions (use core/utils)
- Component libraries (use core/ui)
- Error handling (use core/error)

### Example: HTTP Requests

**Correct:** business code calls `api.getUser()`, `api.createOrder()` — focusing only on business logic.

**Wrong:** a business module calls `axios.create()` directly, handles tokens, and implements its own error handling.

---

## 5. Architecture Decision Records (ADR)

All significant technical decisions must be recorded.

### ADR Directory

```
docs
└── adr
    ├── 001-tech-stack.md
    ├── 002-auth.md
    └── 003-database.md
```

### ADR Format

Each ADR must contain:

1. **Context** — the situation and circumstances
2. **Problem** — what decision is needed
3. **Options considered** — alternatives evaluated
4. **Decision** — what was chosen and why
5. **Consequences** — affected modules
6. **Future reversal conditions** — what could overturn this decision

---

## 6. Frontend Business Module Structure

Frontend business modules differ from backend DDD — they use a feature-oriented organization:

```
modules
└── order
    ├── api              # Module API calls (via core/http)
    ├── components/      # Module-specific components
    │   ├── OrderList.vue
    │   ├── OrderDetail.vue
    │   └── OrderForm.vue
    ├── composables/     # Composition logic (Vue) / hooks (React)
    │   ├── useOrder.ts
    │   └── useOrderStatus.ts
    ├── stores/          # Module state (Pinia / Zustand)
    │   └── orderStore.ts
    ├── types/           # Module type definitions
    │   └── order.d.ts
    ├── views/           # Page-level components
    │   ├── OrderListView.vue
    │   └── OrderDetailView.vue
    ├── routes.ts        # Module route definitions
    └── index.ts         # Module public exports
```

**Rules:**
- Module components MUST NOT directly import other modules' components — cross-module communication goes through Core or event mechanisms
- Module API calls MUST go through `core/http` — never import axios/fetch directly
- Module state is managed independently; global shared state goes in Core

---

## 7. Module Communication Patterns

### 7.1 Backend Inter-Module Communication

| Pattern | Use case | Example |
|---------|----------|---------|
| Direct call (same process) | Between modules in the same service | Order module calls Inventory module's Application Service |
| Event-driven (async) | Decoupling, cross-module notification | Order created → event → Inventory consumes to deduct stock |
| API call (cross-service) | Microservice architecture | Order service calls Payment service's REST API |
| Message queue (cross-service async) | Microservice async communication | Order service sends message to MQ, Shipping service consumes |

**Rules:**
- Same-process direct calls go through the Application Service layer, not the interfaces layer
- Cross-module direct calls must use dependency injection — no hardcoded dependencies
- Event-driven communication must define clear event schemas (recommend recording via ADR)

### 7.2 Frontend Inter-Module Communication

| Pattern | Use case | Example |
|---------|----------|---------|
| Props / Events | Parent-child component communication | OrderList emits select event to parent |
| Global state (Core Store) | Cross-module shared state | User info, permissions in Core/auth store |
| Event bus (lightweight) | Stateless cross-component notification | Show global Toast, refresh data lists |
| Route params | Page-to-page data passing | Order list → detail page passing orderId |

**Rules:**
- Cross-module shared state goes in Core Store (user info, permissions, global config)
- Module-private state stays in the module's own Store
- Never directly import components across modules — promote to Core/ui for reuse

---

## 8. Database Migration Strategy

### 8.1 Migration Tool Selection

| Tech stack | Migration tool | Notes |
|-----------|---------------|-------|
| Node.js + Prisma | Prisma Migrate | Built-in, schema-first |
| Node.js + TypeORM | TypeORM Migrations | Built-in |
| Java + MyBatis Plus / JPA | Flyway / Liquibase | Flyway is simpler; Liquibase is more powerful |
| Go + Gorm | golang-migrate / Gorm AutoMigrate | golang-migrate is more standard |
| Python + SQLAlchemy | Alembic | Officially recommended by SQLAlchemy |
| Python + Django | Django Migrations | Built-in |

### 8.2 Migration Standards

- **Every schema change MUST generate a migration script** — never modify the database manually
- **Committed migration scripts are immutable** — create a reverse migration to roll back
- **Destructive changes (drop column, change type) MUST be two steps:** mark deprecated first → delete in the next version
- **Migration scripts MUST be reversible** (unless data loss is unavoidable, documented in an ADR)
- **Test migrations in a test environment before production**

---

## 9. API Versioning Strategy

| Strategy | Use case | Example |
|----------|----------|---------|
| URL versioning | General RESTful API | `/api/v1/orders`, `/api/v2/orders` |
| Header versioning | When URL cleanliness matters | `Accept: application/vnd.api+json;version=1` |
| No versioning | Internal API, rapid iteration | `/api/orders` directly, feature flags control behavior |

**Rules:**
- Public-facing APIs MUST be versioned
- Internal APIs may skip versioning but MUST document breaking changes
- Version deprecation requires advance notice and at least 2 versions of transition period

---

## 10. Dependency Injection (DI)

### Backend DI

| Tech stack | DI solution | Notes |
|-----------|-------------|-------|
| NestJS | Built-in IoC container | `@Injectable()` + constructor injection |
| Spring Boot | Spring IoC | `@Component` / `@Service` + `@Autowired` |
| Go | Manual injection / wire / fx | wire recommended for compile-time generation |
| FastAPI | FastAPI Depends | Function-level dependency injection |

**Rules:**
- DI happens at the Application layer; the Domain layer does not depend on concrete implementations
- Interfaces are defined in the Domain layer; implementations in the Infrastructure layer
- Never `new` concrete classes directly in the Domain layer

---

## 11. Monorepo Structure (Tier-L optional)

When a project includes frontend + backend + shared types, use a Monorepo:

```
project
├── packages/
│   ├── shared/          # Shared types, constants, utility functions (FE+BE)
│   ├── client/          # Frontend application
│   │   ├── core/
│   │   ├── modules/
│   │   └── ...
│   ├── server/          # Backend application
│   │   ├── core/
│   │   ├── modules/
│   │   └── ...
│   └── admin/           # Admin dashboard (optional)
├── package.json         # Monorepo root config
├── turbo.json / nx.json # Build orchestration config
└── README.md
```

**Tool selection:**
- **pnpm workspaces** — general Monorepo management (recommended)
- **Turborepo** — build caching, parallel tasks
- **Nx** — code generation, dependency graph analysis

**Rules:**
- `packages/shared/` holds TypeScript types, enums, constants shared between FE and BE
- Frontend Core and backend Core are independent — never mix them
- Each package has its own `package.json`, referencing others via the workspace protocol
