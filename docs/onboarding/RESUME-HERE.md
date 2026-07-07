# RESUME HERE — picking this project back up cold

For future-me, or a fresh machine. Goal: be productive again in ~15 minutes without
re-discovering anything. Read top to bottom.

## 1. What this project is
A solar-powered, roof-mounted device that uses a camera + on-device AI to detect nuisance
birds entering a protected area and deter them humanely (water jet and/or sound).
The full spec is `docs/spec/SDD-pigeon-buster.md`. Read it first.

## 2. Where the truth lives
- **What & why:** `docs/spec/SDD-pigeon-buster.md`
- **How we work:** `CLAUDE.md` (conventions, 95% clarify rule, SDD workflow, commit rules)
- **Research, sourcing & BOM:** `docs/research/` — `hardware-ai-software-research.md`,
  `procurement-israel-china-global.md`, `dev-environment-and-tooling.md`
- **Decisions (public, sanitized):** `docs/decisions/decision-log.md`
- **Session logs & working notes (local, not part of this repo):** `docs/private/` — read the
  newest log entry's "Next time, start here" first. See `docs/private/README.md`.

## 3. Get the environment back (new machine)
```bash
git clone <PUBLIC_REPO_URL> && cd <REPO_DIR>
# local working notes (gitignored symlink; recreate once per machine)
ln -s <your-notes-location> docs/private
# Python tooling
python3 -m venv .venv && source .venv/bin/activate
pip install -r requirements.txt        # once it exists
# Claude Code
#   install per https://docs.claude.com/en/docs/claude-code/overview
claude                                  # opens in the repo; it reads CLAUDE.md automatically
```
Confirm the commit convention is active on this machine: `.claude/settings.json` should
contain `"attribution": { "commit": "", "pr": "" }`, and the git hook must be installed —
run `bash scripts/install-git-hooks.sh` (git hooks are not cloned, so do this once per
machine). It sets `core.hooksPath=.githooks` so `commit-msg` strips any AI co-author /
generated-by trailers.

## 4. Resume the work
1. Open the **newest** entry in `docs/private/learning/log-claude-code.md` (or `log-chat.md`)
   and read **"Next time, start here."**
2. Skim the open `[TODO]` / `[QUESTION]` items there and in the spec's "Open questions."
3. Start a new session-log entry (real date+time) using the template at the top of the log.
4. Tell Claude Code your goal for the session; let it propose a plan before coding.

## 5. Hardware state checklist (keep this updated)
- [ ] Which compute path is in use (A: AI Camera / B: Hailo HAT)?
- [ ] What's wired up right now, and on which power rails?
- [ ] Is it bench, or roof-mounted? Solar connected?
- [ ] Last measured: detection FPS, accuracy, average power draw.
- [ ] Known-good vs known-broken right now.

> Tip: a photo of the current wiring + a one-line note here saves an hour every time you come
> back to the hardware.
