---
name: project-architecture-en
description: >-
  Enterprise-grade project initialization, architecture design, and continuous development
  standards for AI Coding Agents. Covers project bootstrapping, tech-stack selection,
  architecture design, module planning, AI Agent development workflow, and long-term
  maintenance. Serves three audiences: non-technical beginners (fully guided), product
  managers (business-to-tech translation), and developers (fast-track selection).
  Enforces senior-architect practices: understand before coding, Core + business module
  separation, DDD module design, ADR decision records, and a 6-phase dev lifecycle.
---

# AI Native Project Architecture Skill V5.0 (English)

> Enterprise-grade project initialization, architecture design, and continuous development standards for AI Coding Agents.
>
> Works with: OpenAI Codex / Claude Code / CodeBuddy / Cursor Agent / OpenCode / Devin-like AI software engineering agents.

---

# 1. Purpose

Guides AI Agents to perform, at a senior software architect level: project initialization, tech-stack selection, architecture design, module planning, coding, maintenance, and architecture evolution.

Core goals: sound technology choices, decoupled business and tech, shared capability reuse, lower system complexity, stronger AI continuous-development ability, and long-term maintainability.

Core principles:

- Understand before designing
- Design architecture before coding
- Abstract before implementing
- Reuse before extending
- Verify before committing

---

# 2. Three User Modes (mandatory at kickoff)

On first contact, the AI Agent MUST identify the user type with one question and switch to the matching interaction mode:

| Mode | Persona | Interaction style |
|------|---------|-------------------|
| 🌱 Guided | Non-technical beginner | Plain language throughout. At each layer, offer "recommended option + one-sentence human explanation". The user can complete the entire selection by simply answering "use the recommendation". No jargon unless asked. |
| 📋 Product | Product manager / business side | Focus on business requirement modeling (users, flows, data, boundaries) and produce a domain-model sketch. For tech selection, present only the final list with a short rationale — do not interrupt layer by layer. |
| ⚡ Expert | Developer / tech lead | Confirm only the key decision points, auto-fill defaults, and quickly output the complete tech-stack list. |

Detection signals:

- "I want to build X but I'm not technical" → Guided mode
- Input is a PRD / business description / prototype → Product mode
- User speaks in tech terms ("Vue or React?") → Expert mode
- When unsure, ask: "To help you best, which fits you: A. I'm not technical — decide for me. B. I know the business — you recommend the tech. C. I'm a developer — let's move fast."

---

# 3. Scale Tiers (anti-over-engineering)

**Not every project needs the full architecture.** Determine project scale BEFORE starting. Never force a big architecture onto a small project:

| Tier | Signals | Architecture strategy |
|------|---------|----------------------|
| S: script / prototype / one-off tool | single file suffices, no deployment, disposable | Just write it. No Core/modules/ADRs. Minimal README only. |
| M: small app / personal project | 1-3 feature modules, solo dev, lifespan < 6 months | Simplified: `src/` + `README.md`, optional `.agent/context.md`, no ADRs |
| L: real product / team collaboration | multiple modules, multiple contributors, long-term maintenance, deployment & ops | Full architecture: Core + DDD modules + ADR + 6-phase lifecycle |

**Default assumption is Tier M.** Upgrade to L only on clear signals (team collaboration, long-term maintenance, enterprise-grade, multiple developers). Never default to the full architecture.

---

# 4. Supreme Execution Principles for AI Agents

Any AI Agent entering a project MUST follow this sequence:

1. Read project docs → 2. Analyze project structure → 3. Understand existing architecture → 4. Check existing capabilities → 5. Design the change → 6. Implement → 7. Verify → 8. Summarize

Forbidden:

- Writing code without understanding the project
- Generating a full feature from a one-line requirement
- Re-creating capabilities that already exist
- Arbitrarily modifying core architecture
- Adding dependencies without justification
- Large-scale aimless refactoring

---

# 5. Project Context Management

The AI Agent MUST read the following first to build project awareness:

```
.agent/
├── context.md          # Project positioning & business background
├── architecture.md     # Architecture decisions & structure
├── coding-rule.md      # Coding conventions
├── workflow.md         # Development workflow
└── docs/adr/           # Architecture Decision Records
```

Plus: `README.md`, the project directory tree, and dependency manifests (`package.json` / `pom.xml` / `go.mod` / `requirements.txt`).

The AI must be clear about: project positioning, business goals, technical architecture, core modules, shared capabilities, technical constraints, deployment model, and potential risks.

**When initializing a new project**: generate the `.agent/` four-file set and the README from `templates/`. Never write them from scratch.

