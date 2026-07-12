# Decision Log

Every meaningful decision, newest first. One line each, with date and rationale. Detail and
context live in the private session log entry for that date.

| Date | Decision | Rationale | Status |
|---|---|---|---|
| 2026-07-12 | Bench storage = an already-owned SanDisk High Endurance 256 GB microSD; no card purchase — phase-1 batch ≈ ₪1,300 | Free and on hand; endurance-class cards suit continuous detection logging; not A-rated, so random I/O may lag A1 (acceptable on the bench — revisit A2 only if on-device dev feels sluggish); deployment stays NVMe | Adopted |
| 2026-07-10 | Confirmed Pi 5 **8 GB** over 4 GB (₪800 vs ₪500; 4 GB out of stock at the approved reseller) | Perception alone fits 4 GB (inference is on-sensor), but 8 GB buys orchestrator/telemetry/dev-on-device headroom and keeps the Hailo-HAT/VLM upgrade path open; ₪300 is cheap insurance against re-buying the board | Adopted |
| 2026-07-09 | Targeting is species-agnostic: any bird entering the protected zone triggers deterrence; no ignore list | Matches how the site is actually used by birds; simplifies perception to a generic "bird" class, which fits Path A's fixed-class on-sensor models | Adopted |
| 2026-07-09 | Quiet hours (nightly + a weekend window): deterrent sound suppressed, water-only deterrence continues | Respect neighbours and rest windows while keeping the zone defended when birds are active | Adopted |
| 2026-07-09 | Replace the existing solar siren with a Pi-driven speaker (no gating investigation) | Full software control of when/what sound plays (incl. quiet hours); gating an unlabeled siren adds unknowns for little saving | Adopted |
| 2026-07-09 | Protected zone confirmed: ≈ 5.5 × 8.3 m envelope, engagement range 2–6.5 m | Measured on site; drives lens choice, water range, and aim accuracy | Adopted |
| 2026-07-09 | Phase-1 budget ≈ ₪1,300 (perception batch, bought locally); total ceiling deferred; no solar/turret purchases until bench measurements | Avoid buying the wrong size before FPS/accuracy/power are measured | Adopted |
| 2026-07-09 | License = MIT | Permissive, simple, standard for a public project of this size | Adopted |
| 2026-07-09 | Onboarding/setup docs refreshed to match the current environment | Resume-cold docs are only useful if they match reality | Adopted |
| 2026-06-16 | Spec made concrete (v0.2): assumptions turned into numbers tagged `[A]` + Assumptions Register | A buildable contract before Claude Code runs; every guess is visible and confirmable | Adopted |
| 2026-06-16 | Work division = SDD phases + Claude Code native subagents (researcher/implementer/verifier); no external multi-agent framework | SDD ≠ multi-agent; native subagents give role isolation (esp. fresh-context verification) without framework overhead | Adopted |
| 2026-06-16 | Tighten `.claude/settings.json`: only read-only git + test/lint pre-approved; `git add`/`git commit` always prompt; `git push` denied | Control & visibility for a learning project; keep a human checkpoint before anything enters history | Adopted |
| 2026-06-16 | Extract the spec into a standalone `docs/spec/SDD-pigeon-buster.md`; kickoff prompt now points to it | Single source of truth; the SDD exists as a real document, not embedded in the prompt | Adopted |
| 2026-06-16 | Claude Code workflow: default `high` effort; "Opus to think, Sonnet to do"; Plan Mode for non-trivial changes | Matches a multi-domain learning project; deep reasoning where it matters, cheaper execution elsewhere | Adopted |
| 2026-06-16 | Require a maintained plain-English explainer of the perception/AI pipeline (defensible by a non-author) | Learning + must explain design choices later | Adopted |
| 2026-06-16 | Project stack: Python + picamera2/IMX500 (or Hailo), ultralytics/OpenCV, PCA9685, paho-mqtt, pydantic, pytest, FastAPI | Mature, well-documented, matches author's Python background | Provisional |
| 2026-06-16 | Claude Code must clarify requirements to ~95% (batched, multiple-choice) before building | Avoids wrong-direction work; better fit for a learning project | Adopted |
| 2026-06-16 | Split docs into public (spec/research/decisions/onboarding) and local working notes (`docs/private/`, gitignored) | Keep the public repo neutral and self-contained | Adopted |
| 2026-06-16 | Use Spec-Driven Development (spec agreed before app code) | Forces clarity; good for learning; reduces rework | Adopted |
| 2026-06-16 | No AI co-author trailers; disable via `.claude/settings.json` + `commit-msg` hook; keep `CLAUDE.md` neutral | Clean history that reflects the author's own work; public files stay neutral and professional | Adopted |
| 2026-06-16 | `docs/` is the single source of truth; private session logs (chat + Claude Code) per source, every session logged regardless of length | Resume cold on any machine; capture decisions/findings/lessons | Adopted |
| 2026-06-16 | Perception starts on Path A (Pi 5 + AI Camera / IMX500); Path B (Pi 5 + Hailo AI HAT+) is the upgrade | Lowest power & simplest MVP for solar; upgrade path reuses the same rig | Provisional — confirm after measuring FPS/power |
| 2026-06-16 | Separate power rails for Pi / servos / pump, common ground | Avoid the documented brown-out that makes servos lose aim when the pump fires | Adopted |
| 2026-06-16 | Battery = LiFePO4 12.8 V; charge controller = MPPT; duty-cycle in daylight | Right chemistry for a hot roof box; more harvest; fits the solar budget | Adopted |
