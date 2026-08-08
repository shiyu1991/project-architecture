# Tech Stack Selection Guide

> Detailed reference for tech-stack selection during project initialization.
> Load this document when performing tech selection or analyzing an existing project's stack.

---

## 0. Dynamic Decision Protocol (highest priority)

This document provides **candidates and selection criteria**, not fixed answers. The AI Agent MUST follow these three protocols:

### 0.1 Dynamic Version Resolution

- This document **deliberately avoids hardcoded version numbers** to prevent stale recommendations.
- After an option is chosen, query the latest stable version in real time:

| Ecosystem | How to query |
|-----------|--------------|
| Node | `npm view <package> version` |
| Java | Maven Central / mvnrepository.com |
| Go | `go list -m -versions <module>` / proxy.golang.org |
| Python | PyPI / pypi.org |

- Runtimes (Node.js, JDK, Go, Python): always pick the **current LTS**.
- For freshly released major versions, observe for 3+ months before production use.

### 0.2 Context-Signal Selection

Decide between same-layer candidates using these signals, and explain the reasoning to the user:

- **Project type** — admin console / consumer app / API service / content site / AI application
- **Team background** — existing stack, language preference, maintenance capacity
- **Region & language** — Chinese-speaking teams prefer options with strong Chinese docs; global products prefer worldwide mainstream options
- **Scale & performance** — lightweight for small projects; performance-first for high concurrency
- **Existing dependencies** — extend the current ecosystem in legacy projects; never force a switch

### 0.3 Real-Time Compatibility Verification

