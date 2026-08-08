# project-architecture

A Skill that makes AI Coding Agents work like senior architects: from "I want to build X" to an enterprise-grade, long-term maintainable project structure.

## The problem it solves

More people than ever code with AI, but AI-generated projects share common flaws:

- **One-line requirement → instant code dump** — no business analysis, no tech selection, straight to "Vue + SpringBoot"
- **No architecture at all** — everything piles up together; rot begins at the second iteration
- **Reinventing the wheel** — every module gets its own HTTP wrapper, error handling, and utility functions
- **Arbitrary tech choices** — stale versions, incompatible combinations, complexity for complexity's sake
- **No continuity** — a new AI session means total amnesia: no docs, no decision records

This Skill encodes a senior architect's working method as an enforceable protocol for AI Agents.

## Core capabilities

| Capability | Description |
|-----------|-------------|
| Three user modes | Auto-detected: fully-guided for beginners / business modeling for PMs / fast-track for developers |
| Scale tiers | S/M/L classification — small projects never get big architectures (anti-over-engineering) |
| Interactive checkbox selection | Uses `ask_followup_question` tool for users to check off tech choices; two phases: core framework selection + linked extended selection based on prior choices |
| Capability awareness | Auto-detects built-in capabilities of chosen frameworks (e.g., Element Plus form validation, Spring Boot logging) and skips redundant layers — no duplicate recommendations |
| Layered linkage recommendations | Choosing A auto-recommends B; earlier choices filter later options; companion plugins shown as multi-select checkboxes |
| Compatibility matrices | Instant structural binding checks; version-level compatibility verified live |
| Core + DDD architecture | Separate Core structures for frontend & backend, DDD business modules, reuse red lines |
| ADR decision records | Decisions persist; AI sessions never lose memory |
| 6-phase lifecycle | Understand → Analyze → Design → Implement → Verify → Summarize |
| Ready-to-use templates | `.agent/` four-file set, ADR template, README template |

## Supported AI Agents

OpenAI Codex · Claude Code · CodeBuddy · Cursor Agent · OpenCode · Devin-like agents

## Installation

Copy the entire `project-architecture-en/` directory into your agent's skills directory:

```bash
# Claude Code
cp -r project-architecture-en ~/.claude/skills/project-architecture

# CodeBuddy
cp -r project-architecture-en ~/.codebuddy/skills/project-architecture
```

Or install under a project-level `.claude/skills/` / `.codebuddy/skills/` to scope it to one project.

## Usage

After installation, just talk to the AI:

- "I want to build a pet-boarding mini app, and I'm not technical" (Guided mode)
- "Here's our product PRD — help me bootstrap the project" (Product mode)
- "Initialize a React + NestJS admin project for me" (Expert mode)
- "Analyze this repo's tech stack and suggest improvements" (reverse analysis)

## Directory structure

```
project-architecture-en/
├── SKILL.md                        # Entry point: mode detection, scale tiers, execution protocol
├── references/
│   ├── tech-stack-guide.md         # Detailed tech selection guide (12 layers × Top 3, FE & BE)
│   ├── architecture-design.md      # Core / DDD / ADR architecture details
│   └── dev-lifecycle.md            # 6-phase lifecycle, Git workflow, testing & security standards
├── templates/
│   ├── agent-context.md            # .agent/context.md template
│   ├── agent-architecture.md       # .agent/architecture.md template
│   ├── agent-coding-rule.md        # .agent/coding-rule.md template
│   ├── agent-workflow.md           # .agent/workflow.md template
│   ├── adr-template.md             # Architecture Decision Record template
│   ├── domain-model-template.md    # Domain model sketch template (Product mode)
│   └── project-readme-template.md  # Project README template
└── README.md
```

## Design philosophy

1. **Understand before designing; architect before coding** — never generate a full feature from a one-liner
2. **No hardcoded versions** — all versions resolved live at selection time; the docs never go stale
3. **Interactive selection** — use checkboxes, not text confirmation, to let users choose their tech stack intuitively
4. **Capability awareness** — auto-detect framework built-in capabilities, skip redundant recommendations, never reinvent the wheel
5. **The user has the final say** — the AI only flags compatibility; it never overrides user choices
6. **No big architectures on small projects** — if 50 lines solve it, don't write 200

## License

MIT