---

# 6. Requirement Analysis Standard

Every requirement MUST be decomposed into:

```
Business requirement layer → Domain model layer → Application service layer → Technical implementation layer → Infrastructure layer
```

Forbidden: mapping a business description directly onto a tech solution.

Anti-pattern:

```
User: "I want to build an e-commerce system"
AI: "Use Vue + SpringBoot + MySQL"   ← WRONG: business analysis was skipped
```

Correct flow: analyze the business first (users, products, orders, payments, inventory, marketing), then design the tech (frontend framework, backend framework, database, cache, messaging, auth, deployment).

In Product mode, this phase outputs a **domain-model sketch + core user flows**, which must be confirmed by the user before tech selection begins.

---

# 7. Tech Selection Overview

Tech selection uses **layered, mutually exclusive, guided choice**: proceed layer by layer in order; earlier choices constrain later options; within each layer pick exactly one; offer Top 3 candidates per layer (versions resolved in real time, never hardcoded); the user may skip recommendations with custom input, and the AI only raises compatibility warnings.

**Frontend 12 layers**: Main framework → Language → Build tool → UI library → CSS approach → HTTP client → State management → Router → Form validation → Test framework → Code quality tools → i18n (optional)

**Backend 12 layers**: Main language → Backend framework → API style → ORM/data access → Database → Cache → Message queue → Auth → Logging → Test framework → File storage (optional) → Scheduling (optional)

**Cross-cutting concerns**: after frontend and backend selection, guide the user through CI/CD and error monitoring/APM choices.

Interaction adapts to the mode:

- Guided: at each layer ask only "I recommend X because (one plain sentence). OK?" — batch-confirm without breaking flow
- Expert: expand the Top 3 comparison table layer by layer
- All modes: dynamic version resolution (`npm view <pkg> version` / Maven Central / Go Module Proxy / PyPI); never reuse stale version numbers from docs

For detailed candidates, selection signals, compatibility matrices, and plugin recommendations, see `references/tech-stack-guide.md`.

---

# 8. Overall Project Architecture

Tier-L projects uniformly adopt: **Core + Business Modules + Plugins + Infrastructure + Documentation + Tests**

```
project
├── core              # Core capabilities (frontend and backend differ — see references)
├── modules           # Business modules (DDD)
├── plugins           # Plugin extensions
├── infrastructure    # Infrastructure layer
├── config            # Global configuration
├── docs              # Documentation (incl. ADRs)
├── tests             # Tests
└── README.md
```

Key rules (details in `references/architecture-design.md`):

- **Core**: stable, generic, low-churn, highly reused; MUST NOT contain business code; frontend Core and backend Core have different structures
- **Business modules**: DDD four layers — `domain / application / infrastructure / interfaces`
- **Reuse rule**: before adding a feature, check in order: Core → existing modules → Plugins. Never reinvent the wheel.
- **ADR**: record every significant technical decision in `docs/adr/`; format in `references/architecture-design.md` section 5

---

# 9. AI Development Lifecycle

Every task MUST pass through 6 phases (details in `references/dev-lifecycle.md`):

1. **Understand** — read docs, related modules, existing code
2. **Analyze** — does the capability exist, can it be reused, what's impacted, is new architecture needed
3. **Design** — output the list of files to modify/add/delete, impact scope, risks
4. **Implement** — small-scope changes, match project style, no unrelated refactoring
5. **Verify** — Lint → Type Check → Test → Build
6. **Summarize** — what changed, why, impact scope, test results, follow-ups

Git workflow (branching strategy, commit conventions): `references/dev-lifecycle.md` section 2.

---

# 10. Red Lines (all modes)

- **Testing**: new features require unit + integration tests covering happy path, errors, and boundaries
- **Security**: never hardcode passwords, commit API keys, expose database credentials, or log sensitive data; always use environment variables, permission checks, input validation, and log redaction
- **Core changes**: must document reason, impact scope, compatibility plan, and migration plan
- **Deleting code**: check references, backward compatibility, and API impact first
- **README**: every project must have a README.md (8 required elements in `references/dev-lifecycle.md` section 6)

---

# 11. Reference Index

| Document | Load when |
|----------|-----------|
| `references/tech-stack-guide.md` | Performing tech selection or analyzing an existing stack |
| `references/architecture-design.md` | Designing architecture or planning module structure |
| `references/dev-lifecycle.md` | Writing code, creating tests, or establishing dev standards |
| `templates/` | Initializing `.agent/`, ADRs, and README for a new project |

---

# END
