# Repo Setup — bootstrap notes

How this repository was created and configured. Most of this is one-time; the parts you may
need again (hooks, permissions) are marked.

## GitHub repo metadata

**Description** (one line):

> Solar-powered, on-device AI bird deterrent for rooftops — a Raspberry Pi vision system that
> spots nuisance birds and humanely shoos them with an aimed water jet and sound.

**Topics:** `raspberry-pi` · `computer-vision` · `edge-ai` · `object-detection` · `yolo` ·
`iot` · `robotics` · `solar` · `python`

Create the repo **without** auto-adding a README, .gitignore, or licence — the scaffold
already has its own (auto-init causes a first-push conflict).

## Per-machine step — install the git hooks

Git hooks are not cloned, so on every new machine:

```bash
bash scripts/install-git-hooks.sh   # sets core.hooksPath=.githooks
```

The `commit-msg` hook strips any AI co-author / generated-by trailers, backing up the
`"attribution"` setting in `.claude/settings.json` (see `CLAUDE.md` for the convention).

## About `.claude/settings.json` permissions (and how to change them)

Claude Code asks before running anything **unless** it's in the `allow` list. The lists mean:
`allow` = run without asking · `ask` = always prompt · `deny` = never · anything unlisted =
prompt by default.

This project is configured for **control over speed**:
- **Pre-approved (`allow`)** — only read-only/safe commands: `git status`, `git diff`,
  `git log`, and the test/lint tools `pytest`, `ruff`, `mypy`. None of these change history
  or push; pre-approving them just removes pointless prompts.
- **Always prompts (`ask`)** — `git add` and `git commit`, so every change is seen and
  approved before it enters history. File edits and running arbitrary `python3` also prompt
  (they're unlisted).
- **Blocked (`deny`)** — `git push`, so nothing reaches the remote without you doing it
  yourself.

If the prompts ever feel too frequent, loosen it (e.g. add `Bash(git add:*)` to `allow`), or
use **Plan Mode** (`Shift+Tab`) for read-only sessions. Don't add `git push` to `allow` —
keep that manual. A `defaultMode` can set a stricter or looser baseline.
