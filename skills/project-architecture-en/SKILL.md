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
| ⚡ Expert | Developer / tech lead | Confirm only the key decision points layer by layer; recommended items are labeled "recommended" for quick confirmation, but each layer still requires user checkbox selection. Quickly outputs the complete tech-stack list. |

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

# 3-A. Project Type Classification (selection branch)

After scale classification, determine the project type to decide the selection flow:

| Type | Detection signals | Selection flow |
|------|-------------------|----------------|
| Full-stack Web | Both frontend and backend needed | Full flow: Phase 1 (core) → Phase 2 (all frontend layers) → Phase 3 (all backend layers) → Phase 4 (cross-cutting) |
| Frontend-only | No backend / BFF only / static site / SPA | Phase 1 (frontend items + deployment) → Phase 2 (all frontend layers) → Phase 4 (cross-cutting) |
| Backend-only API | No frontend / API service only | Phase 1 (backend items + database + deployment) → Phase 3 (all backend layers) → Phase 4 (cross-cutting) |
| Mini-program / Mobile | WeChat mini-program / UniApp / Flutter / React Native | Mobile selection flow (see `references/tech-stack-guide.md` Mobile section) |
| AI / ML Application | AI inference / training / data analysis | Phase 1 (Python preferred) → Phase 3 (all backend layers, AI frameworks in tech-stack-guide) → Phase 4 |

**Timing:** After user-mode detection and scale classification, before tech selection. After classification, clearly inform the user of the project type and selection flow branch.

**Frontend-only / Backend-only skip rule:** Skipped sides do not require layer-by-layer checkbox selection. The AI Agent simply marks "not needed for this project" in the selection summary.

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

In Product mode, this phase outputs a **domain-model sketch + core user flows** (generated using `templates/domain-model-template.md`), which must be confirmed by the user before tech selection begins.

---

# 7. Tech Selection Overview

Tech selection uses **layer-by-layer interactive checkbox + dynamic research + capability awareness + linkage recommendations**: the AI Agent MUST use the `ask_followup_question` tool to let users select via checkboxes, not plain text recommendations; before presenting candidates at each layer, the AI MUST use `web_search` to dynamically research the current tech landscape (see `references/tech-stack-guide.md` protocol 0.4) — the document tables serve only as a reference baseline; during selection, detect the chosen framework's built-in capabilities and label "covered" hints in subsequent layers; link-recommend compatible companion frameworks and plugins.

## 7.1 Supreme Principle: The User Always Has the Final Say (mandatory)

**The AI Agent is an intelligent brain — it only recommends, never chooses for the user.** Unless the user explicitly says "auto-select the rest for me," every layer MUST be confirmed by the user via checkbox.

**Forbidden:**
- Auto-filling any layer's selection (even if it seems "obvious")
- Auto-locking any layer (even if the framework ecosystem has only one mainstream option)
- Skipping any layer without asking the user (even if the chosen framework already covers that capability)
- Pre-selecting/default-checking any option (recommendations are only labeled "recommended," not auto-selected)

**Correct behavior:**
- Every layer is presented via `ask_followup_question` for the user to choose
- Recommended items are labeled "recommended" with a one-sentence reason, but the choice belongs to the user
- Layers covered by the chosen framework still require the user to confirm whether to use built-in or pick a standalone solution
- The user may say "auto-select the rest for me" at any time to authorize the AI to batch-select

## 7.2 Interactive Selection Flow (mandatory)

**The AI Agent MUST use the `ask_followup_question` tool for tech selection.** Plain-text tables for verbal confirmation are forbidden.

### Header Prefix Mandatory Rule (mandatory)

**All selection question `header` (titles) MUST start with a "Frontend-" or "Backend-" prefix.** Headers without a prefix (e.g., "State Management", "Cache") are forbidden to avoid user confusion between frontend and backend layers.

Correct examples: `"Frontend-State Management"`, `"Backend-Cache"`, `"Frontend-UI Library"`, `"Backend-ORM/Data Access"`
Incorrect examples: `"State Management"`, `"Cache"`, `"UI Library"`, `"ORM/Data Access"`

### Frontend/Backend Separation Rule (mandatory)

