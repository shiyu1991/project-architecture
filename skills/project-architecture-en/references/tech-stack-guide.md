# Tech Stack Selection Guide

> Detailed reference for tech-stack selection during project initialization.
> Load this document when performing tech selection or analyzing an existing project's stack.

---

## 0. Dynamic Decision Protocol (highest priority)

This document provides **candidates and selection criteria**, not fixed answers. The AI Agent MUST follow these four protocols:

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

### 0.4 Dynamic Candidate Research (mandatory)

The candidate tables in this document are a **reference baseline at the time of writing**, not a closed list. The tech ecosystem evolves continuously. The AI Agent MUST perform dynamic research at selection time:

**Mandatory research flow:**

1. **Live search** — Before presenting candidates, the AI Agent MUST use the `web_search` tool to search for current mainstream options for that layer. Example query keywords:
   - `"best [layer name] framework 2025"` (e.g., `best Vue state management 2025`)
   - `"[tech name] alternatives 2025"` (e.g., `Prisma alternatives 2025`)
   - `"[layer] ecosystem trends"` (e.g., `frontend build tools trends`)

2. **Merge candidates** — Combine search results with the document's reference baseline:
   - Keep baseline options (unless search shows they are deprecated/unmaintained)
   - Add newly discovered emerging options (label "emerging")
   - Remove or label "outdated" for options the search shows are no longer active

3. **Activity verification** — Verify each candidate's activity level:
   - GitHub stars and recent commit frequency
   - Latest release date (label "maintenance stalled" if no update for 1+ year)
   - Community engagement (npm downloads / Stack Overflow activity)

4. **Candidate presentation** — The final candidate list shown to the user is the dynamically merged result, with each item labeled:
   - "recommended" + one-sentence reason (based on current context and search results)
   - "emerging" (a rising new solution found via search)
   - "outdated" (no longer active legacy option, kept for reference only)

**Research frequency (mandatory):**
- After every user-confirmed option, the AI Agent MUST execute a fresh `web_search` before asking the next question
- Search context MUST include all selected technologies, project type, scale, constraints, and the option just confirmed
- Do not reuse old results merely because the candidate belongs to the same layer; ecosystem, versions, and plugin compatibility must be reassessed for the current context
- Research results are NOT written to the skill document — used only for the current selection session

**Example:**
```
# Layer 7: State Management (Vue Ecosystem)

# AI Agent executes web_search: "best Vue state management 2025"
# Results: Pinia remains the mainstream recommendation, Vue officially maintained; new X state lib appeared

# Merged candidates shown to user:
options: [
  "Pinia (recommended: Vue official, TypeScript-friendly, most mature ecosystem)",
  "X lib (emerging: 2025 new solution, focuses on XX features)",
  "Vuex (outdated: official migration to Pinia recommended, legacy projects only)"
]
```

**Key principle:** The tables in this document are the "starting point," not the "destination." The AI Agent is responsible for ensuring that what is recommended to the user reflects the current tech landscape, not a snapshot from when this document was written.

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

### Layered Selection (default single-select; AI-evaluated multi-select allowed)

- Proceed **layer by layer in order**; earlier choices constrain later options
- Within each layer, **default is single-select**; however, the AI Agent MUST evaluate whether the layer is suitable for multi-select per "Protocol 0.5 Multi-Select Compatibility Evaluation"
- If the evaluation concludes "multi-select viable and beneficial" (no conflict + complementary strengths), the layer is presented with `multiSelect: true`, letting the user decide whether to check multiple options
- If the evaluation concludes "mutually exclusive" (multi-select causes conflict or no benefit), the layer stays `multiSelect: false`
- Generate **3-5 independent candidates per turn** (the count is dynamic and depends on context and search results; a fixed Top 3 is not required)
- Every optional layer, plugin, and extension question MUST include `None (not needed)`
- Required capabilities must not use `None` as a substitute; when a framework provides the capability, offer `Use built-in capability` as an independent option
- Users may skip recommendations and enter any custom option; the AI Agent only raises compatibility warnings and never overrides them

### 0.5 Multi-Select Compatibility Evaluation Protocol (mandatory)

> **Core goal:** Relax the hard "pick exactly one" constraint. When multiple options in the same layer don't conflict and each has irreplaceable strengths, allow the user to multi-select and encapsulate each option separately in the Core layer, combining their strengths to improve system compatibility and stability. The AI Agent MUST evaluate multi-select feasibility for every layer.

#### Evaluation Flow (MUST execute before presenting candidates for each layer)

1. **Conflict detection** — Do the candidates have structural conflicts?
   - Conflict exists (e.g., Vue and React cannot coexist) → label "mutually exclusive, single-select only," `multiSelect: false`
   - No conflict → proceed to step 2
2. **Complementarity assessment** — Does multi-select bring irreplaceable benefits?
   - Complementary benefit (e.g., Axios excels at upload/download progress, fetch excels at SSE/streaming) → label "multi-select viable, combine strengths," `multiSelect: true`
   - No complementary benefit (fully overlapping functionality, multi-select is redundant) → label "single-select recommended," `multiSelect: false`
3. **Encapsulation requirement** — When the user multi-selects, the AI Agent MUST provide independent encapsulation for each option in the Core layer and expose a unified interface; business modules only call the Core interface, never directly depend on a specific option

#### Mandatory Encapsulation Spec for Multi-Select

When a layer is multi-selected by the user, the AI Agent MUST follow these rules during project init and subsequent development:

- **Independent Core encapsulation** — Each selected option has an independent module under `core/` (e.g., `core/http/axios.ts`, `core/http/fetch.ts`)
- **Unified external interface** — Expose a unified interface via `core/http/index.ts`; business modules depend only on the interface, not on concrete implementations
- **Scenario-based routing** — The encapsulation layer automatically selects the most suitable underlying option based on request characteristics (e.g., upload/download → Axios; SSE/streaming → fetch)
- **ADR record** — Multi-select decisions MUST be recorded as an ADR, explaining each option's responsibilities and routing rules
- **No direct business-layer access** — Business modules MUST NOT directly import axios or fetch; they must go through the Core encapsulation interface

#### Typical Multi-Select Viable Layers

| Layer | Multi-select combo | Complementary rationale | Encapsulation strategy |
|-------|-------------------|------------------------|------------------------|
| Frontend-HTTP Client | Axios + native fetch | Axios: interceptors, upload/download progress, timeout; fetch: SSE, streaming, Service Worker | Core unified `request()` interface, auto-routes by Content-Type and scenario |
| Frontend-Test Framework | Vitest + Playwright | Vitest: unit/component tests; Playwright: cross-browser E2E | Independent configs, no interference |
| Frontend-CSS | TailwindCSS + CSS Modules | TailwindCSS: atomic rapid layout; CSS Modules: component-level isolation | Primary = TailwindCSS; CSS Modules for specific components |
| Backend-API Style | RESTful + gRPC | RESTful: frontend-friendly external API; gRPC: high-perf internal microservice comms | External gateway exposes RESTful; internal services use gRPC |
| Backend-Cache | Redis + in-process cache | Redis: distributed shared cache; in-process: single-node high-freq reads | Two-tier cache: check in-process first, then Redis, then DB |
| Backend-File Storage | S3/OSS + local storage | Cloud: persistence and CDN; local: temp files and cache | Tiered storage, routed by file type |
| Backend-Auth | JWT + Session | JWT: stateless API auth; Session: forced logout for traditional web | Dual auth channels, distinguished by route |

