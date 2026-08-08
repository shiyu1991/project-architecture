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
