# <Project Name>

<!-- One-sentence intro: what it is, who it's for, what problem it solves -->

## Technical Architecture

This project uses: Core + Business Module architecture (for M/S-tier projects, delete this section and just list the stack)

- Stack: <!-- Frontend / Backend / Database / Deployment -->
- Architecture decisions: see `docs/adr/`

Core principles:

- Shared capabilities maintained centrally (core/)
- Business modules developed independently (modules/)
- No duplicate infrastructure

## Directory Guide

```
├── core        # Shared capabilities (auth / http / utils / ...)
├── modules     # Business modules (DDD layered)
├── docs        # Documentation & ADRs
└── tests       # Tests
```

## Development Environment

- Runtime: <!-- Node.js 20 LTS / JDK 17 / Go 1.x / Python 3.x -->
- Install dependencies: `<!-- npm install / mvn install / go mod tidy / pip install -r requirements.txt -->`

## Getting Started

```bash
# Development
<command>

# Build
<command>
```

## Deployment

<!-- Deployment target, release steps, required environment variables -->

## Development Standards

- Branches: `feature/*` cut from `main`, merged via PR
- Commits: Conventional Commits
- New features must include tests and pass verification before merging

## AI Agent Rules

AI Agents contributing to this project MUST:

1. Read the `.agent/` directory and this README first
2. Check core/ and existing modules before building new features — reuse first
3. Follow `.agent/coding-rule.md` and `.agent/workflow.md`
4. Record significant technical decisions as new ADRs
