# Architecture (.agent/architecture.md)

> Records the current architecture. Architectural changes must update this file and leave a record in root `docs/adr/`.

## Project Tier and Boundaries

| Project tier | Risk level | Assessment date | Reassessment triggers |
|--------------|------------|-----------------|-----------------------|
|  | Low / Medium / High |  | User scale, data type, compliance, availability, or deployment changes |

## Tech Stack

> Remove the backend section for frontend-only projects and the frontend section for backend-only projects. Fill unused optional capabilities with `None (not needed)`; do not leave them blank.

### Frontend Tech Stack

| Layer | Choice | Version | Date | ADR |
|-------|--------|---------|------|-----|
| Runtime |  |  |  |  |
| Main framework |  |  |  |  |
| Language |  |  |  |  |
| Build tool |  |  |  |  |
| UI library |  |  |  |  |
| CSS approach |  |  |  |  |
| HTTP client |  |  |  |  |
| State management |  |  |  |  |
| Router |  |  |  |  |
| Form validation |  |  |  |  |
| Test framework |  |  |  |  |
| Code quality |  |  |  |  |
| Internationalization |  |  |  |  |
| Companion plugins |  |  |  |  |

### Backend Tech Stack

| Layer | Choice | Version | Date | ADR |
|-------|--------|---------|------|-----|
| Runtime |  |  |  |  |
| Language |  |  |  |  |
| Framework |  |  |  |  |
| API style |  |  |  |  |
| ORM / data access |  |  |  |  |
| Primary database |  |  |  |  |
| Cache |  |  |  |  |
| Message queue |  |  |  |  |
| Authentication and authorization |  |  |  |  |
| Logging |  |  |  |  |
| Test framework |  |  |  |  |
| File storage |  |  |  |  |
| Scheduling |  |  |  |  |
| Companion plugins |  |  |  |  |

### Cross-Cutting / Ops

| Layer | Choice | Version | Date | ADR |
|-------|--------|---------|------|-----|
| CI/CD |  |  |  |  |
| Error monitoring / APM |  |  |  |  |
| Metrics and log platform |  |  |  |  |
| Security scanning |  |  |  |  |
| Secret scanning |  |  |  |  |
| Dependency and license audit |  |  |  |  |
| Container / IaC scanning |  |  |  |  |
| Deployment |  |  |  |  |

## Domain and Modules

### Module Inventory

| Module | Responsibility | Owner | Status | Key dependencies |
|--------|---------------|-------|--------|------------------|
|  |  |  |  |  |

### Shared Capabilities (provided by Core — do NOT rebuild)

| Capability | Location | Usage | Ownership boundary |
|-----------|----------|-------|--------------------|
|  | core/... |  |  |

## Non-Functional Objectives

| Dimension | Objective | Verification method |
|-----------|-----------|---------------------|
| Performance / capacity |  | Load or benchmark testing |
| Availability / SLO |  | Monitoring metrics and alerts |
| Data protection |  | Classification, authorization, and redaction checks |
| Backup / recovery / RTO / RPO |  | Recovery drill |
| Observability |  | Logs, metrics, traces, and error monitoring |

## Directory Structure

<!-- Paste the actual directory tree with the responsibility of each top-level directory -->

## Deployment Architecture

<!-- Environments, deployment method, domains/entry points, configuration and secret sources -->

## Data and Security Constraints

<!-- Data classification, authorization model, threat model, compliance and license constraints -->

## Architectural Constraints (red lines)

<!-- e.g., business modules must not access the database directly; go through the application layer -->

-