#### Typical Mutually Exclusive Layers (no multi-select)

| Layer | Exclusivity rationale |
|-------|----------------------|
| Frontend-Main Framework | Vue/React/Svelte runtimes are mutually exclusive, cannot coexist |
| Frontend-Language | TypeScript is a superset of JavaScript; pick one |
| Frontend-UI Library | Mixing multiple UI libraries causes style conflicts and bundle bloat |
| Frontend-State Management | Multiple state management solutions cause data-flow confusion |
| Frontend-Router | Multiple routing systems conflict |
| Backend-Runtime | A backend service normally uses one primary runtime |
| Backend-Language | A backend service chooses one primary development language |
| Backend-Framework | A service cannot run Spring Boot and NestJS simultaneously |
| Backend-Database (primary) | Only one primary database; auxiliary stores (Redis/ES) don't count as multi-select |
| Backend-ORM | Multiple ORMs on the same DB cause data-model confusion |

#### Evaluation Result Presentation Spec

The AI Agent MUST label the evaluation conclusion in the header or option description when presenting candidates:

```
# Multi-select viable layer
ask_followup_question({
  questions: [{
    question: "Frontend-HTTP Client? (multi-select viable: Axios excels at progress monitoring, fetch at SSE/streaming; Core layer auto-routes by scenario when multi-selected)",
    header: "Frontend-HTTP Client",
    multiSelect: true,
    options: [
      "Axios (recommended: interceptors, upload/download progress, timeout)",
      "Wrapped native fetch (recommended: SSE, streaming, zero deps)",
      "TanStack Query (data caching and sync)"
    ]
  }]
})

# Mutually exclusive layer
ask_followup_question({
  questions: [{
    question: "Frontend-Main Framework? (mutually exclusive, single-select only: Vue/React/Svelte runtimes cannot coexist)",
    header: "Frontend-Main Framework",
    multiSelect: false,
    options: [...]
  }]
})
```

**Key principle:** Multi-select is not the default behavior — it is a recommendation after AI Agent evaluation. The final decision to multi-select belongs to the user. Even if the AI evaluates "multi-select viable," the user may still select only one.

### Interactive Selection Principle (mandatory)

- The AI Agent **MUST use the `ask_followup_question` tool** to let users select via checkboxes — plain-text tables for verbal confirmation are forbidden
- Selection has four navigation phases: Phase 1 core cross-stack items, Phase 2 frontend layers, Phase 3 backend layers, and Phase 4 cross-cutting concerns; plugins and extensions use dual-trigger recommendations: evaluate them after each confirmed choice and perform a mandatory wrap-up after each side's foundational layers
- **Frontend and backend selection MUST be separated**: complete all foundational frontend layers and the frontend companion wrap-up first, then complete all foundational backend layers and the backend companion wrap-up; mixing frontend and backend layers in the same turn is forbidden, and each turn may contain exactly one question
- **All question headers MUST include a "Frontend-" or "Backend-" prefix** (except Phase 1 global decisions), to avoid user confusion
- **Multi-select compatibility evaluation (mandatory)**: before presenting candidates at each layer, the AI Agent MUST evaluate per "Protocol 0.5" whether the layer is suitable for multi-select; "multi-select viable" layers use `multiSelect: true`, "mutually exclusive" layers use `multiSelect: false`
- Companion plugins are presented as **multi-select checkboxes** for the user to pick as needed
- Each option is labeled "recommended" with a one-sentence explanation to reduce decision cost

### User Choice Principle (highest priority, mandatory)

- **The AI Agent only recommends — it never chooses for the user.** Unless the user explicitly says "auto-select the rest for me," every layer MUST be confirmed by the user via checkbox
- **Auto-filling is forbidden** for any layer (even if it seems "obvious")
- **Auto-locking is forbidden** for any layer (even if the framework ecosystem has only one mainstream option)
- **Skipping layers is forbidden** — even if the chosen framework already covers that capability
- Recommendations are only labeled "recommended" — they do not replace user selection
- The user may say "auto-select the rest for me" at any time to authorize the AI to select, but the AI must still explain and confirm each dynamic recommendation in sequence

### Capability Awareness Principle (mandatory)

- After the user picks a framework, the AI Agent **MUST check whether it already covers a later layer's capability**
- If covered: still ask the user, but present "use built-in" as the recommended option labeled "covered"
- If the user's needs exceed the built-in capability: recommend a standalone solution, labeled "choose when built-in is insufficient"
- See section 2.3 "Framework Capability Coverage Matrix" for details

---

## 2. Frontend Tech Selection — Layered Flow (default single-select; AI-evaluated multi-select allowed)

> **Mandatory rule:** Frontend selection MUST complete all foundational layers and the `Frontend-Companion Plugin Recommendations` wrap-up in Phase 2 before entering Phase 3 backend selection. Mixing frontend and backend layers in the same turn is forbidden. Each layer defaults to single-select; the AI Agent MUST evaluate per "Protocol 0.5" whether the layer is suitable for multi-select.

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

**Rule:** start at Layer 1; earlier choices shape later recommendations. Each layer defaults to single-select; the AI Agent MAY open multi-select after evaluating per "Protocol 0.5 Multi-Select Compatibility Evaluation." Completing Layer 12 does not directly start backend selection: first complete the `Frontend-Companion Plugin Recommendations` wrap-up, then end Phase 2 after user confirmation.

---

### Layer 1: Main Framework (mutually exclusive, single-select only)

| Option | Traits | Best for |
|--------|--------|----------|
| React | Largest ecosystem, strongest community, maintained by Meta | Large apps, complex interactions, international products |
| Vue | Fast onboarding, excellent Chinese docs, intuitive template syntax | Enterprise admin, management systems, China-based teams |
| Svelte | Compile-time optimization, no virtual DOM, smallest bundles | High-performance lightweight apps, personal projects |

**Signals:** admin console / China team / fast delivery → lean Vue; large complex interactions / international → lean React; extreme performance / small team → lean Svelte.

**Multi-select assessment:** ❌ Mutually exclusive — Vue/React/Svelte runtimes cannot coexist; single-select only.

**Custom input:** other frameworks allowed (Solid, Qwik, Angular); the AI only raises compatibility warnings.

---

### Layer 2: Language (mutually exclusive, single-select only)

| Option | Traits | Best for |
|--------|--------|----------|
| TypeScript | Type safety, IDE intelligence, refactor-friendly | All serious projects (default) |
| JavaScript | No compile overhead, low learning curve | Small projects, quick prototypes, learning |

**Signals:** TypeScript unless the project is tiny or purely for learning.

---

### Layer 3: Build Tool (mutually exclusive, single-select only)

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

**Multi-select assessment:** ❌ Mutually exclusive — mixing multiple UI libraries causes style conflicts and bundle bloat; single-select only.

