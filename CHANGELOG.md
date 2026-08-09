# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [5.0.0] - 2026-08-09

### Added
- Multi-Select Compatibility Evaluation Protocol (Protocol 0.5) — allows non-conflicting options to be combined (e.g., Axios + fetch, Vitest + Playwright)
- Dynamic Candidate Research (Protocol 0.4) — mandatory `web_search` before presenting candidates at each layer
- Selection Progress Tracking (7.5-A) — real-time progress summary after each batch
- Selection Result Summary (7.5-B) — mandatory tech-stack summary table auto-filled into `.agent/architecture.md`
- Selection Change Flow (7.5-C) — structured process for changing a previously selected option
- Project Type Classification (3-A) — selection flow branches for full-stack / frontend-only / backend-only / mobile / AI-ML
- Mobile technology selection flow (7 layers: framework → language → UI → state → HTTP → storage → test)
- Reverse Analysis of Existing Projects (section 6) — 5-step analysis with standardized output format
- Frontend/Backend separation rule for selection — frontend layers must complete before backend begins
- Header prefix mandatory rule — all selection headers must start with "Frontend-" or "Backend-"
- English version (`project-architecture-en`) — full translation of all SKILL.md, references, and templates
- `CONTRIBUTING.md` for community contributions
- `.gitignore` for common development artifacts

### Changed
- Tech selection now uses three-phase flow: Phase 1 (core cross-stack) → Phase 2 (all frontend) → Phase 3 (all backend) → Phase 4 (cross-cutting)
- Each layer defaults to single-select; AI Agent evaluates multi-select feasibility per Protocol 0.5
- Version numbers are never hardcoded — all resolved live at selection time
- Document tables serve as "reference baseline" only, not a closed list

### Fixed
- Removed duplicate Layer 11 (File Storage) section in Chinese `tech-stack-guide.md`
- Removed duplicate Go row in Main Language × Scheduling compatibility matrix

## [4.0.0] - 2026-06-15

### Added
- Capability Awareness & Redundancy Hints — auto-detect framework built-in capabilities
- Layered Linkage Rules — earlier choices filter later options and trigger recommendations
- Framework Capability Coverage Matrix (section 2.3)
- Compatibility Matrices for structural bindings (sections 2.2, 3.2)
- Automatic Plugin Recommendations (sections 2.1, 3.1)
- Custom Option Entry (sections 2.5, 3.3) — users can input any framework; AI only warns

### Changed
- Interactive checkbox selection via `ask_followup_question` tool (replaces plain-text confirmation)
- Selection principle: "The user always has the final say" — AI never auto-fills or auto-locks

## [3.0.0] - 2026-04-01

### Added
- Three User Modes: Guided (beginner) / Product (PM) / Expert (developer)
- Scale Tiers: S/M/L classification with anti-over-engineering principle
- Core + Business Module + Plugin + Infrastructure architecture pattern
- DDD four-layer module design (domain / application / infrastructure / interfaces)
- ADR (Architecture Decision Records) template and workflow
- `.agent/` four-file set: context.md, architecture.md, coding-rule.md, workflow.md
- 6-phase AI development lifecycle: Understand → Analyze → Design → Implement → Verify → Summarize
- Git workflow standards (branching, Conventional Commits)
- Testing standards (unit / integration / E2E, Mock strategy, test data management)
- Security standards (no hardcoded secrets, env vars, log redaction)
- Monorepo structure with pnpm workspaces + Turborepo

## [2.0.0] - 2026-02-01

### Added
- Initial tech-stack selection guide with 12 frontend layers and 12 backend layers
- Top 3 candidates per layer with traits and best-for descriptions
- Database migration strategy and tool selection
- API versioning strategy
- Dependency Injection patterns per language

## [1.0.0] - 2026-01-15

### Added
- Initial release
- Basic project architecture skill with Core + Module pattern
- README template and coding rules template