# CLAUDE.md — Project conventions & working agreement

This file is loaded by Claude Code at the start of every session. It defines how work is done
in this repository. Keep it accurate; update it when conventions change.

## Project

Pigeon Buster — a solar-powered, roof-mounted device that uses a camera and on-device AI to
detect nuisance birds entering a protected area and deters them humanely (water jet and/or
sound). Deterrence only: no part of the system may physically harm an animal.

The authoritative description of *what* and *why* lives in `docs/spec/SDD-pigeon-buster.md`.
Research findings live in `docs/research/`. Read both before proposing changes.

## Clarify before building (the 95% rule)

Before producing a spec, a plan, or code for any non-trivial request, **ask clarifying
questions until you are ≥ 95% confident you understand the requirements.** Ask in small
batches (a few questions at a time), prefer concrete multiple-choice options over open
prompts, and state the assumptions you would otherwise make so I can correct them. Only once
the requirements are ~95% clear do you proceed to build. If new ambiguity appears mid-task,
pause and ask again rather than guessing. (For genuinely trivial requests, don't manufacture
questions — just confirm the one assumption that matters.)

## Workflow — Spec-Driven Development

1. Agree the spec before writing application code. For each feature, work in this order:
   spec → plan → tests → implementation → docs update.
2. If the spec is ambiguous or silent on something, ask before coding rather than guessing
   (see the 95% rule above).
3. Prefer small, reviewable commits and frequent check-ins over large code drops. Show the
   plan before large changes.

## Explain reasoning

Explain meaningful steps in plain English and give the "why" behind non-obvious choices;
never silently skip or shortcut. When choosing between options (a library, a wiring approach,
a model), state what was rejected and why. For the perception/AI pipeline specifically,
maintain a plain-English explanation of how it works — how a frame becomes a detection and a
detection becomes a turret aim — clear enough for someone to understand and defend the design.

## Subagent usage

- Run the **verifier** subagent after implementing or modifying application code
  (fresh-context review and testing; it reports findings, it does not edit).
- Delegate research questions — parts, prices, library/model comparisons — to the
  **researcher** subagent (read-only; keeps exploration out of the main context).
- Use the **implementer** subagent for well-scoped, spec-referenced implementation tasks.

Definitions live in `.claude/agents/`; `docs/research/dev-environment-and-tooling.md` explains
when a subagent earns its place (the default remains a solo SDD pass).

## Commit & attribution conventions

- **No AI co-author / `Co-Authored-By` trailers — git history reflects the author's own work.
  (Standing convention for all commits.)**
- Attribution is disabled in `.claude/settings.json` (`"attribution": {"commit":"","pr":""}`),
  with a `commit-msg` git hook as a safety net.
- Commit messages follow Conventional Commits: `feat:`, `fix:`, `docs:`, `chore:`,
  `refactor:`, `test:`. Subject ≤ 72 chars; the body explains the "why".

## Documentation system

`docs/` is the single source of truth and is kept current every session.

Committed here:
- `docs/spec/` — the specification (what & why).
- `docs/research/` — hardware, AI, power, sourcing, and cost findings.
- `docs/decisions/decision-log.md` — every meaningful decision, dated, **sanitized** for a
  public audience (one line each, with rationale).
- `docs/onboarding/RESUME-HERE.md` — how to resume the project cold on a new machine.

Local working notes (`docs/private/`, gitignored — not part of this repo):
- `docs/private/learning/log-chat.md` — session log for **planning/learning chats**.
- `docs/private/learning/log-claude-code.md` — session log for **Claude Code build sessions**
  (written directly by Claude Code, this file).

The two session logs share one format: per session, a timestamped entry with **Status** and
**Asked → Answered → Decided** (+ Why/Lesson; build sessions also note What-I-built and
Next-time). **Log every session, no matter how short** — even a one-question, one-answer
session gets its own dated entry. Use the **real system date and time**. For each meaningful
`[DECISION]`, also add a **sanitized** one-line entry to the public
`docs/decisions/decision-log.md`. See `docs/private/README.md` for details.

## Guardrails

- Humane and lawful by design (see spec §2). Fail-safe to "off" on any fault.
- On-device inference; no images leave the device except optional, user-initiated alerts.
- Never fabricate measurements (FPS, accuracy, power draw, costs) — measure and cite.