---

### Layer 5: CSS Approach (multi-select viable, combine strengths)

| Option | Traits | Best for |
|--------|--------|----------|
| TailwindCSS | Atomic CSS, high productivity, controllable bundle size | All projects (default) |
| CSS Modules | Local scope, native build-tool support, zero deps | Simple style isolation |
| CSS-in-JS (styled-components / Emotion etc.) | Dynamic styles, component-level encapsulation | React dynamic theming |

**Signals:** default TailwindCSS; before picking a specific CSS-in-JS library, verify its maintenance status per protocols 0.1/0.3 (some libraries have entered maintenance mode).

**Multi-select assessment:** ✅ Viable — TailwindCSS (atomic rapid layout) + CSS Modules (component-level isolation) don't conflict and can combine. When multi-selected, declare the primary in the Core layer; the other is used only for specific scenarios. `multiSelect: true`

---

### Layer 6: HTTP Client (multi-select viable, combine strengths)

| Option | Traits | Best for |
|--------|--------|----------|
| Axios | Interceptors, request/response transforms, upload/download progress monitoring, timeout control, largest community | All projects (general default) |
| TanStack Query | Integrated fetching/caching/sync, auto-retry | Data-driven apps needing cache strategies |
| Wrapped native fetch | Zero deps, full control, lightweight, SSE/streaming-friendly, Service Worker integration | Minimal projects, special request needs |

**Multi-select assessment:** ✅ Viable — Axios and native fetch don't conflict; each has irreplaceable strengths:
- **Axios excels at:** upload/download progress monitoring, request/response interceptors, auto JSON transforms, timeout control, request cancellation
- **fetch excels at:** SSE (Server-Sent Events), streaming responses (ReadableStream), Service Worker integration, zero deps
- **TanStack Query** can combine with either, handling the data caching and sync layer

**Mandatory encapsulation spec for multi-select:**
```
core/http/
├── axios.ts          # Axios wrapper: interceptors, progress, timeout
├── fetch.ts          # fetch wrapper: SSE, streaming, Service Worker
├── query.ts          # TanStack Query config (if selected)
└── index.ts          # Unified external interface, auto-routes by scenario
```
- Business modules call only the unified interface exposed by `core/http`; never directly import axios or fetch
- The encapsulation layer auto-routes by request characteristics: upload/download → Axios; SSE/streaming → fetch; normal → default
- Multi-select decisions MUST be recorded as an ADR explaining each option's responsibilities and routing rules

**Single-select:** pick one as the primary. `multiSelect: true`

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

**Multi-select assessment:** ❌ Mutually exclusive — multiple state management solutions cause data-flow confusion; single-select only. (Note: local ref/reactive vs. global state store aren't multi-select — they're different levels of concern.)

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

**Multi-select assessment:** ❌ Mutually exclusive — multiple routing systems conflict; single-select only.

---

### Layer 9: Form Validation (may be covered by UI library)

> **Capability coverage note:** The following UI libraries have built-in form validation. When selected, mark this layer as covered but do not skip it by default; ask the user to choose `use built-in`, a standalone solution, or `None (not needed)`:
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
| React Hook Form | High-performance React form state management | React projects with complex forms | Independent option; may pair with Zod if the user selects it separately |
| VeeValidate | Vue ecosystem form validation | Vue projects with complex forms | Independent option; may pair with Zod if the user selects it separately |

**Multi-select assessment:** ✅ Viable — "Use UI library built-in validation" + "Zod (schema validation)" don't conflict. Built-in handles component-level immediate validation; Zod handles shared FE/BE schema and type inference. When multi-selected, Core layer wraps a unified validation interface. `multiSelect: true`

**Interactive checkbox example:**
```
options: [
  "Use Element Plus built-in validation (recommended, already covered)",
  "VeeValidate (complex Vue form state management; may pair with separately selected Zod)",
  "Zod (schema validation only, shared FE/BE)"
],
header: "Frontend-Form Validation"
```

**Pairing tip:** simple forms → use the UI library's built-in validation; complex forms → React Hook Form + Zod (React) or VeeValidate + Zod (Vue).

---

### Layer 10: Test Framework (multi-select viable, unit + E2E combo)

| Option | Traits | Best for |
|--------|--------|----------|
| Vitest | Vite-native, extremely fast, Jest-compatible API, zero config | Vite projects (default) |
| Jest | Most mature ecosystem, largest community, many legacy projects | Non-Vite projects, legacy projects |
| Playwright | E2E testing, cross-browser, auto-waiting | E2E testing needs |

**Multi-select assessment:** ✅ Viable — unit test framework (Vitest/Jest) and E2E framework (Playwright) have different responsibilities and can combine. Mainstream combo: Vitest (unit/component) + Playwright (E2E). But Vitest and Jest are mutually exclusive (both unit-test frameworks; pick one). `multiSelect: true`

---

### Layer 11: Code Quality Tools (enabled by default)

| Option | Traits | Best for |
|--------|--------|----------|
| ESLint | Industry-standard linting, largest ecosystem, rich rules, strong IDE integration | Projects needing a mature rule ecosystem |
| Prettier | Dedicated formatting with consistent cross-language output | May pair with separately selected ESLint |
| Biome | Rust-based, very fast, lint and format in one | Speed-focused, new projects |
| oxlint | Rust-based, ESLint-rule compatible | Large projects, performance-first |

**Multi-select assessment:** ⚠️ Conditionally multi-select — ESLint and Prettier have complementary responsibilities and may be selected separately; Biome normally conflicts with another primary lint/format solution. Never present `ESLint + Prettier` as one fixed option.

**Pairing tip:** TypeScript projects add `@typescript-eslint`; TailwindCSS projects add the official class-sorting plugin.

---

### Layer 12: Internationalization (optional, skippable)

| Option | Traits | Best for |
|--------|--------|----------|
| vue-i18n | Officially recommended for Vue, Composition API support | Vue projects |
| react-intl | ICU MessageFormat, React ecosystem standard | React projects |
| i18next | Framework-agnostic, largest ecosystem | General, cross-framework |

**Multi-select assessment:** ❌ Mutually exclusive — multiple i18n solutions cause translation-key management chaos; single-select only.

**Skip condition:** single-language projects may choose "not needed".

**Pairing tip:** for automatic translation-key extraction: i18next → `i18next-parser`; react-intl → `@formatjs/cli`.

---

### Mobile Technologies

Mobile selection is independent of the frontend web flow. When the project type is classified as "Mini-program / Mobile," use the following layer-by-layer selection flow:

#### Mobile Layer 1: Cross-Platform Framework (mutually exclusive, single-select only)

| Option | Traits | Best for |
|--------|--------|----------|
| UniApp | Vue syntax, covers mini-programs + apps + H5, China ecosystem | China mini-programs, multi-platform publishing (default) |
| Flutter | Cross-platform, high-performance UI, Dart language | High-performance cross-platform apps |
| React Native | JS/TS teams, cross-platform, React ecosystem | JS/TS teams, cross-platform apps |
| Android Native | Android-first, maximum platform integration | Android-first |
| iOS Native | iOS-first, maximum platform integration | iOS-first |

