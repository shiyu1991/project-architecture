# Contributing to project-architecture

Thank you for your interest in contributing! This document covers the basics.

## How to Contribute

### Reporting Issues

1. Check existing issues to avoid duplicates
2. Open a new issue with:
   - Clear title describing the problem or suggestion
   - Steps to reproduce (for bugs)
   - Expected vs. actual behavior
   - Your AI Agent name and version (Claude Code / CodeBuddy / Cursor / etc.)

### Suggesting Enhancements

1. Open an issue with the `enhancement` label
2. Describe the use case and why the current skill doesn't cover it
3. If possible, outline the proposed solution

### Submitting Pull Requests

1. Fork the repository
2. Create a feature branch: `feature/<scope>-<desc>` (e.g., `feature/add-rust-backend`)
3. Make your changes
4. Ensure consistency:
   - If you change Chinese files, update the English version too (or vice versa)
   - Keep the same structure and formatting style
   - Do NOT hardcode version numbers — use "live query" placeholders
5. Test your changes with at least one AI Agent (Claude Code, CodeBuddy, Cursor, etc.)
6. Commit using Conventional Commits:
   ```
   feat(tech-stack): add Rust backend ecosystem
   fix(tech-stack): remove duplicate Layer 11 section
   docs(readme): update installation instructions
   ```
7. Open a PR with a clear description of what changed and why

## What We're Looking For

| Area | Examples |
|------|----------|
| New tech-stack candidates | Emerging frameworks, new languages, new tools |
| Compatibility matrix updates | Newly confirmed bindings, newly broken ones |
| Capability coverage additions | Frameworks with built-in capabilities not yet listed |
| Mobile / desktop / embedded | Expanding project type coverage |
| Translations | New language versions beyond Chinese and English |
| Template improvements | Better `.agent/` templates, new templates |
| Bug fixes | Duplicate sections, broken references, formatting issues |

## What We're NOT Looking For

- Hardcoded version numbers (the skill deliberately avoids them)
- Framework-specific deep-dive guides (keep it selection-focused)
- Marketing language for specific tools
- Removing the "user has the final say" principle

## File Structure

```
skills/
├── project-architecture/      # Chinese version
│   ├── SKILL.md                # Main entry — mode detection, scale tiers, protocols
│   ├── references/             # Detailed guides loaded on demand
│   │   ├── tech-stack-guide.md
│   │   ├── architecture-design.md
│   │   └── dev-lifecycle.md
│   ├── templates/              # Project initialization templates
│   └── README.md
└── project-architecture-en/     # English version (mirror structure)
```

## Style Guide

- Use Markdown tables for structured comparisons
- Use `>` blockquotes for important notes and protocols
- Use `**bold**` for mandatory rules and red lines
- Use code blocks for directory structures and command examples
- Keep SKILL.md as the concise entry point; push details to `references/`
- Every protocol/rule should have a clear "when" and "how"

## License

By contributing, you agree that your contributions will be licensed under the MIT License.