**Frontend and backend layer-by-layer selection MUST be done in separate phases. Mixing frontend and backend layers in the same batch of questions is forbidden.**

- All frontend layers must be fully selected before starting backend selection
- Each batch of questions may only belong to one side (all frontend or all backend) — mixed batches are forbidden
- After frontend selection is complete, explicitly inform the user: "Frontend tech stack confirmed. Now entering backend tech selection," then begin backend selection

### Three-Phase Selection

### Phase 1: Core Tech Stack Selection (cross-stack batch checkbox)

Present key selections (frontend framework, backend language, database, deployment, etc.) in one batch for the user to check off. Cross-stack mixing is allowed in this phase because these are global decisions:

```
ask_followup_question({
  questions: [
    { question: "Frontend framework?", header: "Frontend-Main Framework", options: ["Vue", "React", "Svelte"], multiSelect: false },
    { question: "Backend language?", header: "Backend-Main Language", options: ["Node.js (TypeScript)", "Java", "Go", "Python"], multiSelect: false },
    { question: "Database?", header: "Database", options: ["MySQL", "PostgreSQL", "MongoDB"], multiSelect: false },
    { question: "Deployment?", header: "Deployment", options: ["Docker Compose", "Docker", "Managed Cloud"], multiSelect: false },
    ...
  ]
})
```

### Phase 2: Frontend Layer-by-Layer Extended Selection (frontend only, linked checkbox)

Based on the Phase 1 frontend framework choice, present compatible frontend candidates **layer by layer**, with each layer requiring user selection. **All questions in this phase contain only frontend layers — backend layers are forbidden.**

```
ask_followup_question({
  questions: [
    { question: "Frontend language?", header: "Frontend-Language", options: [
      "TypeScript (recommended: type safety, IDE intelligence)",
      "JavaScript (no compile overhead, low learning curve)"
    ], multiSelect: false },
    { question: "Frontend build tool?", header: "Frontend-Build Tool", options: [
      "Vite (recommended: instant HMR, officially recommended by Vue)",
      "Webpack (mature ecosystem, legacy projects)"
    ], multiSelect: false },
    { question: "Frontend UI library?", header: "Frontend-UI Library", options: [
      "Element Plus (recommended: mature Vue 3 ecosystem, large Chinese community)",
      "Naive UI",
      "Ant Design Vue"
    ], multiSelect: false },
    ...
  ]
})
```

After all frontend layers are selected, explicitly inform the user:

> Frontend tech stack confirmed. Now entering backend tech selection.

### Phase 3: Backend Layer-by-Layer Extended Selection (backend only, linked checkbox)

Based on the Phase 1 backend language choice, present compatible backend candidates **layer by layer**, with each layer requiring user selection. **All questions in this phase contain only backend layers — frontend layers are forbidden.**

```
ask_followup_question({
  questions: [
    { question: "Backend framework?", header: "Backend-Framework", options: [
      "NestJS (recommended: modular, TS-native, IoC container)",
      "Express (lightest, largest ecosystem)",
      "Fastify (performance-first, schema validation)"
    ], multiSelect: false },
    { question: "Backend API style?", header: "Backend-API Style", options: [
      "RESTful (recommended: universal standard, frontend-friendly)",
      "GraphQL (flexible queries, fetch-on-demand)",
      "gRPC (high performance, strongly typed)"
    ], multiSelect: false },
    { question: "Backend ORM/data access?", header: "Backend-ORM/Data Access", options: [
      "Prisma (recommended: type-safe, schema-first)",
      "TypeORM (decorator style)",
      "Drizzle ORM (lightweight, SQL-style)"
    ], multiSelect: false },
    ...
  ]
})
```

**Key rules:**
- 3-4 checkbox questions per batch, avoid showing too many at once
- Each option labeled "recommended" with a one-sentence reason
- **All question headers MUST include a "Frontend-" or "Backend-" prefix** (except Phase 1 global decisions)
- **Mixing frontend and backend layers in the same batch is forbidden** (except Phase 1 global decisions)
- Layers covered by the chosen framework show "use built-in" as the recommended option, but still require user confirmation
- Companion plugins are presented as multi-select checkboxes for the user to pick as needed

## 7.3 Capability Awareness & Redundancy Hints (mandatory)