#### Mobile Layer 2: Language (recommend per framework)

| Framework | Language | Notes |
|-----------|----------|-------|
| UniApp | JavaScript, TypeScript | Select one in a separate language question; aligned with the web Vue ecosystem |
| Flutter | Dart | Flutter-specific language |
| React Native | JavaScript, TypeScript | Select one in a separate language question; aligned with the web React ecosystem |
| Android Native | Kotlin, Java | Select one in a separate language question; Kotlin is Google's recommendation |
| iOS Native | Swift, Objective-C | Select one in a separate language question; Swift is Apple's recommendation |

#### Mobile Layer 3: UI Component Library (recommend per framework)

| Framework | UI Library | Notes |
|-----------|-----------|-------|
| UniApp | uView / uni-ui / Vant Weapp | uView full components, uni-ui official, Vant for WeChat mini-programs |
| Flutter | Material / Cupertino | Built into Flutter |
| React Native | React Native Paper / NativeBase | Material Design / cross-platform components |
| Android Native | Material Components | Google official |
| iOS Native | SwiftUI / UIKit | SwiftUI recommended by Apple |

#### Mobile Layer 4: State Management (recommend per framework)

| Framework | State Management | Notes |
|-----------|-----------------|-------|
| UniApp | Pinia / Vuex | Same as web Vue |
| Flutter | Riverpod / Bloc / Provider | Riverpod is the modern recommendation |
| React Native | Zustand / Redux Toolkit | Same as web React |
| Android Native | ViewModel + LiveData / Compose State | Jetpack components |
| iOS Native | SwiftUI @State / Combine | Built into SwiftUI |

#### Mobile Layer 5: HTTP Client (multi-select viable, combine strengths)

| Option | Traits | Best for |
|--------|--------|----------|
| Framework built-in request | UniApp uni.request / Flutter http / RN fetch | Default, zero extra deps |
| Axios | Interceptors, upload/download progress monitoring, large community | JS/TS projects (UniApp/RN) |
| Dio | Most popular Flutter HTTP client, interceptors, progress monitoring | Flutter projects |

**Multi-select assessment:** ✅ Viable — built-in request + Axios (or Dio) don't conflict. Built-in handles simple scenarios; Axios/Dio handles complex scenarios needing interceptors and progress monitoring. Core layer wraps unified interface when multi-selected. `multiSelect: true`

#### Mobile Layer 6: Local Storage (multi-select viable, tiered storage)

| Option | Traits | Best for |
|--------|--------|----------|
| Framework built-in storage | UniApp uni.setStorage / Flutter shared_preferences / RN AsyncStorage | Default |
| Local database | SQLite / Realm / WatermelonDB | Offline data, large local data |
| MMKV | High-performance KV storage | High-performance KV needs |

**Multi-select assessment:** ✅ Viable — built-in storage (simple KV) + local database (structured data) + MMKV (high-perf KV) don't conflict; can be used in tiers. Core layer wraps a unified storage interface, routing by data type when multi-selected. `multiSelect: true`

#### Mobile Layer 7: Test Framework (recommend per framework)

| Framework | Test Framework | Notes |
|-----------|---------------|-------|
| UniApp | Vitest / Jest | Same as web Vue |
| Flutter | Flutter test (built-in) | Official built-in |
| React Native | Jest / Detox | Jest for unit, Detox for E2E |
| Android Native | JUnit / Espresso | Google recommended |
| iOS Native | XCTest | Apple official |

#### Mobile Compatibility Matrix (structural bindings)

| | UniApp | Flutter | React Native | Android Native | iOS Native |
|---|---|---|---|---|---|
| **Vue** | ✅ | ❌ | ❌ | ❌ | ❌ |
| **Dart** | ❌ | ✅ | ❌ | ❌ | ❌ |
| **JS/TS** | ✅ | ❌ | ✅ | ❌ | ❌ |
| **Kotlin** | ❌ | ❌ | ❌ | ✅ | ❌ |
| **Swift** | ❌ | ❌ | ❌ | ❌ | ✅ |

---

## 2.1 Linked Companion Plugin Recommendations

Companion plugins use dual-trigger recommendations: after the user confirms a technology, the AI Agent may trigger an immediate local recommendation; after all foundational frontend layers are complete, it MUST perform a wrap-up using the complete frontend stack. The wrap-up dynamically selects approximately five plugins or development tools that are compatible with all selected technologies and provide clear value to the current project; recommend fewer than five when there are not enough high-value candidates. Every plugin must be shown as an independent option. Multiple selected technologies in the table are trigger conditions, not a selectable bundle, and no plugin may be pre-checked. Use `multiSelect: true` and include `None (not needed)`. If the interaction tool's per-question candidate limit cannot accommodate approximately five plugins plus `None`, split them by responsibility into two consecutive wrap-up questions; never remove `None`, bundle plugins, or drop key recommendations. Backend selection MUST NOT begin until all wrap-up questions are confirmed.

### Vue Ecosystem

| Selected-tech condition | Independent plugin option | Purpose | Recommendation level |
|-------------------------|---------------------------|---------|----------------------|
| Vue + Pinia | `pinia-plugin-persistedstate` | State persistence (localStorage/sessionStorage) | Recommended |
| Vue + Pinia | `@pinia/nuxt` | Nuxt integration (Nuxt only) | Required for Nuxt |
| Vue + Vue Router | `unplugin-vue-router` | File-based, type-safe routing | Optional |
| Vue + Vite | `unplugin-auto-import` | Auto API imports | Recommended |
| Vue + Vite | `unplugin-vue-components` | Auto component imports | Recommended |

### React Ecosystem

| Selected-tech condition | Independent plugin option | Purpose | Recommendation level |
|-------------------------|---------------------------|---------|----------------------|
| React + Zustand | `zustand/middleware` (persist) | State persistence | Recommended |
| React + Redux Toolkit | `redux-persist` | State persistence | Recommended |
| React + Jotai | `jotai/utils` (atomWithStorage) | State persistence | Recommended |
| React + React Router | Route-level code splitting | Lazy route loading | Optional |
| React + Next.js | `next-auth` | Authentication | As needed |

### Svelte Ecosystem

| Selected-tech condition | Independent plugin option | Purpose | Recommendation level |
|-------------------------|---------------------------|---------|----------------------|
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

> **Core goal:** after the user picks a framework, the AI Agent dynamically detects the framework's built-in capabilities, marks subsequent layers as "covered," and offers "use built-in" as an independent candidate; it must not skip by default, and must let the user explicitly choose built-in, standalone, or `None (not needed)`.

### Frontend Framework Capability Coverage

