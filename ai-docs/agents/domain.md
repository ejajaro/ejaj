# Domain Docs

How the engineering skills should consume this repo's domain documentation when exploring the codebase.
This is a **multi-context monorepo** (pnpm workspace: `packages/*`, `apps/*`).

## Before exploring, read these

- **`CONTEXT-MAP.md`** at the repo root if it exists — it points at one `CONTEXT.md` per package/app.
  Read each one relevant to the topic.
- **`CONTEXT.md`** inside the relevant package (e.g. `packages/grove/CONTEXT.md`).
- **`docs/adr/`** — system-wide ADRs. Also check per-package `packages/<name>/docs/adr/` for
  context-scoped decisions.

If any of these don't exist, **proceed silently**. Don't flag their absence or suggest creating them
upfront. The producer skill (`/grill-with-docs`) creates them lazily when terms or decisions get resolved.

## File structure (this repo)

```
/
├── CONTEXT-MAP.md                     ← created lazily; maps the contexts below
├── docs/adr/                          ← system-wide decisions
├── packages/
│   ├── grove/
│   │   ├── CONTEXT.md
│   │   └── docs/adr/                  ← context-specific decisions
│   ├── core/
│   ├── cli/
│   └── …
└── apps/
    └── maestro/
        └── CONTEXT.md
```

## Use the glossary's vocabulary

When your output names a domain concept (issue title, refactor proposal, hypothesis, test name), use
the term as defined in the relevant `CONTEXT.md`. Don't drift to synonyms the glossary avoids. If the
concept isn't in the glossary yet, that's a signal — either you're inventing language the project
doesn't use (reconsider) or there's a real gap (note it for `/grill-with-docs`).

## Flag ADR conflicts

If your output contradicts an existing ADR, surface it explicitly rather than silently overriding:

> _Contradicts ADR-0007 — but worth reopening because…_