- Compatibility matrices here mark only **structural bindings** (relationships that don't change over time, e.g., Pinia only supports Vue).
- Version-level compatibility (the framework version range a plugin supports) must be confirmed live via `peerDependencies` or official docs at selection time.

---

## 1. Selection Principles

Technology choices must weigh:

- **Business scale** — choose for actual needs, not imagined scale
- **Team capability** — pick a stack the team can maintain
- **Maintenance cost** — consider the long-term operational burden
- **Ecosystem maturity** — prefer mature, actively maintained technology
- **Performance needs** — base choices on real performance requirements
- **Extensibility** — ensure the architecture can grow with the business
- **Deployment cost** — consider infrastructure and ops complexity

**Forbidden:** choosing complex technology just to be "cutting-edge".

### Layered Mutually Exclusive Selection

- Proceed **layer by layer in order**; earlier choices constrain later options
- Within each layer, options are **mutually exclusive** — pick exactly one
- Offer **Top 3 common candidates** per layer (ordering reflects popularity only, not a mandate; the AI decides per protocol 0.2 using context)
- Users may **skip recommendations** and enter any custom option
- The AI Agent only raises **compatibility warnings** for custom choices — never overrides them

### Interactive Selection Principle (mandatory)

- The AI Agent **MUST use the `ask_followup_question` tool** to let users select via checkboxes — plain-text tables for verbal confirmation are forbidden
- Selection has three phases: Phase 1 selects core cross-stack items (main framework/language/database/deployment), Phase 2 shows all frontend layer candidates based on Phase 1 results, Phase 3 shows all backend layer candidates
- **Frontend and backend selection MUST be separated**: complete all frontend layers first, then select all backend layers; mixing frontend and backend layers in the same batch of questions is forbidden
- **All question headers MUST include a "Frontend-" or "Backend-" prefix** (except Phase 1 global decisions), to avoid user confusion
- Companion plugins are presented as **multi-select checkboxes** for the user to pick as needed
- Each option is labeled "recommended" with a one-sentence explanation to reduce decision cost

### User Choice Principle (highest priority, mandatory)

- **The AI Agent only recommends — it never chooses for the user.** Unless the user explicitly says "auto-select the rest for me," every layer MUST be confirmed by the user via checkbox
- **Auto-filling is forbidden** for any layer (even if it seems "obvious")
- **Auto-locking is forbidden** for any layer (even if the framework ecosystem has only one mainstream option)
- **Skipping layers is forbidden** — even if the chosen framework already covers that capability
- Recommendations are only labeled "recommended" — they do not replace user selection
- The user may say "auto-select the rest for me" at any time to authorize the AI to batch-select

### Capability Awareness Principle (mandatory)

- After the user picks a framework, the AI Agent **MUST check whether it already covers a later layer's capability**
- If covered: still ask the user, but present "use built-in" as the recommended option labeled "covered"
- If the user's needs exceed the built-in capability: recommend a standalone solution, labeled "choose when built-in is insufficient"
- See section 2.3 "Framework Capability Coverage Matrix" for details

---

## 2. Frontend Tech Selection — Layered Exclusive Flow

> **Mandatory rule:** Frontend selection MUST complete all layers in Phase 2 before entering Phase 3 backend selection. Mixing frontend and backend layers in the same batch is forbidden.

### Selection Flow

```
Layer 1: Frontend-Main Framework  →  Layer 2: Frontend-Language   →  Layer 3: Frontend-Build Tool
                                                                       ↓
Layer 4: Frontend-UI Library      →  Layer 5: Frontend-CSS Approach →  Layer 6: Frontend-HTTP Client
                                                                       ↓
Layer 7: Frontend-State Mgmt      →  Layer 8: Frontend-Router       →  Layer 9: Frontend-Form Validation
                                                                       ↓
Layer 10: Frontend-Test Framework →  Layer 11: Frontend-Code Quality →  Layer 12: Frontend-i18n (optional)
```

**Rule:** start at Layer 1, pick one per layer; earlier choices shape later recommendations.

---

### Layer 1: Main Framework (pick one)

| Option | Traits | Best for |
|--------|--------|----------|
| React | Largest ecosystem, strongest community, maintained by Meta | Large apps, complex interactions, international products |
| Vue | Fast onboarding, excellent Chinese docs, intuitive template syntax | Enterprise admin, management systems, China-based teams |
| Svelte | Compile-time optimization, no virtual DOM, smallest bundles | High-performance lightweight apps, personal projects |

**Signals:** admin console / China team / fast delivery → lean Vue; large complex interactions / international → lean React; extreme performance / small team → lean Svelte.

**Exclusivity:** exactly one main framework; locked once chosen.

**Custom input:** other frameworks allowed (Solid, Qwik, Angular); the AI only raises compatibility warnings.

---

### Layer 2: Language (pick one)

| Option | Traits | Best for |
|--------|--------|----------|
| TypeScript | Type safety, IDE intelligence, refactor-friendly | All serious projects (default) |
| JavaScript | No compile overhead, low learning curve | Small projects, quick prototypes, learning |

**Signals:** TypeScript unless the project is tiny or purely for learning.

---

### Layer 3: Build Tool (pick one)

| Option | Traits | Best for |
|--------|--------|----------|
| Vite | Instant HMR, zero-config, officially recommended by Vue/React | All new projects (default) |
| Webpack | Most mature ecosystem, richest plugins | Legacy projects, special build needs |
| Turbopack | Rust-based, built into Next.js, extremely fast | Next.js projects |

**Signals:** regular SPA/MPA → Vite; Next.js → Turbopack (built-in); don't force-migrate existing Webpack projects.

**Compatibility note:** Turbopack is deeply bound to Next.js; for non-Next.js scenarios verify ecosystem support first (per protocol 0.3).

---

### Layer 4: UI Component Library (recommend per main framework)

#### Vue Ecosystem

| Option | Traits | Best for |
|--------|--------|----------|
| Element Plus | Mature Vue 3 ecosystem, large Chinese community, complete components | Enterprise admin, management systems, China-based teams |
| Naive UI | TypeScript-native, powerful theming | Customization needs, TypeScript projects |
| Ant Design Vue | Vue implementation of Ant Design, polished design system | Teams preferring Ant Design style |

#### React Ecosystem

| Option | Traits | Best for |
|--------|--------|----------|
| Ant Design | Enterprise-grade UI library, complete components, good Chinese docs | Enterprise admin, management systems |
| shadcn/ui | Built on Radix UI, source copied into your project, fully customizable | Modern design, heavy customization |
| MUI | Material Design implementation, strong i18n | International products, Material style |

#### Svelte Ecosystem

| Option | Traits | Best for |
|--------|--------|----------|
| shadcn-svelte | Svelte port of shadcn/ui, customizable | Modern design, customization |
| Skeleton | TailwindCSS-driven, theme system | TailwindCSS projects |
| Flowbite Svelte | Ready to use, rich components | Rapid development |

**Signals:** China enterprise admin → Element Plus / Ant Design; international or heavy customization → shadcn/ui family; Material design system → MUI.

**Exclusivity:** exactly one UI component library.

---

### Layer 5: CSS Approach (pick one)

| Option | Traits | Best for |
|--------|--------|----------|
| TailwindCSS | Atomic CSS, high productivity, controllable bundle size | All projects (default) |
| CSS Modules | Local scope, native build-tool support, zero deps | Simple style isolation |
| CSS-in-JS (styled-components / Emotion etc.) | Dynamic styles, component-level encapsulation | React dynamic theming |

**Signals:** default TailwindCSS; before picking a specific CSS-in-JS library, verify its maintenance status per protocols 0.1/0.3 (some libraries have entered maintenance mode).

**Exclusivity:** one primary CSS approach (minor mixing allowed, but declare the primary).

---

### Layer 6: HTTP Client (pick one)

| Option | Traits | Best for |
|--------|--------|----------|
| Axios | Interceptors, request/response transforms, largest community | All projects (general default) |
| TanStack Query | Integrated fetching/caching/sync, auto-retry | Data-driven apps needing cache strategies |
| Wrapped native fetch | Zero deps, full control, lightweight | Minimal projects, special request needs |

**Exclusivity:** one primary HTTP approach.

**Pairing tip:** Axios + TanStack Query can combine (Axios as transport, Query managing data state); when combined, record TanStack Query as the primary.

---

### Layer 7: State Management (recommend per main framework)

#### Vue Ecosystem

| Option | Traits | Best for |
|--------|--------|----------|
| Pinia | Officially recommended by Vue, TS-friendly, DevTools integration | All Vue projects (default) |
| Vuex | Veteran option, legacy compatibility | Maintaining legacy Vue projects |
| Plain ref/reactive | No extra deps, minimal | Small projects, local state |

#### React Ecosystem

| Option | Traits | Best for |
|--------|--------|----------|
| Zustand | Minimal API, no boilerplate, TS-friendly, tiny | Small-to-mid projects (default) |
| Redux Toolkit | Enterprise-grade, powerful DevTools, rich middleware | Large projects, complex state flows |
| Jotai | Atomic state, fine-grained updates | Fine-grained state needs |

#### Svelte Ecosystem

| Option | Traits | Best for |
|--------|--------|----------|
| Svelte Stores (built-in) | Official, zero deps, reactive | All Svelte projects (default) |
| Custom store extensions | Flexible custom logic | Complex state needs |
| XState | State machines, complex flow control | Complex state transitions |

**Signals:** Vue → Pinia is near-uncontested; React small/mid → Zustand; large / multi-dev complex state → Redux Toolkit.

**Exclusivity:** exactly one state management solution.

---

### Layer 8: Router (recommend per main framework)

#### Vue Ecosystem

| Option | Traits | Best for |
|--------|--------|----------|
| Vue Router | Official Vue router, full-featured, great docs | All Vue projects (default) |
| unplugin-vue-router | File-based routing, type-safe routes | Convention-based routing preference |
| TanStack Router (Vue) | Type-safe, search-param state management | Strongly-typed routing needs |

#### React Ecosystem

| Option | Traits | Best for |
|--------|--------|----------|
| React Router | Most mature React router, SSR support | SPA apps (default) |
| Next.js App Router | File routing, SSR/SSG, full-stack capability | Next.js projects |
| TanStack Router (React) | Type-safe, search-param state management | Strongly-typed routing needs |

#### Svelte Ecosystem

| Option | Traits | Best for |
|--------|--------|----------|
| SvelteKit built-in router | Official full-stack framework, file routing | SvelteKit projects (default) |
| svelte-spa-router | Lightweight SPA router | Pure SPA projects |
| TanStack Router (Svelte) | Type-safe | Strongly-typed routing needs |

**Exclusivity:** exactly one routing solution.

---

### Layer 9: Form Validation (may be covered by UI library)

> **Capability coverage note:** The following UI libraries have built-in form validation. When selected, this layer is skipped by default:
> - **Element Plus** — built-in `el-form` validation rules: required, length, custom validators
> - **Ant Design** — built-in `Form` component validation with declarative rules
> - **Naive UI** — built-in `n-form` validation with custom validators
> - **Ant Design Vue** — built-in form validation, consistent with Ant Design
>
> **A standalone form validation library is needed only when:**
> - Cross-component / cross-form complex linked validation is required
> - Schema-level type inference is needed (TypeScript projects)
> - Validation schemas need to be shared between frontend and backend

| Option | Traits | Best for | Coverage status |
|--------|--------|----------|----------------|
| Use UI library built-in validation | Zero extra deps, deep integration with components | Most projects (default recommendation) | Element Plus / Ant Design / Naive UI already cover this |
| Zod | Schema validation, TypeScript inference, framework-agnostic | Needs shared FE/BE schema, type inference | Standalone — choose when built-in is insufficient |
| React Hook Form + Zod | Best React form performance + schema validation | React projects with complex forms | Standalone — choose when built-in is insufficient |
| VeeValidate + Zod | Vue ecosystem form validation + schema validation | Vue projects with complex forms | Standalone — choose when built-in is insufficient |

**Exclusivity:** exactly one form validation solution ("use built-in" counts as an option).

**Interactive checkbox example:**
```
options: [
  "Use Element Plus built-in validation (recommended, already covered)",
  "VeeValidate + Zod (choose when complex cross-form validation is needed)",
  "Zod (schema validation only, shared FE/BE)"
],
header: "Frontend-Form Validation"
```

**Pairing tip:** simple forms → use the UI library's built-in validation; complex forms → React Hook Form + Zod (React) or VeeValidate + Zod (Vue).

---

### Layer 10: Test Framework (pick one)

| Option | Traits | Best for |
|--------|--------|----------|
| Vitest | Vite-native, extremely fast, Jest-compatible API, zero config | Vite projects (default) |
| Jest | Most mature ecosystem, largest community, many legacy projects | Non-Vite projects, legacy projects |
| Playwright | E2E testing, cross-browser, auto-waiting | E2E testing needs |

**Exclusivity:** one unit-test framework; an E2E framework may coexist with it.

**Tip:** Vitest (unit) + Playwright (E2E) is the current mainstream combo.

---

### Layer 11: Code Quality Tools (enabled by default)

| Option | Traits | Best for |
|--------|--------|----------|
| ESLint + Prettier | Industry standard, largest ecosystem, rich rules, great IDE integration | All projects (default) |
| Biome | Rust-based, very fast, lint + format in one | Speed-focused, new projects |
| oxlint | Rust-based, ESLint-rule compatible | Large projects, performance-first |

**Exclusivity:** one primary lint/format setup (ESLint + Prettier counts as one option).

**Pairing tip:** TypeScript projects add `@typescript-eslint`; TailwindCSS projects add the official class-sorting plugin.

---

### Layer 12: Internationalization (optional, skippable)

| Option | Traits | Best for |
|--------|--------|----------|
| vue-i18n | Officially recommended for Vue, Composition API support | Vue projects |
| react-intl | ICU MessageFormat, React ecosystem standard | React projects |
| i18next | Framework-agnostic, largest ecosystem | General, cross-framework |

**Exclusivity:** exactly one i18n solution.

**Skip condition:** single-language projects may choose "not needed".

**Pairing tip:** for automatic translation-key extraction: i18next → `i18next-parser`; react-intl → `@formatjs/cli`.

---

### Mobile Technologies

Mobile selection is independent of the frontend web flow:

| Option | Best for |
|--------|----------|
| Flutter | Cross-platform, high-performance UI |
| React Native | JS/TS teams, cross-platform |
| UniApp | Mini-programs + mobile, China market |
| Android Native | Android-first, maximum platform integration |
| iOS Native | iOS-first, maximum platform integration |

---

## 2.1 Automatic Plugin Recommendations

After the user picks a main framework and state management, the AI Agent automatically recommends companion plugins:

### Vue Ecosystem

| Framework + State | Plugin | Purpose | Required? |
|-------------------|--------|---------|-----------|
| Vue + Pinia | `pinia-plugin-persistedstate` | State persistence (localStorage/sessionStorage) | Recommended |
| Vue + Pinia | `@pinia/nuxt` | Nuxt integration (Nuxt only) | Required for Nuxt |
| Vue + Vue Router | `unplugin-vue-router` | File-based, type-safe routing | Optional |
| Vue + Vite | `unplugin-auto-import` | Auto API imports | Recommended |
| Vue + Vite | `unplugin-vue-components` | Auto component imports | Recommended |

### React Ecosystem

| Framework + State | Plugin | Purpose | Required? |
|-------------------|--------|---------|-----------|
| React + Zustand | `zustand/middleware` (persist) | State persistence | Recommended |
| React + Redux Toolkit | `redux-persist` | State persistence | Recommended |
| React + Jotai | `jotai/utils` (atomWithStorage) | State persistence | Recommended |
| React + React Router | Route-level code splitting | Lazy route loading | Optional |
| React + Next.js | `next-auth` | Authentication | As needed |

### Svelte Ecosystem

| Framework + State | Plugin | Purpose | Required? |
|-------------------|--------|---------|-----------|
| Svelte + SvelteKit | `@sveltejs/adapter-auto` | Automatic deployment adapter | Required |
| Svelte + Svelte Stores | Custom persist store | State persistence | Recommended |

### Universal Recommendations (framework-agnostic)

| Plugin | Purpose | Required? |
|--------|---------|-----------|
| `@tanstack/query` | Data fetching & caching (if not chosen at Layer 6) | As needed |
| `dayjs` | Lightweight date handling | Recommended |
| `lodash-es` | Utilities (import on demand) | As needed |
| Iconify family | Icon solution (on-demand; pick the framework's integration package) | Recommended |
| `@typescript-eslint` | TypeScript ESLint rules (if Layer 11 chose ESLint) | Recommended |
| `i18next-parser` / `@formatjs/cli` | Translation-key extraction (if Layer 12 enabled) | As needed |

---

## 2.2 Compatibility Matrix (structural bindings)

Only **long-term stable ecosystem bindings** are marked here; verify version-level compatibility live per protocol 0.3.

### Main Framework × UI Library

| | Element Plus | Naive UI | Ant Design Vue | Ant Design | shadcn/ui | MUI | shadcn-svelte |
|---|---|---|---|---|---|---|---|
| **Vue** | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| **React** | ❌ | ❌ | ❌ | ✅ | ✅ | ✅ | ❌ |
| **Svelte** | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ✅ |

### Main Framework × State Management

| | Pinia | Vuex | Zustand | Redux Toolkit | Jotai | Svelte Stores |
|---|---|---|---|---|---|---|
| **Vue** | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| **React** | ❌ | ❌ | ✅ | ✅ | ✅ | ❌ |
| **Svelte** | ❌ | ❌ | ❌ | ❌ | ❌ | ✅ |

### Main Framework × Router

| | Vue Router | React Router | Next.js App Router | SvelteKit | TanStack Router |
|---|---|---|---|---|---|
| **Vue** | ✅ | ❌ | ❌ | ❌ | ✅ (Vue version) |
| **React** | ❌ | ✅ | ✅ | ❌ | ✅ (React version) |
| **Svelte** | ❌ | ❌ | ❌ | ✅ | ✅ (Svelte version) |

### Main Framework × i18n

| | vue-i18n | react-intl | i18next |
|---|---|---|---|
| **Vue** | ✅ | ❌ | ✅ (Vue integration package) |
| **React** | ❌ | ✅ | ✅ (react-i18next) |
| **Svelte** | ❌ | ❌ | ✅ (svelte-i18next) |

### Build Tool × Test Framework (rules of thumb, verify live)

General rules: Vite → smoothest with Vitest; Webpack → most mature with Jest; Turbopack scenarios follow the official Next.js testing guide.

Version compatibility evolves with the ecosystem; at selection time, consult the test framework's official integration docs per protocol 0.3 — do not rely on this document.

**Legend:** ✅ compatible | ❌ incompatible (structural) | ⚠️ extra config needed (verify live)

---

## 2.3 Framework Capability Coverage Matrix (eliminate redundant recommendations)

> **Core goal:** after the user picks a framework, the AI Agent automatically detects the framework's built-in capabilities, marks subsequent layers as "covered" and skips them by default — avoiding redundant third-party library recommendations.

### Frontend Framework Capability Coverage

| Chosen framework | Covered layers | Coverage description | Default strategy |
|------------------|---------------|---------------------|------------------|
| **Element Plus** (Vue) | L9 Form validation | `el-form` + `el-form-item` built-in validation rules | Skip L9, mark "covered" |
| **Ant Design** (React) | L9 Form validation | `Form` + `Form.Item` built-in validation rules | Skip L9, mark "covered" |
| **Ant Design Vue** (Vue) | L9 Form validation | Consistent with Ant Design form validation | Skip L9, mark "covered" |
| **Naive UI** (Vue) | L9 Form validation | `n-form` built-in validation | Skip L9, mark "covered" |
| **MUI** (React) | L9 Form validation | `FormControl` + `TextField` validation | Skip L9, mark "covered" |
| **Vue Router** | L8 Router | Official routing solution | Recommend, but require user confirmation |
| **React Router** | L8 Router | React ecosystem standard router | Recommend, but require user confirmation |
| **Next.js** | L3 Build + L8 Router | Built-in Turbopack build + App Router | Recommend built-in, but require user confirmation |
| **SvelteKit** | L3 Build + L8 Router | Built-in Vite build + file-based routing | Recommend built-in, but require user confirmation |
| **Nuxt** (Vue) | L3 Build + L8 Router | Built-in Vite build + file-based routing | Recommend built-in, but require user confirmation |

### Backend Framework Capability Coverage

| Chosen framework | Covered layers | Coverage description | Default strategy |
|------------------|---------------|---------------------|------------------|
| **NestJS** | L8 Auth | `@nestjs/passport` integrates Passport strategies | Recommend Passport plugin rather than standalone |
| **Spring Boot** | L8 Auth | Spring Security ecosystem | Recommend Spring Security rather than standalone |
| **Spring Boot** | L9 Logging | Logback built-in | Skip L9, mark "covered" |
| **Spring Boot** | L12 Scheduling | `@Scheduled` built-in | Skip L12 for simple scenarios |
| **NestJS** | L12 Scheduling | `@nestjs/schedule` built-in | Skip L12 for simple scenarios |
| **Django** (Python) | L4 ORM | Django ORM built-in | Skip L4, mark "covered" |
| **Django** (Python) | L8 Auth | Django Auth built-in | Skip L8, mark "covered" |
| **FastAPI** (Python) | L9 Logging | Uvicorn logging integration | Skip L9 for simple scenarios |

### Capability Coverage Decision Flow

```
User selects framework X
    ↓
AI Agent queries the capability coverage matrix
    ↓
Does framework X cover layer L?
    ├── Yes → In layer L, recommend "use built-in", labeled "covered"
    │        └── Still require user to confirm: use built-in or pick a standalone solution
    │            ├── User picks "use built-in" → Use framework's built-in capability
    │            └── User picks "standalone" → Recommend a standalone solution, labeled "choose when built-in is insufficient"
    └── No → Show candidate options for L as normal, let user choose
```

---

## 2.4 Layered Linkage Rules (choosing A recommends B, but user still confirms)

> **Core goal:** earlier choices filter later options and link-recommend companion frameworks and plugins, presented as interactive checkboxes. **Recommend does not mean auto-select — all layers still require user confirmation.**

### Frontend Linkage Rules

| Chosen (earlier) | Linked recommendation (later) | Linkage method |
|------------------|-------------------------------|---------------|
| Vue | L4 shows Vue-ecosystem library candidates | Filter candidates |
| Vue | L7 recommends Pinia | Label "recommended," user confirms |
| Vue | L8 recommends Vue Router | Label "recommended," user confirms |
| Vue | L10 recommends Vitest | Label "recommended," user confirms |
| React | L4 shows React-ecosystem library candidates | Filter candidates |
| React | L7 recommends Zustand (small/mid) / Redux Toolkit (large) | Label "recommended," user confirms |
| React | L8 recommends React Router | Label "recommended," user confirms |
| Svelte | L4 shows Svelte-ecosystem library candidates | Filter candidates |
| Svelte | L7 recommends Svelte Stores | Label "recommended," user confirms |
| Svelte | L8 recommends SvelteKit router | Label "recommended," user confirms |
| Vite (L3) | L10 recommends Vitest | Label "recommended," user confirms |
| Next.js (L1+L3) | L8 recommends App Router | Label "recommended," user confirms |
| TailwindCSS (L5) | L11 recommends TailwindCSS class-sorting plugin | Recommend plugin |

### Backend Linkage Rules

| Chosen (earlier) | Linked recommendation (later) | Linkage method |
|------------------|-------------------------------|---------------|
| Node.js | L4 shows Node-ecosystem ORM candidates | Filter candidates |
| Node.js | L9 recommends Pino | Label "recommended," user confirms |
| NestJS | L8 recommends `@nestjs/passport` | Recommend plugin |
| NestJS | L10 recommends Jest | Label "recommended," user confirms |
| Java | L4 shows Java-ecosystem ORM candidates | Filter candidates |
| Spring Boot | L9 recommends Logback | Label "recommended," user confirms |
| Spring Boot | L8 recommends Spring Security | Label "recommended," user confirms |
| Go | L4 shows Go-ecosystem ORM candidates | Filter candidates |
| Go | L9 recommends Zap | Label "recommended," user confirms |
| Gin | L8 recommends `golang-jwt/jwt` | Recommend plugin |
| Prisma | L5 compatible with MySQL / PostgreSQL / MongoDB | Filter candidates |
| MyBatis Plus | L5 compatible with MySQL / PostgreSQL | Filter candidates |

### Companion Plugin Linkage (multi-select checkbox display)

After the user picks a main framework, companion plugins are shown as **multi-select checkboxes** for the user to pick as needed:

**Vue ecosystem companion plugins:**

| Main framework | Companion plugin | Purpose | Default check |
|----------------|-----------------|---------|---------------|
| Vue + Pinia | `pinia-plugin-persistedstate` | State persistence | Recommended |
| Vue + Vite | `unplugin-auto-import` | Auto API imports | Recommended |
| Vue + Vite | `unplugin-vue-components` | Auto component imports | Recommended |
| Vue + Vue Router | `unplugin-vue-router` | File-based routing | Optional |

**React ecosystem companion plugins:**

| Main framework | Companion plugin | Purpose | Default check |
|----------------|-----------------|---------|---------------|
| React + Zustand | `zustand/middleware` (persist) | State persistence | Recommended |
| React + Redux Toolkit | `redux-persist` | State persistence | Recommended |
| React + Next.js | `next-auth` | Authentication | As needed |

**NestJS ecosystem companion plugins:**

| Framework | Companion plugin | Purpose | Default check |
|-----------|-----------------|---------|---------------|
| NestJS | `@nestjs/swagger` | Swagger docs | Recommended |
| NestJS | `@nestjs/throttler` | Rate limiting | Recommended |
| NestJS | `@nestjs/passport` | Auth strategies | Required with auth |
| NestJS | `@nestjs/schedule` | Scheduling | As needed |

**Interactive checkbox example:**
```
ask_followup_question({
  questions: [{
    question: "Frontend-Which companion plugins do you need?",
    header: "Frontend-Companion Plugins",
    multiSelect: true,
    options: [
      "pinia-plugin-persistedstate (state persistence)",
      "unplugin-auto-import (auto API imports)",
      "unplugin-vue-components (auto component imports)",
      "unplugin-vue-router (file-based routing)"
    ]
  }]
})
```

---

## 2.5 Custom Option Entry

### Custom Rules

- Users may enter options beyond the recommendations at any layer
- The AI Agent **never rejects** custom user choices
- The AI Agent only provides **compatibility warnings** and **risk notes**
- The user has the final say

### AI Agent Handling Flow

1. User enters a custom option
2. The AI checks compatibility with already-locked choices
3. If compatible: accept and move to the next layer
4. If incompatible: flag the risk, suggest alternatives, but respect the user's choice
5. If compatibility is unknown: mark "unknown compatibility — please verify"

### Custom Option Example

```
User: Frontend-UI Library I want Arco Design
AI: Arco Design is ByteDance's UI library, supporting React and Vue.
    - Compatible with Vue ✅
    - Compatible with React ✅
    - Not compatible with Svelte ❌
    Please confirm.
User: Confirmed
AI: Frontend-UI Library locked: Arco Design. Moving to Frontend-CSS Approach...
```

---

## 3. Backend Tech Selection — Layered Exclusive Flow

> **Mandatory rule:** Backend selection takes place in Phase 3 and MUST only start after all frontend selection is complete. Mixing with frontend layers in the same batch is forbidden.

### Selection Flow

```
Layer 1: Backend-Main Language   →  Layer 2: Backend-Framework  →  Layer 3: Backend-API Style
                                                                       ↓
Layer 4: Backend-ORM/Data Access →  Layer 5: Backend-Database    →  Layer 6: Backend-Cache
                                                                       ↓
Layer 7: Backend-Message Queue   →  Layer 8: Backend-Auth        →  Layer 9: Backend-Logging
                                                                       ↓
Layer 10: Backend-Test Framework →  Layer 11: Backend-File Storage →  Layer 12: Backend-Scheduling (optional)
```

**Rule:** start at Layer 1, pick one per layer; earlier choices shape later recommendations.

---

### Layer 1: Main Language (pick one)

| Option | Traits | Best for |
|--------|--------|----------|
| Java | Enterprise favorite, most mature ecosystem, powerful Spring ecosystem, deep talent pool | Enterprise systems, large projects |
| Node.js (TypeScript) | One language full-stack, high productivity, FE/BE unity | Rapid development, full-stack teams, small-to-mid projects |
| Go | Compiled performance, native concurrency, simple deployment | High-performance services, microservices, cloud-native |

**Signals:** large enterprise systems / traditional enterprises in China → Java; isomorphic FE/BE / rapid iteration → Node.js; high concurrency / cloud-native / infra tooling → Go.

**Exclusivity:** exactly one main language; locked once chosen. Always pick the current LTS (verify per protocol 0.1).

**Custom input:** other languages allowed (Python, Rust, C#); the AI only raises compatibility warnings. Python framework candidates appear at Layer 2.

---

### Layer 2: Backend Framework (recommend per main language)

#### Java Ecosystem

| Option | Traits | Best for |
|--------|--------|----------|
| Spring Boot | De facto Java backend standard, richest ecosystem | Enterprise systems (default) |
| Quarkus | Cloud-native, fast startup, low memory, GraalVM support | Cloud-native, Serverless |
| Vert.x | Reactive, event-driven, high concurrency | High-concurrency real-time systems |

#### Node.js Ecosystem

| Option | Traits | Best for |
|--------|--------|----------|
| NestJS | Modular, TypeScript-native, IoC container, excellent docs | Enterprise Node projects (default) |
| Express | Lightest, largest ecosystem, rich middleware | Small projects, quick prototypes |
| Fastify | Performance-first, schema validation, plugin system | High-performance API services |

#### Go Ecosystem

| Option | Traits | Best for |
|--------|--------|----------|
| Gin | Most popular, rich middleware, good docs, great performance | General Go backends (default) |
| Fiber | Express-style API, extremely fast router | High-performance API services |
| Echo | Clean, fast, rich middleware | Mid-size projects |

#### Python Ecosystem (when user customizes the main language)

| Option | Traits | Best for |
|--------|--------|----------|
| FastAPI | Async, auto docs, type-safe, performant | API services, AI backends |
| Django | Full-stack framework, admin panel, built-in ORM | Content management, full-stack projects |
| Flask | Lightweight, flexible, rich ecosystem | Small projects, microservices |

**Exclusivity:** exactly one backend framework.

---

### Layer 3: API Style (pick one)

| Option | Traits | Best for |
|--------|--------|----------|
| RESTful | Universal standard, broadest ecosystem, frontend-friendly, low learning curve | All projects (general default) |
| GraphQL | Flexible queries, fetch-on-demand, less over-fetching | Complex data queries, multi-client adaptation |
| gRPC | High performance, Protobuf serialization, strongly typed | Internal microservice communication, high-performance scenarios |

**Exclusivity:** one primary API style (RESTful + gRPC may coexist, but only one is primary).

**Tip:** RESTful for external APIs; gRPC for internal microservice communication.

---

### Layer 4: ORM / Data Access (recommend per main language)

#### Java Ecosystem

| Option | Traits | Best for |
|--------|--------|----------|
| MyBatis Plus | Popular in China, code generation, Lambda queries, flexible SQL | Enterprise projects (China-based teams) |
| Spring Data JPA | Official Spring, standard JPA, Repository pattern | International projects, standard ORM |
| jOOQ | Type-safe SQL, code generation, database-first | Complex SQL, type-safety needs |

#### Node.js Ecosystem

| Option | Traits | Best for |
|--------|--------|----------|
| Prisma | Type-safe, schema-first, migration tools, great DX | TypeScript projects (default) |
| TypeORM | Decorator style, Active Record / Data Mapper | Decorator-style preference |
| Drizzle ORM | Lightweight, SQL-like, performant | Minimal projects, SQL-style preference |

#### Go Ecosystem

| Option | Traits | Best for |
|--------|--------|----------|
| Gorm | Most popular Go ORM, full-featured, good docs | General Go projects (default) |
| sqlx | Lightweight, raw SQL, struct scanning | Raw SQL preference |
| ent | Schema-first, code generation | Complex relational data |

**Signals:** China-based Java teams → MyBatis Plus; international Java teams → JPA; Node projects → Prisma first.

**Exclusivity:** exactly one ORM/data-access solution.

---

### Layer 5: Database (pick one)

| Option | Traits | Best for |
|--------|--------|----------|
| MySQL | Most popular RDBMS, mature ecosystem, low ops cost | General business (default) |
| PostgreSQL | Advanced queries, JSON support, extensible, GIS | Advanced queries, analytics, GIS |
| MongoDB | Document-oriented, flexible schema, horizontal scaling | Document data, content management, rapid iteration |

**Exclusivity:** one primary database (auxiliary stores like Redis/ES may accompany it, but only one primary).

**The AI Agent MUST justify every database choice.**

---

### Layer 6: Cache (pick one)

| Option | Traits | Best for |
|--------|--------|----------|
| Redis | Most popular cache, rich data structures, persistence, clustering | All projects (default) |
| Memcached | Pure in-memory cache, minimal, high performance | Pure caching, minimal needs |
| In-process cache (e.g., Caffeine) | Zero network overhead, lowest latency | Single-node caching, read-heavy |

**Exclusivity:** one primary cache (Redis + in-process cache may combine, but only one primary).

---

### Layer 7: Message Queue (pick one)

| Option | Traits | Best for |
|--------|--------|----------|
| RabbitMQ | Mature, flexible routing, AMQP standard, good admin UI | Enterprise messaging (default) |
| Kafka | High throughput, log streaming, distributed | Log streams, big data, high throughput |
| Redis Streams | No extra components, lightweight, reuses Redis | Small projects, simple messaging |

**Exclusivity:** exactly one message queue.

**Tip:** Redis Streams suffices for small projects; RabbitMQ for mid-to-large; Kafka for logging/big data.

---

### Layer 8: Authentication (pick one)

> **Capability coverage note:** The following backend frameworks have built-in auth integration — prefer the framework's built-in solution:
> - **NestJS** — `@nestjs/passport` integrates Passport strategies; recommend using it rather than a standalone solution
> - **Spring Boot** — Spring Security ecosystem; recommend using it rather than a standalone solution
> - **Django** — Django Auth built-in auth system; skip this layer for simple scenarios

| Option | Traits | Best for | Coverage status |
|--------|--------|----------|----------------|
| JWT | Stateless, cross-domain friendly, mobile-friendly, broad ecosystem | Decoupled FE/BE, mobile (recommended) | NestJS uses `@nestjs/passport` + JWT strategy |
| OAuth2 / OIDC | Third-party auth standard, SSO, social login | SSO, third-party login, enterprise auth | Spring Security OAuth2 |
| Session + Cookie | Traditional, server-controlled, forced logout possible | Traditional web apps, SSR | Django Auth built-in |

**Exclusivity:** one primary auth scheme.

**Tip:** JWT for decoupled FE/BE; OAuth2/OIDC for SSO or social login; Session for traditional SSR. NestJS projects: recommend `@nestjs/passport` + JWT strategy.

---

### Layer 9: Logging (recommend per main language)

> **Capability coverage note:** The following frameworks have built-in logging — this layer may be skipped for simple scenarios:
> - **Spring Boot** — Logback built-in, covered by default
> - **NestJS** — built-in Logger, skippable for simple scenarios
> - **FastAPI** — Uvicorn logging integration, skippable for simple scenarios

#### Java Ecosystem

| Option | Traits | Best for | Coverage status |
|--------|--------|----------|----------------|
| Logback | Spring Boot default, performant, flexible config | Spring Boot projects (default) | Built into Spring Boot |
| Log4j2 | Async logging, best performance | High-performance logging needs | Choose when built-in is insufficient |
| SLF4J + chosen impl | Interface standard, swappable implementation | Need to switch logging impls | Choose when built-in is insufficient |

#### Node.js Ecosystem

| Option | Traits | Best for | Coverage status |
|--------|--------|----------|----------------|
| Pino | Fastest, JSON logs, transport streams | High-performance services (recommended) | Standalone solution |
| Winston | Most popular, multi-transport, flexible | General projects | Standalone solution |
| Framework built-in logger | Zero deps, framework integration | Small projects | Built into NestJS, skippable for simple scenarios |

#### Go Ecosystem

| Option | Traits | Best for |
|--------|--------|----------|
| Zap | By Uber, zero-allocation, fastest | High-performance Go services (recommended) |
| Logrus | Structured logs, friendly API | General Go projects |
| slog (stdlib) | Official, zero deps, structured | Newer Go projects |

**Exclusivity:** exactly one logging system.

---

### Layer 10: Test Framework (recommend per main language)

#### Java Ecosystem

| Option | Traits | Best for |
|--------|--------|----------|
| JUnit 5 | Java testing standard, Spring Boot integration | Java projects (default) |
| TestNG | Parameterized tests, dependent tests, parallel | Complex test scenarios |
| Spock | Groovy DSL, BDD style | BDD-style preference |

#### Node.js Ecosystem

| Option | Traits | Best for |
|--------|--------|----------|
| Jest | Most popular, zero config, snapshot testing, rich mocks | Node.js projects (default) |
| Vitest | Vite-native, extremely fast, Jest-compatible API | Vite full-stack projects |
| Mocha + Chai | Flexible combo, mature community | Custom test stacks |

#### Go Ecosystem

| Option | Traits | Best for |
|--------|--------|----------|
| Go testing (stdlib) | Official, zero deps, benchmarks | All Go projects (default) |
| testify | Assertions, mocks, suites | Stdlib enhancement |
| Ginkgo | BDD-style test framework | BDD-style preference |

**Exclusivity:** exactly one test framework.

---

### Layer 11: File Storage (optional, skippable)

| Option | Traits | Best for |
|--------|--------|----------|
| S3 / OSS / COS | Cloud storage, unlimited capacity, CDN acceleration, pay-as-you-go | Cloud-deployed projects (default) |
| MinIO | S3-compatible, self-hosted object storage, open-source & free | Private deployment, intranet projects, cost-sensitive |
| Local filesystem | Zero deps, simplest, no network overhead | Single-node deployment, small projects, intranet tools |

**Exclusivity:** one primary storage solution (local + cloud tiering allowed, but one primary).

**Skip condition:** pure API projects with no file-upload needs may choose "not needed".

**Pairing tip:** S3/OSS + local cache is a common combo; MinIO works well as a dev-environment S3 substitute.

---

### Layer 12: Scheduling (optional, skippable)

> **Capability coverage note:** The following frameworks have built-in scheduling — this layer may be skipped for simple scenarios:
> - **Spring Boot** — `@Scheduled` built-in, covers simple scheduled tasks
> - **NestJS** — `@nestjs/schedule` built-in, covers simple scheduled tasks

#### Java Ecosystem

| Option | Traits | Best for | Coverage status |
|--------|--------|----------|----------------|
| Spring @Scheduled | Built into Spring Boot, zero deps, annotation-based | Single-node scheduled jobs (simple scenarios) | Built into Spring Boot |
| XXL-Job | Distributed scheduling, visual UI, dynamic config | Distributed scheduled jobs (China-based teams) | Choose when built-in is insufficient |
| Quartz | Full-featured, cluster support, persistence | Complex scheduling needs | Choose when built-in is insufficient |

#### Node.js Ecosystem

| Option | Traits | Best for |
|--------|--------|----------|
| @nestjs/schedule | Built into NestJS, decorator-based, cron expressions | NestJS projects (recommended) |
| Bull family | Redis queues, scheduled jobs, retry mechanisms | Queue + scheduling scenarios |
| node-cron | Lightweight, cron expressions, no deps | Simple scheduled jobs |

#### Go Ecosystem

| Option | Traits | Best for |
|--------|--------|----------|
| robfig/cron | Most popular Go cron library, clean API | General Go projects (recommended) |
| gocron | Chained API, easy to use | Chained-API preference |
| Stdlib time.Ticker | Zero deps, simplest | Fixed-interval tasks |

**Exclusivity:** exactly one scheduling solution.

**Skip condition:** projects without scheduled jobs may choose "not needed".

---

## 3.1 Automatic Backend Plugin Recommendations

After the user picks a backend framework and ORM, the AI Agent automatically recommends companion plugins:

### Java Ecosystem

| Framework + ORM | Plugin | Purpose | Required? |
|-----------------|--------|---------|-----------|
| Spring Boot + MyBatis Plus | `mybatis-plus-join` | Multi-table joins | Recommended |
| Spring Boot + MyBatis Plus | `dynamic-datasource` | Multi-datasource support | As needed |
| Spring Boot + JPA | `spring-data-envers` | Audit logs, data versioning | As needed |
| Spring Boot | `spring-boot-starter-actuator` | Health checks, monitoring | Recommended |
| Spring Boot | `springdoc-openapi` | Auto OpenAPI docs | Recommended |
| Spring Boot + Spring Cloud | Nacos etc. registry/config components | Service registration & config | Required for microservices |
| Spring Boot + file storage | S3-compatible SDK / MinIO SDK | Object storage integration | Required with file storage |
| Spring Boot + scheduling | `xxl-job-core` | Distributed scheduling center | Recommended for distributed jobs |

### Node.js Ecosystem

| Framework + ORM | Plugin | Purpose | Required? |
|-----------------|--------|---------|-----------|
| NestJS + Prisma | Prisma NestJS integration module | Prisma integration | Recommended |
| NestJS | `@nestjs/swagger` | Auto Swagger docs | Recommended |
| NestJS | `@nestjs/throttler` | Rate limiting | Recommended |
| NestJS | `@nestjs/passport` | Auth strategy integration | Required with auth |
| NestJS + file storage | S3 SDK / MinIO SDK | Object storage integration | Required with file storage |
| NestJS + scheduling | `@nestjs/schedule` | Scheduling decorators | Required with scheduling |
| Fastify | `@fastify/swagger` | Swagger docs | Recommended |
| Fastify | `@fastify/rate-limit` | Rate limiting | Recommended |

### Go Ecosystem

| Framework + ORM | Plugin | Purpose | Required? |
|-----------------|--------|---------|-----------|
| Gin + Gorm | `gorm/datatypes` | Extended data types | As needed |
| Gin + Gorm | `gorm/hints` | Optimizer hints | As needed |
| Gin | `swaggo/swag` | Auto Swagger docs | Recommended |
| Gin | `gin-contrib/cors` | CORS middleware | Recommended |
| Gin | `golang-jwt/jwt` | JWT auth | Required with auth |
| Gin + file storage | Go SDK for S3 / MinIO | Object storage integration | Required with file storage |
| Gin + scheduling | `robfig/cron` | Job scheduling | Required with scheduling |

### Universal Recommendations (language-agnostic)

| Plugin/Tool | Purpose | Required? |
|-------------|---------|-----------|
| Swagger / OpenAPI | API documentation | Recommended |
| Docker | Containerized deployment | Recommended |
| Prometheus + Grafana | Monitoring & alerting | Recommended for production |
| ELK / Loki | Log collection & analysis | Recommended for production |

---

## 3.2 Backend Compatibility Matrix (structural bindings)

Only **long-term stable ecosystem bindings** are marked here; verify version-level compatibility live per protocol 0.3.

### Main Language × Backend Framework

| | Spring Boot | Quarkus | NestJS | Express | Gin | Fiber | FastAPI | Django |
|---|---|---|---|---|---|---|---|---|
| **Java** | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ |
| **Node.js** | ❌ | ❌ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| **Go** | ❌ | ❌ | ❌ | ❌ | ✅ | ✅ | ❌ | ❌ |
| **Python** | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ✅ | ✅ |

### Backend Framework × ORM

| | MyBatis Plus | JPA | Prisma | TypeORM | Gorm | sqlx | SQLAlchemy |
|---|---|---|---|---|---|---|---|
| **Spring Boot** | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ |
| **NestJS** | ❌ | ❌ | ✅ | ✅ | ❌ | ❌ | ❌ |
| **Express** | ❌ | ❌ | ✅ | ✅ | ❌ | ❌ | ❌ |
| **Gin** | ❌ | ❌ | ❌ | ❌ | ✅ | ✅ | ❌ |
| **FastAPI** | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ✅ |

### ORM × Database

| | MySQL | PostgreSQL | MongoDB |
|---|---|---|---|
| **MyBatis Plus** | ✅ | ✅ | ❌ |
| **JPA/Hibernate** | ✅ | ✅ | ❌ |
| **Prisma** | ✅ | ✅ | ✅ |
| **TypeORM** | ✅ | ✅ | ✅ |
| **Gorm** | ✅ | ✅ | ✅ |
| **sqlx** | ✅ | ✅ | ❌ |
| **SQLAlchemy** | ✅ | ✅ | ✅ |

### Main Language × Test Framework

| | JUnit 5 | TestNG | Jest | Vitest | Go testing | Pytest |
|---|---|---|---|---|---|---|
| **Java** | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| **Node.js** | ❌ | ❌ | ✅ | ✅ | ❌ | ❌ |
| **Go** | ❌ | ❌ | ❌ | ❌ | ✅ | ❌ |
| **Python** | ❌ | ❌ | ❌ | ❌ | ❌ | ✅ |

### Main Language × Scheduling

| | @Scheduled / @nestjs/schedule | XXL-Job | Quartz | Bull family | robfig/cron |
|---|---|---|---|---|---|
| **Java** | ✅ | ✅ | ✅ | ❌ | ❌ |
| **Node.js** | ✅ (NestJS) | ❌ | ❌ | ✅ | ❌ |
| **Go** | ❌ | ❌ | ❌ | ❌ | ✅ |

**Legend:** ✅ compatible | ❌ incompatible (structural) | ⚠️ extra config needed (verify live)

---

## 3.3 Backend Custom Option Entry

### Custom Rules

Same as frontend:

- Users may enter options beyond the recommendations at any layer
- The AI Agent **never rejects** custom user choices
- The AI Agent only provides **compatibility warnings** and **risk notes**
- The user has the final say

### AI Agent Handling Flow

1. User enters a custom option
2. The AI checks compatibility with already-locked choices
3. If compatible: accept and move to the next layer
4. If incompatible: flag the risk, suggest alternatives, but respect the user's choice
5. If compatibility is unknown: mark "unknown compatibility — please verify"

### Custom Option Example

```
User: Backend-Framework I want Hono
AI: Hono is an ultralight web framework supporting Node.js/Bun/Deno/Edge.
    - Compatible with Node.js ✅
    - Compatible with TypeScript ✅
    - Great for Edge/Serverless scenarios
    Please confirm.
User: Confirmed
AI: Backend-Framework locked: Hono. Moving to Backend-API Style...
```

---

## 3.4 Cross-Cutting Concerns (project-wide selection)

These choices are not frontend/backend-specific — they are project-wide architectural concerns. After completing frontend and backend selection, the AI Agent should guide the user through:

### CI/CD (pick one)

| Option | Traits | Best for |
|--------|--------|----------|
| GitHub Actions | Built into GitHub, free tier, large ecosystem, simple config | GitHub-hosted projects |
| GitLab CI/CD | Built into GitLab, full-featured, self-managed runners | GitLab-hosted projects, private deployment |
| Jenkins | Veteran option, most plugins, fully self-controlled | Traditional enterprises, heavy customization |

**Signals:** follow the code-hosting platform; for self-hosted Gitea etc., evaluate its built-in CI or Jenkins.

**Exclusivity:** one primary CI/CD solution.

---

### Error Monitoring / APM (pick one)

| Option | Traits | Best for |
|--------|--------|----------|
| Sentry | FE+BE, open-source, large ecosystem, self-hostable | All projects (general recommendation) |
| Datadog | Full-stack monitoring: APM + logs + metrics, commercial | Enterprise full-stack monitoring |
| SkyWalking | Apache open-source, strong in Java ecosystem, free | Java microservices, private deployment |

**Signals:** limited budget / private deployment → self-hosted Sentry or SkyWalking; enterprise all-in-one monitoring → Datadog.

**Exclusivity:** one primary error-monitoring/APM solution.

**Pairing tip:** error monitoring + Prometheus + Grafana (metrics) is a common open-source combo.

---

## 4. Database Selection

| Category | Options |
|----------|---------|
| Relational | MySQL, PostgreSQL, Oracle |
| Cache | Redis |
| Search | ElasticSearch |
| Document | MongoDB |

**Rule:** the AI Agent must justify every database choice.

---

## 5. Deployment Options

| Option | Best for |
|--------|----------|
| Docker | Containerized single service |
| Docker Compose | Multi-container local/dev environments |
| Kubernetes | Large-scale production, orchestration |
| Serverless | Event-driven, auto-scaling, pay-as-you-go |
| Managed cloud platforms | Managed services, reduced ops burden |

---

## 6. Reverse Analysis of Existing Projects

When the user provides a GitHub URL, Git repo, or project archive, the AI Agent MUST:

### Analyze

- Project structure
- Tech stack
- Dependency versions
- Directory conventions
- Architecture patterns
- Shared components
- Code quality

### Output

- Current project technical profile
- Recommended optimizations
- Reusable modules
- Modules needing refactor
- Future architecture suggestions