| Chosen framework | Covered layers | Coverage description | Default strategy |
|------------------|---------------|---------------------|------------------|
| **Element Plus** (Vue) | L9 Form validation | `el-form` + `el-form-item` built-in validation rules | Skip L9, mark "covered" |
| **Ant Design** (React) | L9 Form validation | `Form` + `Form.Item` built-in validation rules | Skip L9, mark "covered" |
| **Ant Design Vue** (Vue) | L9 Form validation | Consistent with Ant Design form validation | Skip L9, mark "covered" |
| **Naive UI** (Vue) | L9 Form validation | `n-form` built-in validation | Skip L9, mark "covered" |
| **MUI** (React) | L9 Form validation | `FormControl` + `TextField` validation | Skip L9, mark "covered" |
| **Vue Router** | L8 Router | Official routing solution | Recommend "use built-in," label "covered," still require user confirmation |
| **React Router** | L8 Router | React ecosystem standard router | Recommend "use built-in," label "covered," still require user confirmation |
| **Next.js** | L3 Build + L8 Router | Built-in Turbopack build + App Router | Recommend "use built-in," label "covered," still require user confirmation |
| **SvelteKit** | L3 Build + L8 Router | Built-in Vite build + file-based routing | Recommend "use built-in," label "covered," still require user confirmation |
| **Nuxt** (Vue) | L3 Build + L8 Router | Built-in Vite build + file-based routing | Recommend "use built-in," label "covered," still require user confirmation |

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

| Selected-tech condition | Independent plugin option | Purpose | Recommendation level |
|-------------------------|---------------------------|---------|----------------------|
| Vue + Pinia | `pinia-plugin-persistedstate` | State persistence | Recommended |
| Vue + Vite | `unplugin-auto-import` | Auto API imports | Recommended |
| Vue + Vite | `unplugin-vue-components` | Auto component imports | Recommended |
| Vue + Vue Router | `unplugin-vue-router` | File-based routing | Optional |

**React ecosystem companion plugins:**

| Selected-tech condition | Independent plugin option | Purpose | Recommendation level |
|-------------------------|---------------------------|---------|----------------------|
| React + Zustand | `zustand/middleware` (persist) | State persistence | Recommended |
| React + Redux Toolkit | `redux-persist` | State persistence | Recommended |
| React + Next.js | `next-auth` | Authentication | As needed |

**NestJS ecosystem companion plugins:**

| Selected-tech condition | Independent plugin option | Purpose | Recommendation level |
|-------------------------|---------------------------|---------|----------------------|
| NestJS | `@nestjs/swagger` | Swagger docs | Recommended |
| NestJS | `@nestjs/throttler` | Rate limiting | Recommended |
| NestJS | `@nestjs/passport` | Auth strategies | Required with auth |
| NestJS | `@nestjs/schedule` | Scheduling | As needed |

**Dynamic recommendation example (illustrative only, not a fixed list):**
```
# After the user confirms Pinia, run web_search first; options below must come from live results
ask_followup_question({
  questions: [{
    question: "Frontend-Pinia companion plugins?",
    header: "Frontend-Pinia-Plugins",
    multiSelect: true,
    options: [
      "Live-researched candidate A (purpose and compatibility labeled)",
      "Live-researched candidate B (purpose and compatibility labeled)",
      "None (not needed)"
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

## 3. Backend Tech Selection — Layered Flow (default single-select; AI-evaluated multi-select allowed)

> **Mandatory rule:** Backend selection takes place in Phase 3 and MUST only start after all foundational frontend layers and the `Frontend-Companion Plugin Recommendations` wrap-up are complete. Mixing with frontend layers in the same turn is forbidden. Each turn contains exactly one question. Each layer defaults to single-select; the AI Agent MUST evaluate per "Protocol 0.5" whether the layer is suitable for multi-select. After backend Layer 12, the AI Agent MUST complete the `Backend-Companion Plugin Recommendations` wrap-up before entering cross-cutting concerns.

### Selection Flow

```
Layer 1: Backend-Runtime → Layer 1-A: Backend-Language → Layer 2: Backend-Framework → Layer 3: Backend-API Style
                                                                       ↓
Layer 4: Backend-ORM/Data Access →  Layer 5: Backend-Database    →  Layer 6: Backend-Cache
                                                                       ↓
Layer 7: Backend-Message Queue   →  Layer 8: Backend-Auth        →  Layer 9: Backend-Logging
                                                                       ↓
