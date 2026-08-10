# Development Workflow (.agent/workflow.md)

> This file defines development, verification, release, and rollback practices. Fill commands and environments for the actual project; do not leave unconfirmed placeholders.

## Project Gates

| Project tier | Risk level | Required gates | Owner |
|--------------|------------|----------------|-------|
| S / M / L | Low / Medium / High |  |  |

High-risk projects must enable security scanning, backup/recovery, and release rollback gates at minimum. Record the reason for any trimmed gate.

## Branching Strategy

- Main branch: `main`
- Feature branches: `feature/<scope>-<desc>`
- Fix branches: `fix/<issue>-<desc>`
- Merge method: PR/MR + at least 1 reviewer (self-review acceptable for solo projects)
- Production releases may run only from a verified commit or protected tag

## Commit Convention

Conventional Commits: `feat(order): support cancellation reason note`

type: `feat` | `fix` | `refactor` | `docs` | `test` | `chore` | `perf` | `style`

- One commit should do one thing
- Use an imperative subject of no more than 72 characters
- Mark breaking changes in the footer with `BREAKING CHANGE:`

## Definition of Ready

Before implementation, confirm:

- [ ] User problem, goals, and non-goals are clear
- [ ] Core user flows and acceptance criteria are confirmed
- [ ] Domain boundaries, data changes, and authorization impact are assessed
- [ ] Dependencies, risks, and open questions have owners
- [ ] Project tier and risk level are assessed
- [ ] New or changed architectural decisions are identified

## New Feature Flow

1. Read `README.md`, `.agent/` documents, relevant modules, and dependency manifests
2. Check Core, existing modules, and Plugins; reuse first
3. Output the files to modify, add, or delete and the impact scope
4. Implement inside the appropriate module while preserving layering and dependency direction
5. Design external interfaces, database migrations, authorization, and error handling together
6. Add unit, integration, and core-flow tests
7. Run local verification and security checks
8. Open a PR describing changes, risks, migrations, and rollback steps
9. Apply review feedback and update architecture documentation or ADRs

## Definition of Done

- [ ] Acceptance criteria are met; error and boundary cases are handled
- [ ] Tests are added and passing
- [ ] Lint, type checks, and build pass
- [ ] External inputs are validated, permissions checked, and logs redacted
- [ ] Dependencies, configuration, migrations, and documentation are synchronized
- [ ] No unexplained dependencies, secrets, or unrelated refactoring were introduced
- [ ] PR review is complete and change summary and risks are recorded

## Local Verification Commands

```bash
# Fill in per project; explicitly write None (not needed) when inapplicable
<lint-command>
<typecheck-command>
<unit-test-command>
<integration-test-command>
<e2e-test-command>
<build-command>
```

Verification order: Lint → Type Check → Unit/Integration Test → E2E (core flows) → Build.
Every failure must be fixed or recorded as an explicit blocker; “it runs locally” is not a substitute for verification.

## CI Security Gates

- [ ] Dependency vulnerability scanning
- [ ] Secret scanning
- [ ] SAST / code-quality scanning
- [ ] Container image and IaC scanning (when applicable)
- [ ] License compliance checking
- [ ] Tests, type checks, and build pass
- [ ] Artifacts are traceable to a commit, version, and build log

High-risk projects must not bypass failed security gates. Exceptions require owner approval and a recorded deadline, risk, and remediation plan.

## Database and Configuration Changes

- [ ] Migration scripts are repeatable or protected by idempotency checks
- [ ] Forward migration and rollback/compensation plans are verified
- [ ] A backup and recovery point are confirmed before production migration
- [ ] Destructive changes use an expand → migrate → contract rollout
- [ ] Configuration and secrets are injected through environment variables or a secret manager

## Release Process

### Before Release

- [ ] All acceptance criteria are met
- [ ] CI passes and the artifact is generated and verified
- [ ] Release version, changelog, and impact scope are confirmed
- [ ] Migration, backup, rollback conditions, and owners are confirmed
- [ ] Monitoring, alerts, logs, and health checks are ready
- [ ] Canary or staged rollout strategy is confirmed (when applicable)

### Release Execution

1. Create the version: `<version-command>`
2. Publish the artifact: `<artifact-release-command>`
3. Run database migrations: `<migration-command>`
4. Deploy in environment order: `<environment-order>`
5. Run health checks and core-flow smoke tests
6. Observe error rate, latency, resources, and business metrics: `<observation-window>`

### Rollback Process

Trigger when error rate, core-flow failure rate, latency, data consistency, or security metrics exceed defined thresholds.

1. Freeze further rollout and record the incident
2. Roll back the application artifact: `<rollback-artifact-command>`
3. Handle database changes using the verified plan; never blindly roll back destructive migrations
4. Verify health checks, core flows, and data consistency
5. Notify stakeholders and record the incident, root cause, and follow-up actions

## Post-Release Checks

- [ ] Deployed version matches running instances
- [ ] Health checks, critical APIs, and core business flows pass
- [ ] Monitoring and alerts show no unexpected anomalies
- [ ] Database migration result is confirmed
- [ ] Release record, changelog, and ADR are updated
- [ ] Release conclusion is recorded after the observation window

## Architecture Decisions and Change Records

For decisions involving the tech stack, shared Core, data model, API compatibility, deployment, security, or migrations, add `docs/adr/NNN-<title>.md` and update `.agent/architecture.md`.