**The AI Agent MUST detect capabilities already provided by the chosen framework and label "covered" hints in subsequent layers.**

Core rules:

1. **Capability detection** — after the user picks a framework, check whether it already covers a later layer's capability
2. **Coverage hint** — if covered, still ask the user, but present "use built-in" as the recommended option labeled "covered"
3. **Upgrade prompt** — recommend a standalone solution when the user's needs exceed the built-in capability, labeled "choose when built-in is insufficient"
4. **Multi-select plugins** — companion plugins are presented as multi-select checkboxes for the user to pick as needed

Common capability coverage relationships (full matrix in `references/tech-stack-guide.md` section 2.3):

| Chosen framework | Covered layers | Recommendation strategy |
|------------------|---------------|--------------------------|
| Element Plus (Vue) | L9 Form validation | Recommend "use built-in validation," but still require user confirmation |
| Ant Design (React) | L9 Form validation | Recommend "use built-in validation," but still require user confirmation |
| NestJS | L8 Auth | Recommend `@nestjs/passport`, but still require user confirmation |
| Vue Router | L8 Router | Recommend Vue Router, but still require user confirmation |
| SvelteKit | L8 Router + L3 Build | Recommend SvelteKit built-in, but still require user confirmation |
| Next.js | L3 Build + L8 Router | Recommend Next.js built-in, but still require user confirmation |

## 7.4 Layered Linkage Rules

**Earlier choices filter later options and trigger recommendations — but do not auto-select.**

- Vue → L4 shows Vue-ecosystem library candidates; L7 recommends Pinia; L8 recommends Vue Router — all require user confirmation
- React → L4 shows React-ecosystem library candidates; L7 recommends Zustand/Redux Toolkit; L8 recommends React Router — all require user confirmation
- Svelte → L4 shows Svelte-ecosystem library candidates; L7 recommends Svelte Stores; L8 recommends SvelteKit router — all require user confirmation
- Node.js → L4 shows Node-ecosystem ORM candidates; L9 recommends Pino — all require user confirmation
- Java → L4 shows Java-ecosystem ORM candidates; L9 recommends Logback — all require user confirmation
- Go → L4 shows Go-ecosystem ORM candidates; L9 recommends Zap — all require user confirmation

**Key:** "Recommend" does not mean "auto-select." Every layer must be confirmed by the user via checkbox.

## 7.5 Selection Layers & Order (mandatory)

**Selection order mandatory rule: Phase 1 (core selection) → Phase 2 (all frontend layers) → Phase 3 (all backend layers) → cross-cutting concerns. Reordering is forbidden.**

### Phase 1: Core Selection (cross-stack, mixing allowed)

Global decision items, mixing allowed in the same batch:
- Frontend main framework, backend main language, database, deployment

### Phase 2: All Frontend Layers (in order, backend layers forbidden)

**Frontend-Main Framework** → **Frontend-Language** → **Frontend-Build Tool** → **Frontend-UI Library** → **Frontend-CSS Approach** → **Frontend-HTTP Client** → **Frontend-State Management** → **Frontend-Router** → **Frontend-Form Validation** (may be covered by UI library, but still requires confirmation) → **Frontend-Test Framework** → **Frontend-Code Quality Tools** → **Frontend-i18n** (optional)

### Phase 3: All Backend Layers (in order, frontend layers forbidden)

**Backend-Main Language** (selected in Phase 1) → **Backend-Framework** → **Backend-API Style** → **Backend-ORM/Data Access** → **Backend-Database** (selected in Phase 1) → **Backend-Cache** → **Backend-Message Queue** → **Backend-Auth** → **Backend-Logging** → **Backend-Test Framework** → **Backend-File Storage** (optional) → **Backend-Scheduling** (optional)

### Phase 4: Cross-Cutting Concerns

**After all frontend and backend selection is complete**, guide the user through CI/CD and error monitoring/APM choices.

## 7.5-A Selection Progress Tracking (mandatory)

During selection, the AI Agent MUST output a progress summary after each batch, so the user can see selected/pending/skipped status at any time:

```
## Selection Progress [3/12 frontend layers completed]
✅ Frontend-Main Framework: Vue
✅ Frontend-Language: TypeScript
✅ Frontend-Build Tool: Vite
⬜ Frontend-UI Library: pending
⬜ Frontend-CSS Approach: pending
⬜ Frontend-HTTP Client: pending
... (remaining layers)
```

**Rules:**
- Output progress summary immediately after each batch
- Selected layers: ✅ with the result
- Pending layers: ⬜
- Skipped layers (e.g., frontend skipped in a backend-only project): ⏭️ with "not needed"
- After all layers are selected, proceed to selection summary

## 7.5-B Selection Result Summary (mandatory)

After all selection layers are complete, the AI Agent **MUST** output a tech-stack summary table and auto-fill it into `.agent/architecture.md`:

```
## Tech Stack Selection Summary

| Layer | Choice | Version | Reason |
|-------|--------|---------|--------|
| Frontend-Main Framework | Vue | 3.x (live query) | ... |
| Frontend-Language | TypeScript | - | ... |
| Frontend-Build Tool | Vite | x.x (live query) | ... |
| Backend-Framework | NestJS | x.x (live query) | ... |
| Backend-Database | PostgreSQL | x.x (live query) | ... |
| ... | ... | ... | ... |

Versions must be queried live (per references/tech-stack-guide.md protocol 0.1). Stale versions are forbidden.
```

**Follow-up actions:**
1. User confirms the summary table
2. Auto-fill `.agent/architecture.md` tech stack
3. Generate ADR-001 recording the tech-stack decision
4. Enter project initialization (generate directory structure, `.agent/` four-file set, README)

## 7.5-C Selection Change Flow

Users may change a previously selected option during or after selection:

1. **User requests a change** (e.g., "switch frontend framework from Vue to React")
2. **AI Agent assesses impact scope:**
   - Affected downstream layers (UI library, state management, router, etc.)
   - Compatibility check with the new framework
   - List of already-selected layers that are no longer compatible
3. **AI Agent presents impact and requests confirmation:**
   - Lists layers that need re-selection
   - Lists selections that will be invalidated
4. **After user confirmation:**
   - Update the selected option
   - Re-run selection for affected layers
   - Update progress tracking and result summary

## 7.6 Interaction Rules per Mode

- **Guided**: 3-4 checkbox questions per batch, each item labeled "recommended" with a one-sentence explanation; user checks to confirm
- **Product**: show recommended lists in batches, each item labeled "recommended"; user confirms or tweaks batch by batch
- **Expert**: batch checkboxes, more candidates per batch (Top 3-5), recommended items labeled "recommended"; user selects layer by layer
- **All modes**: dynamic version resolution (`npm view <pkg> version` / Maven Central / Go Module Proxy / PyPI); never reuse stale version numbers
- **All modes**: before presenting candidates at each layer, MUST execute `web_search` to dynamically research and merge latest options; document tables are only a reference baseline (per tech-stack-guide.md protocol 0.4)
- **All modes**: auto-filling, auto-locking, and skipping layers are forbidden. All layers must be confirmed by the user
- **All modes**: all question headers MUST include a "Frontend-" or "Backend-" prefix (except Phase 1 global decisions)
- **All modes**: mixing frontend and backend layers in the same batch is forbidden (except Phase 1 global decisions); complete all frontend selection before starting backend

For detailed candidates, capability coverage matrix, compatibility matrices, linkage rules, and plugin recommendations, see `references/tech-stack-guide.md`.

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
- **Business modules**: backend uses DDD four layers — `domain / application / infrastructure / interfaces`; frontend uses feature-oriented structure — `api / components / composables / stores / views` (see architecture-design.md section 6)
- **Module communication**: backend same-process direct calls to Application Service, cross-module event-driven; frontend Props/Events + Core Store sharing (see architecture-design.md section 7)
- **Reuse rule**: before adding a feature, check in order: Core → existing modules → Plugins. Never reinvent the wheel.
- **ADR**: record every significant technical decision in `docs/adr/`; format in `references/architecture-design.md` section 5
- **Monorepo**: when FE+BE share a repo, use `packages/shared + client + server` structure with pnpm workspaces + Turborepo (see architecture-design.md section 11)

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
| `templates/domain-model-template.md` | Product mode requirement analysis phase, outputting domain-model sketch |

---

# END