Layer 10: Backend-Test Framework →  Layer 11: Backend-File Storage →  Layer 12: Backend-Scheduling (optional)
```

**Rule:** start at Layer 1; earlier choices shape later recommendations. Each layer defaults to single-select; the AI Agent MAY open multi-select after evaluating per "Protocol 0.5 Multi-Select Compatibility Evaluation." Completing Layer 12 does not directly start cross-cutting selection: first complete the `Backend-Companion Plugin Recommendations` wrap-up, then end Phase 3 after user confirmation.

---

### Layer 1: Runtime (mutually exclusive, single-select only)

| Option | Traits | Best for |
|--------|--------|----------|
| Node.js | JavaScript/TypeScript server runtime with a mature ecosystem | Full-stack same-language teams, rapid iteration, small-to-mid services |
| JDK | Java runtime and standard-library foundation | Enterprise systems and large projects |
| Go Runtime | Runtime environment for compiled Go services | High-performance services, microservices, cloud-native systems |
| Python Runtime | Interpreter runtime for Python services | AI/ML, data analysis, rapid prototyping |

> **Emerging runtimes:** Bun and Deno are independent runtime candidates. Do not bundle either runtime with TypeScript. Present them after live research and label them "emerging — observe before production use."

**Multi-select assessment:** ❌ Mutually exclusive — one backend service normally selects one primary runtime. Verify runtime versions per protocol 0.1.

### Layer 1-A: Development Language (mutually exclusive, single-select only)

| Option | Traits | Best for |
|--------|--------|----------|
| TypeScript | Type safety, IDE intelligence, refactoring support | Node.js or another TypeScript-capable runtime |
| JavaScript | No type-compilation requirement, low learning curve | Node.js prototypes and lightweight services |
| Java | Mature enterprise ecosystem and tooling | JDK projects |
| Go | Compiled, high performance, native concurrency | Go Runtime projects |
| Python | AI/ML friendly, rich ecosystem, high productivity | Python Runtime projects |

**Signals:** runtime and language are independent decisions. Node.js may pair with TypeScript or JavaScript; JDK normally pairs with Java; Go Runtime pairs with Go; Python Runtime pairs with Python. The AI may explain compatibility but must not merge them into one option.

**Multi-select assessment:** ❌ Mutually exclusive — one service selects one primary development language.

**Custom input:** other runtimes or languages are allowed (Rust, C#); the AI only raises compatibility warnings.

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

#### Python Ecosystem

| Option | Traits | Best for |
|--------|--------|----------|
| FastAPI | Async, auto docs, type-safe, performant | API services, AI backends |
| Django | Full-stack framework, admin panel, built-in ORM | Content management, full-stack projects |
| Flask | Lightweight, flexible, rich ecosystem | Small projects, microservices |

**Multi-select assessment:** ❌ Mutually exclusive — a service cannot run multiple backend frameworks simultaneously; single-select only.

---

### Layer 3: API Style (multi-select viable, external/internal split)

| Option | Traits | Best for |
|--------|--------|----------|
| RESTful | Universal standard, broadest ecosystem, frontend-friendly, low learning curve | All projects (general default) |
| GraphQL | Flexible queries, fetch-on-demand, less over-fetching | Complex data queries, multi-client adaptation |
| gRPC | High performance, Protobuf serialization, strongly typed | Internal microservice communication, high-performance scenarios |

**Multi-select assessment:** ✅ Viable — RESTful (frontend-friendly external) + gRPC (high-perf internal microservice) don't conflict; a common combo in microservice architectures. When multi-selected, external gateway exposes RESTful, internal services use gRPC. Core layer wraps a unified API interface. `multiSelect: true`

**Single-select:** a pure monolith can pick RESTful only.

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

#### Python Ecosystem

| Option | Traits | Best for | Coverage status |
|--------|--------|----------|----------------|
| SQLAlchemy | Python ecosystem standard ORM, powerful, multiple patterns | General Python projects (default) | Standalone |
| Django ORM | Built into Django, deep integration with Admin | Django projects | Built into Django, mark "covered" |
| Tortoise ORM | Async ORM, Django-style API | FastAPI / async projects | Standalone |

**Signals:** China-based Java teams → MyBatis Plus; international Java teams → JPA; Node projects → Prisma first; Django projects → use built-in Django ORM; FastAPI projects → SQLAlchemy or Tortoise ORM.

**Multi-select assessment:** ⚠️ Context-dependent — multiple ORMs on the same DB cause data-model confusion (mutually exclusive); but "MyBatis Plus (complex SQL) + Spring Data JPA (simple CRUD)" or "Prisma (primary ORM) + raw SQL (complex queries)" can combine. Default single-select; multi-select only when the user explicitly needs a split of responsibilities. Core layer wraps a unified data-access interface when multi-selected. Default `multiSelect: false`

---

### Layer 5: Database (primary mutually exclusive; auxiliary stores can multi-select)

| Option | Traits | Best for |
|--------|--------|----------|
| MySQL | Most popular RDBMS, mature ecosystem, low ops cost | General business (default) |
| PostgreSQL | Advanced queries, JSON support, extensible, GIS | Advanced queries, analytics, GIS |
| MongoDB | Document-oriented, flexible schema, horizontal scaling | Document data, content management, rapid iteration |

**Multi-select assessment:** ⚠️ Primary is mutually exclusive — only one primary database. But "RDBMS primary + MongoDB (document auxiliary) + ElasticSearch (search)" is a common combo, representing multi-select of auxiliary stores for different purposes. Primary DB selection uses `multiSelect: false`; auxiliary stores (Redis/ES/MongoDB) are selected separately in their own layers.

**The AI Agent MUST justify every database choice.**

---

### Layer 6: Cache (multi-select viable, two-tier caching)

| Option | Traits | Best for |
|--------|--------|----------|
| Redis | Most popular cache, rich data structures, persistence, clustering | All projects (default) |
| Memcached | Pure in-memory cache, minimal, high performance | Pure caching, minimal needs |
| In-process cache (e.g., Caffeine) | Zero network overhead, lowest latency | Single-node caching, read-heavy |

**Multi-select assessment:** ✅ Viable — Redis (distributed shared cache) + in-process cache (single-node high-freq reads) don't conflict; a common two-tier cache strategy. When multi-selected, Core layer wraps a two-tier cache interface: check in-process first, then Redis, then fall back to DB. `multiSelect: true`

---

### Layer 7: Message Queue (multi-select viable, scenario-based split)

| Option | Traits | Best for |
|--------|--------|----------|
| RabbitMQ | Mature, flexible routing, AMQP standard, good admin UI | Enterprise messaging (default) |
| Kafka | High throughput, log streaming, distributed | Log streams, big data, high throughput |
| Redis Streams | No extra components, lightweight, reuses Redis | Small projects, simple messaging |

**Multi-select assessment:** ✅ Viable — RabbitMQ (business messaging, flexible routing) + Kafka (log streaming/big data, high throughput) don't conflict; each handles different scenarios. When multi-selected, Core layer wraps a unified messaging interface, routing by message type. `multiSelect: true`

**Single-select:** Redis Streams suffices for small projects; RabbitMQ for mid-to-large; Kafka for logging/big data.

---

### Layer 8: Authentication (multi-select viable, dual auth channels)

> **Capability coverage note:** The following backend frameworks have built-in auth integration — prefer the framework's built-in solution:
> - **NestJS** — `@nestjs/passport` integrates Passport strategies; recommend using it rather than a standalone solution
> - **Spring Boot** — Spring Security ecosystem; recommend using it rather than a standalone solution
> - **Django** — Django Auth built-in auth system; skip this layer for simple scenarios

| Option | Traits | Best for | Coverage status |
|--------|--------|----------|----------------|
| JWT | Stateless, cross-domain friendly, mobile-friendly, broad ecosystem | Decoupled FE/BE, mobile (recommended) | NestJS uses `@nestjs/passport` + JWT strategy |
| OAuth2 / OIDC | Third-party auth standard, SSO, social login | SSO, third-party login, enterprise auth | Spring Security OAuth2 |
| Session + Cookie | Traditional, server-controlled, forced logout possible | Traditional web apps, SSR | Django Auth built-in |

**Multi-select assessment:** ✅ Viable — JWT (stateless API auth) + Session (forced logout for traditional web) + OAuth2 (third-party login) don't conflict; auth method can be distinguished by route. When multi-selected, Core layer wraps a unified auth interface, auto-selecting the auth strategy by request route. `multiSelect: true`

**Single-select:** JWT for decoupled FE/BE; OAuth2/OIDC for SSO or social login; Session for traditional SSR. NestJS projects: recommend `@nestjs/passport` + JWT strategy.

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

#### Python Ecosystem

| Option | Traits | Best for | Coverage status |
|--------|--------|----------|----------------|
| Loguru | Out-of-the-box, structured, file rotation, exception tracing | General Python projects (recommended) | Standalone |
| structlog | Structured logs, JSON output | Structured logging needs | Standalone |
| Framework built-in logging | Django logging / Uvicorn logging | Small projects | Built into Django/FastAPI, skippable for simple scenarios |

**Multi-select assessment:** ❌ Mutually exclusive — multiple logging systems cause log format and output conflicts; single-select only. (Note: SLF4J is an interface standard; its implementations like Logback/Log4j2 are still mutually exclusive.)

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
| Mocha | Flexible test runner with a mature community | Custom test execution flows |
| Chai | Independent assertion library | May pair with separately selected Mocha |

#### Go Ecosystem

| Option | Traits | Best for |
|--------|--------|----------|
| Go testing (stdlib) | Official, zero deps, benchmarks | All Go projects (default) |
| testify | Assertions, mocks, suites | Stdlib enhancement |
| Ginkgo | BDD-style test framework | BDD-style preference |

#### Python Ecosystem

| Option | Traits | Best for |
|--------|--------|----------|
| Pytest | Most popular, rich plugins, fixture mechanism, parameterized tests | Python projects (default) |
| Unittest | Stdlib built-in, zero deps | Simple projects, stdlib preference |
| Robot Framework | Keyword-driven, BDD style | BDD-style preference |

**Multi-select assessment:** ⚠️ Context-dependent — same-type unit test frameworks are mutually exclusive (e.g., Jest vs. Vitest, pick one); but "unit test framework + E2E/integration test framework" can combine (e.g., JUnit 5 + RestAssured, Pytest + Behave). Default single-select; multi-select only when layered testing is needed. Default `multiSelect: false`

---

### Layer 11: File Storage (multi-select viable, tiered storage)

| Option | Traits | Best for |
|--------|--------|----------|
| S3 / OSS / COS | Cloud storage, unlimited capacity, CDN acceleration, pay-as-you-go | Cloud-deployed projects (default) |
| MinIO | S3-compatible, self-hosted object storage, open-source & free | Private deployment, intranet projects, cost-sensitive |
| Local filesystem | Zero deps, simplest, no network overhead | Single-node deployment, small projects, intranet tools |

**Multi-select assessment:** ✅ Viable — S3/OSS (persistence and CDN) + local storage (temp files and cache) don't conflict; a common tiered storage combo. When multi-selected, Core layer wraps a unified storage interface, routing by file type and purpose: persistent files → cloud; temp files → local. `multiSelect: true`

**Skip condition:** pure API projects with no file-upload needs may choose "not needed".

**Single-select:** S3/OSS + local cache is a common combo; MinIO works well as a dev-environment S3 substitute.

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

#### Python Ecosystem

| Option | Traits | Best for | Coverage status |
|--------|--------|----------|----------------|
| Celery | Distributed task queue, scheduled jobs, retries | Distributed scheduled jobs (recommended) | Standalone |
| APScheduler | Lightweight scheduled jobs, cron expressions | Single-node scheduled jobs | Standalone |
| Django cron | Django built-in scheduled jobs | Django projects, simple scenarios | Optional built-in for Django |

**Multi-select assessment:** ⚠️ Context-dependent — same-type scheduling solutions are mutually exclusive (e.g., XXL-Job vs. Quartz, pick one); but "framework built-in (simple single-node) + distributed scheduler (complex scenarios)" can combine. Default single-select; multi-select only when simple tasks and complex distributed tasks coexist. Default `multiSelect: false`

**Skip condition:** projects without scheduled jobs may choose "not needed".

---

## 3.1 Linked Backend Plugin Recommendations

Companion plugins use dual-trigger recommendations: after the user confirms a technology, the AI Agent may trigger an immediate local recommendation; after all foundational backend layers are complete, it MUST perform a wrap-up using the complete backend stack. The wrap-up dynamically selects approximately five plugins or development tools that are compatible with the project requirements, deployment model, and all selected technologies; recommend fewer than five when there are not enough high-value candidates. Every plugin must be presented as an independent option. Multiple technologies in the table are trigger conditions, not fixed-bundle options, and no plugin may be pre-selected. Use `multiSelect: true` and include `None (not needed)`. If the interaction tool's per-question candidate limit cannot accommodate approximately five plugins plus `None`, split them by responsibility into two consecutive wrap-up questions; never remove `None`, bundle plugins, or drop key recommendations. Cross-cutting selection MUST NOT begin until all wrap-up questions are confirmed.

### Java Ecosystem

| Selected-tech condition | Independent plugin option | Purpose | Recommendation level |
|-------------------------|---------------------------|---------|----------------------|
| Spring Boot + MyBatis Plus | `mybatis-plus-join` | Multi-table joins | Recommended |
| Spring Boot + MyBatis Plus | `dynamic-datasource` | Multi-datasource support | As needed |
| Spring Boot + JPA | `spring-data-envers` | Audit logs, data versioning | As needed |
| Spring Boot | `spring-boot-starter-actuator` | Health checks, monitoring | Recommended |
| Spring Boot | `springdoc-openapi` | Auto OpenAPI docs | Recommended |
| Spring Boot + Spring Cloud | Nacos etc. registry/config components | Service registration & config | Required for microservices |
| Spring Boot + file storage | S3-compatible SDK / MinIO SDK | Object storage integration | Required with file storage |
| Spring Boot + scheduling | `xxl-job-core` | Distributed scheduling center | Recommended for distributed jobs |

### Node.js Ecosystem

| Selected-tech condition | Independent plugin option | Purpose | Recommendation level |
|-------------------------|---------------------------|---------|----------------------|
| NestJS + Prisma | Prisma NestJS integration module | Prisma integration | Recommended |
| NestJS | `@nestjs/swagger` | Auto Swagger docs | Recommended |
| NestJS | `@nestjs/throttler` | Rate limiting | Recommended |
| NestJS | `@nestjs/passport` | Auth strategy integration | Required with auth |
| NestJS + file storage | S3 SDK / MinIO SDK | Object storage integration | Required with file storage |
| NestJS + scheduling | `@nestjs/schedule` | Scheduling decorators | Required with scheduling |
| Fastify | `@fastify/swagger` | Swagger docs | Recommended |
| Fastify | `@fastify/rate-limit` | Rate limiting | Recommended |

### Go Ecosystem

| Selected-tech condition | Independent plugin option | Purpose | Recommendation level |
|-------------------------|---------------------------|---------|----------------------|
| Gin + Gorm | `gorm/datatypes` | Extended data types | As needed |
| Gin + Gorm | `gorm/hints` | Optimizer hints | As needed |
| Gin | `swaggo/swag` | Auto Swagger docs | Recommended |
| Gin | `gin-contrib/cors` | CORS middleware | Recommended |
| Gin | `golang-jwt/jwt` | JWT auth | Required with auth |
| Gin + file storage | Go SDK for S3 / MinIO | Object storage integration | Required with file storage |
| Gin + scheduling | `robfig/cron` | Job scheduling | Required with scheduling |

### Python Ecosystem

| Selected-tech condition | Independent plugin option | Purpose | Recommendation level |
|-------------------------|---------------------------|---------|----------------------|
| FastAPI | `uvicorn[standard]` | ASGI server | Required |
| FastAPI | `python-multipart` | File upload support | Required for file uploads |
| FastAPI + SQLAlchemy | `alembic` | Database migrations | Recommended |
| Django | `django-rest-framework` | REST API development | Recommended for API projects |
| Django | `django-cors-headers` | CORS support | Required for FE/BE separation |
| FastAPI / Django + file storage | `boto3` (S3) / `minio` SDK | Object storage integration | Required with file storage |
| Python + scheduling | `celery[redis]` | Celery + Redis backend | Required with scheduling |

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

| | Spring Boot | Quarkus | NestJS | Express | Gin | Fiber | FastAPI | Django | Flask |
|---|---|---|---|---|---|---|---|---|---|
| **Java** | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ |
| **Node.js** | ❌ | ❌ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ |
| **Go** | ❌ | ❌ | ❌ | ❌ | ✅ | ✅ | ❌ | ❌ | ❌ |
| **Python** | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ✅ | ✅ | ✅ |

### Backend Framework × ORM

| | MyBatis Plus | JPA | Prisma | TypeORM | Gorm | sqlx | SQLAlchemy | Django ORM | Tortoise ORM |
|---|---|---|---|---|---|---|---|---|---|
| **Spring Boot** | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ |
| **NestJS** | ❌ | ❌ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ |
| **Express** | ❌ | ❌ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ |
| **Gin** | ❌ | ❌ | ❌ | ❌ | ✅ | ✅ | ❌ | ❌ | ❌ |
| **FastAPI** | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ✅ | ❌ | ✅ |
| **Django** | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ✅ | ✅ | ❌ |
| **Flask** | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ✅ | ❌ | ❌ |

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
| **Django ORM** | ✅ | ✅ | ❌ |
| **Tortoise ORM** | ✅ | ✅ | ✅ |

### Main Language × Test Framework

| | JUnit 5 | TestNG | Jest | Vitest | Go testing | Pytest |
|---|---|---|---|---|---|---|
| **Java** | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| **Node.js** | ❌ | ❌ | ✅ | ✅ | ❌ | ❌ |
| **Go** | ❌ | ❌ | ❌ | ❌ | ✅ | ❌ |
| **Python** | ❌ | ❌ | ❌ | ❌ | ❌ | ✅ |

### Main Language × Scheduling

| | @Scheduled / @nestjs/schedule | XXL-Job | Quartz | Bull family | robfig/cron | Celery | APScheduler |
|---|---|---|---|---|---|---|---|
| **Java** | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| **Node.js** | ✅ (NestJS) | ❌ | ❌ | ✅ | ❌ | ❌ | ❌ |
| **Go** | ❌ | ❌ | ❌ | ❌ | ✅ | ❌ | ❌ |
| **Python** | ❌ | ❌ | ❌ | ❌ | ❌ | ✅ | ✅ |

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

### CI/CD (mutually exclusive, single-select only)

| Option | Traits | Best for |
|--------|--------|----------|
| GitHub Actions | Built into GitHub, free tier, large ecosystem, simple config | GitHub-hosted projects |
| GitLab CI/CD | Built into GitLab, full-featured, self-managed runners | GitLab-hosted projects, private deployment |
| Jenkins | Veteran option, most plugins, fully self-controlled | Traditional enterprises, heavy customization |

**Signals:** follow the code-hosting platform; for self-hosted Gitea etc., evaluate its built-in CI or Jenkins.

**Multi-select assessment:** ❌ Mutually exclusive — CI/CD main pipeline can only have one to avoid flow conflicts; single-select only.

---

### Error Monitoring / APM (context-dependent)

| Option | Traits | Best for |
|--------|--------|----------|
| Sentry | FE+BE, open-source, large ecosystem, self-hostable | All projects (general recommendation) |
| Datadog | Full-stack monitoring: APM + logs + metrics, commercial | Enterprise full-stack monitoring |
| SkyWalking | Apache open-source, strong in Java ecosystem, free | Java microservices, private deployment |

**Signals:** limited budget / private deployment → self-hosted Sentry or SkyWalking; enterprise all-in-one monitoring → Datadog.

**Multi-select assessment:** ⚠️ Context-dependent — same-type APM is mutually exclusive (e.g., Sentry vs. Datadog, pick one); but "error monitoring (Sentry) + metrics monitoring (Prometheus+Grafana) + log collection (ELK/Loki)" don't conflict — they're different monitoring dimensions and can combine. Error monitoring main solution is single-select; other dimensions are selected separately in universal recommendations. Default `multiSelect: false`

**Pairing tip:** error monitoring + Prometheus + Grafana (metrics) is a common open-source combo.

---

### Security Scanning / SAST / DAST (multi-select viable, different dimensions)

| Option | Traits | Best for |
|--------|--------|----------|
| SonarQube / SonarCloud | Code quality + security vulnerability static scanning, CI integration | All projects (general recommendation) |
| Snyk | Dependency vulnerability scanning, auto-fix PRs, multi-language | Dependency security auditing |
| Trivy | Container image + IaC + dependency scanning, open-source & free | Containerized deployment projects |
| OWASP ZAP | Dynamic security scanning (DAST), API security testing | Security testing needs |

**Multi-select assessment:** ✅ Viable — SAST (static scanning) + dependency vulnerability scanning + container image scanning + DAST (dynamic scanning) don't conflict; they cover different security dimensions and can combine. When multi-selected, run in separate CI/CD pipeline stages. `multiSelect: true`

**Pairing tip:** SonarQube (code quality + SAST) + Snyk (dependency vulnerabilities) + Trivy (image scanning) is a common open-source security combo.

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

When the user provides a GitHub URL, Git repo, or project archive, the AI Agent MUST follow this flow.

### 6.1 Analysis Steps (mandatory, in order)

**Step 1: Read project metadata**
- Read `README.md`, `.agent/` directory (if exists), `package.json` / `pom.xml` / `go.mod` / `requirements.txt`
- Identify project positioning, business goals, tech stack, scale tier

**Step 2: Analyze directory structure**
- List first- and second-level directory tree
- Identify architecture pattern (Core + DDD / layered / MVC / unstructured)
- Check for `core/` / `modules/` / `tests/` / `docs/adr/` etc.
- Determine if it matches the scale-tier strategy from SKILL.md

**Step 3: Analyze tech stack**
- Extract tech stack and versions from dependency files
- Check against compatibility matrix in `references/tech-stack-guide.md` for incompatible combos
- Check if versions are stale (compare with latest per protocol 0.1)

**Step 4: Analyze code quality**
- Check for ESLint / Prettier / Biome etc. configuration
- Check for test directory and coverage configuration
- Check for `.env` management and env-var conventions
- Scan for hardcoded sensitive information (quick scan)

**Step 5: Analyze shared capability reuse**
- Check for `core/` layer and shared capability wrappers
- Check if business modules call low-level libs directly (axios / fetch) instead of going through Core
- Identify modules reinventing the wheel

### 6.2 Analysis Content

- Project structure
- Tech stack
- Dependency versions
- Directory conventions
- Architecture patterns
- Shared components
- Code quality
- Test coverage
- Security practices

### 6.3 Output Format (mandatory)

```
## Project Reverse Analysis Report

### 1. Project Overview
- Project name:
- Project positioning:
- Scale tier: S / M / L (with justification)
- Current stage: Prototype / MVP / Growth / Stable maintenance

### 2. Tech Stack Profile
| Layer | Choice | Version | Latest | Status |
|-------|--------|---------|--------|--------|
|  |  |  |  | ✅ Current / ⚠️ Stale / ❌ Incompatible |

### 3. Architecture Assessment
- Architecture pattern:
- Matches scale-tier strategy:
- Directory convention: ✅ Good / ⚠️ Partial / ❌ Chaotic
- Core layer completeness:
- Module modularity:

### 4. Code Quality Assessment
- Code quality tools:
- Test coverage:
- Security practices:
- Documentation completeness:

### 5. Issue List
| # | Issue | Severity | Suggested fix |
|---|-------|----------|---------------|
| 1 |  | High/Med/Low |  |

### 6. Reusable Modules
| Module | Capability | Reuse value |
|--------|-----------|-------------|
|  |  |  |

### 7. Modules Needing Refactor
| Module | Problem | Priority |
|--------|---------|----------|
|  |  |  |

### 8. Optimization Recommendations (by priority)
1. **P0 (must fix)** —
2. **P1 (should fix)** —
3. **P2 (nice to have)** —
```
