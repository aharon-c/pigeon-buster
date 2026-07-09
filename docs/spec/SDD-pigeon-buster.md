# SDD — Pigeon Buster
### Software / System Design Document · built with Spec-Driven Development

Status: **living document (v0.3, session-1 intake folded in)** · Owner: project author · Last updated: 2026-07-09

> **What "SDD" means here.** Two senses, both used: (1) **this document** — the
> Software/System Design Document (the *what* and *why*, the contract we build against); and
> (2) the **method** — Spec-Driven Development: agree the spec before code, then per feature go
> spec → plan → tests → implementation → docs (workflow rules live in `CLAUDE.md`).
>
> **How to read v0.3.** v0.2 turned assumptions into **concrete numbers**; v0.3 folds in the
> answered session-1 intake, so most site and policy values are now **confirmed** for a
> **central-Israel rooftop terrace**. Values still tagged **`[A]`** (listed in the
> **Assumptions Register, §12**) are chiefly bench-measurement or tuning items. Numbers marked
> **"measure"** must be validated on real hardware before trusted.

---

## 1. Problem & goals
Pigeons/doves roost on and above the house, creating noise and mess. A fixed-timer solar siren
fires whether or not a bird is present — annoying and ineffective. **Goal:** an autonomous
device that acts *only* when a bird is actually approaching the protected area, escalating from
sound to a brief water spray, powered by solar and able to survive on a roof.

### Success criteria (measurable)
- Detects a target bird entering the protected zone with **≥ 90 %** true-positive rate in
  daylight, with **< 1** false trigger per hour on an empty scene.
- Detection → first deterrent action in **≤ 1.5 s**.
- Runs unattended on solar for **≥ 3 consecutive overcast days** without mains.
- Humane: no mechanism can physically injure an animal (low-pressure water; deterrent-level sound).
- A non-expert can read the docs and resume the build on a new machine.

### Non-goals
Not a people-surveillance product; not lethal/harmful in any mode; not cloud-dependent
(inference on-device; cloud only for optional alerts).

## 2. Humane & legal guardrails (hard requirements)
- **Deterrence only.** Water = gentle, low-pressure stream that startles but cannot hurt; from
  the operating distance it should feel like a light spray on a human hand, never a sting.
  Verify empirically; nozzle adjustable. The pressure/range cap is **configurable within the
  humane ceiling** (it may be raised over time if deterrence results disappoint), and **all
  spray must stay inside the protected terrace — no overspray past the railing**.
- **Species-agnostic targeting (decided 2026-07):** **any bird** entering the protected zone
  is deterred; no ignore list. Humane-deterrence-only therefore applies equally to every
  species; per-class configuration (FR-8) remains available if targeting ever needs to narrow.
- **Operator responsibility:** verify local protected-species / nuisance / water-use rules
  before deployment — **open `[TODO]`**, and species-agnostic targeting makes this check
  stricter. Hardware **master switch** + software **panic-disable** required.
- **Privacy:** camera frames the protected zone (roof/sky), **not** neighbours; no images leave
  the device except optional, user-initiated alerts.

## 3. Site & environment (confirmed 2026-07)
- **Mounting:** a flat rooftop terrace enclosed by a railing, beside a pitched roof. The
  camera sits at one railing end and looks back along the terrace toward the main perch
  structures (an AC outdoor unit, a storage shed, and the adjacent pitched roof).
- **Protected zone:** the terrace (**3.5 m × 6.3 m**) plus ~1 m beyond each edge to intercept
  birds before they land ≈ a **5.5 × 8.3 m envelope (~46 m²)**; engagement range from the
  camera **2–6.5 m**. Drives lens choice, water range, and aim accuracy.
- **Climate (central Israel, confirmed):** ambient **≈ −2 °C to +42 °C**; a sealed sunlit
  enclosure can exceed **60 °C** inside. Rain mainly **Oct–Apr**. **Peak-sun-hours ≈ 6/day**
  average (winter ≈ 3.5, summer ≈ 7.5).
- **Thermal flag:** the AI Camera (IMX500) is rated **0–50 °C** — see §5/§8 (shade, ventilation,
  thermal pause). `[A]`

## 4. Functional requirements
- **FR-1 Detect:** during active hours, detect target birds; output bounding box + class +
  confidence.
- **FR-2 Locate:** map the chosen target's box centre → pan/tilt angle via a calibrated
  camera→turret transform.
- **FR-3 Escalate (concrete policy):** on a confirmed in-zone target →
  **(stage 1)** emit deterrent **sound ≤ 2 s**; **if the target persists in-zone ≥ 3 s** →
  **(stage 2)** fire a **0.6 s** low-pressure water burst toward it; **2 s cooldown**;
  re-evaluate. Caps: **≤ 6 water bursts/min**. All timings in config. `[A — tune]`
- **FR-4 Track:** keep aim updated while the target moves and stays in-zone.
- **FR-5 Water monitor:** estimate water remaining; at **≤ 15 % (~0.75 L of 5 L)** emit a
  **distinct low-water beep pattern** + "refill needed" status; a different pattern confirms
  refill. `[A]`
- **FR-6 Self-protection:** detect the unit being struck/approached and raise an alert;
  (Phase 5) email. Trigger = **IMU jolt > ~1.5 g**, OR a target bbox **> ~35 % of frame** near
  centre for **> 1 s**, OR sudden camera occlusion. `[A — tune]`
- **FR-7 Deterrent sound:** a **Pi-driven amplified speaker**, sounding **only on detection**
  and honouring quiet hours (FR-10). The pre-existing solar siren is retired, not gated —
  full software control of when/what plays outweighs reusing it.
- **FR-8 Config & disable:** all thresholds/timings in a config file; **master enable/disable**
  + **dry-run mode** (detect + log, never fire).
- **FR-9 Telemetry:** structured logs of detections/actions; a local status endpoint/LED.
- **FR-10 Quiet hours:** suppress all deterrent **sound** from **sunset until 08:00** daily,
  and from **Friday 15:30 until Sunday 08:00**; detection and **water** deterrence continue
  (water-only mode). Windows and mode in config. `[A — tune]`

## 5. Non-functional requirements
- **Resilience:** **IP65** enclosure, sun shade, passive ventilation/heat-sinking, UV-stable
  materials, clear non-fogging camera window, cable glands + drip loops. Mechanical end-stops;
  master switch + panic-disable.
- **Thermal:** keep electronics within rating; given the AI Camera's 0–50 °C limit, shade +
  ventilate and **pause inference if the interior exceeds a safe threshold (e.g. 70 °C)**. `[A]`
- **Power autonomy:** solar-only in deployment (mains only on the bench); duty-cycle (§8).
- **Latency:** detection → action **≤ 1.5 s**.
- **Safety:** **fail-safe to OFF** (no spray, no motion) on any fault, brownout, or watchdog
  timeout.
- **Maintainability:** documented, testable modules; sim/dry-run without hardware.
- **Cost:** track running BOM cost in `docs/research/`.

## 6. Architecture (decision, revisit later)
**Start: single Python app on the Raspberry Pi 5** (perception + orchestration); a **PCA9685**
drives the pan/tilt servos; relays/MOSFETs drive pump + sound. Revisit the **split (AIoT)**
pattern — Pi brain ↔ **ESP32** limbs over **MQTT** — only if real-time/power isolation demands
it. `[A]`

Module boundaries: `perception/`, `aiming/`, `actuators/`, `power/`, `orchestrator/`,
`telemetry/`, `config/`, plus `sim/` for hardware-free testing.

## 7. AI / perception spec (concrete)
- **Task:** real-time detection of **any bird** (species-agnostic — the generic COCO **"bird"**
  class); optional later classes (cat, squirrel). Output box + class + confidence. This
  simplifies Path A: fixed-class on-sensor models ship with "bird" out of the box.
- **Start model:** a **fixed-class detector** (YOLO-nano / MobileNet-SSD) compiled for the
  **IMX500** (Path A). Evaluate **YOLO-World** (open-vocabulary) only if/when we move to Path B
  and want configurable multi-species targeting. `[A]`
- **Confirmation logic (concrete):** act only when **≥ 3 of the last 5 frames** show the target
  at **confidence ≥ 0.50** (≈ 0.5 s at ~10 FPS). Per-class thresholds in config. `[A — tune]`
- **Calibration:** documented procedure mapping image coords → pan/tilt angles at the assumed
  target plane (the roof approach), with stated assumptions (distance/plane).
- **Aiming targets (concrete):** **pan ±90°, tilt 0–60°** (servo + end-stops); centre the
  target within **±3°** (enough to wet at up to ~6.5 m). `[A]`
- **Evaluation:** keep a small labelled clip set; report precision/recall + FPS. **Never
  fabricate metrics — measure them.**

## 8. Power spec (solar, concrete first-pass — MEASURE then resize)
- **Compute:** Pi 5 (8 GB) + AI Camera (IMX500), Path A.
- **Draw estimate (to measure):** active daylight **~9 W**, night idle **~3 W**. Duty-cycle:
  active **sunrise→sunset**, low-power idle at night.
- **Daily energy:** ≈ 13 h × 9 W + 11 h × 3 W ≈ **150 Wh**; **design target 180 Wh** with
  actuator bursts + margin. `[A — measure]`
- **Panel:** `180 ÷ 6 PSH ÷ 0.7 ≈ 43 W` → spec a **100 W** panel (winter/cloud + peak margin). `[A]`
- **Battery:** **LiFePO4 12.8 V, 50 Ah (~640 Wh)** + **MPPT** controller → ~2.5–3 days above
  20 % DoD; bump to **60 Ah** if the 3-day target misses after measurement. `[A]`
- **Rails (hard lesson):** Pi on its own **12→5 V buck (≥ 5 A)**; servos + pump on a **separate
  rail**; **common ground**; bulk capacitance; fuses. (Shared rail → pump browns out servos →
  aim drifts.)

## 9. Resource monitoring & self-protection (concrete)
- **Water level:** start with a **float switch** (robust/cheap) plus a software **burst-budget**
  estimate; evaluate ultrasonic/load-cell later. `[A]`
- **Beep patterns:** refill-needed = **3 short beeps, repeating**; refill-confirmed = **1 long
  beep**; fault = **SOS-like pattern**. `[A]`
- **Self-protection:** thresholds as in FR-6; action = local alert now, email in Phase 5.

## 10. Phasing
- **Phase 0 — Foundations:** repo, docs, conventions, spec agreed, BOM, dev env.
- **Phase 1 — Perception (bench):** camera + detector running, **measured** FPS/accuracy/power,
  dry-run logging only (no actuators).
- **Phase 2 — Aiming:** turret + calibration; aim at a detected target in sim, then bench (no water).
- **Phase 3 — Deterrents:** sound, then low-pressure water with safety interlocks.
- **Phase 4 — Power & enclosure:** solar, battery, rails, IP65 housing, thermal.
- **Phase 5 — Monitoring & alerts:** water level + beeps, self-protection, email alerts.
- **Phase 6 — Field hardening:** tuning, reliability, redeploy/handover docs.

Phases are deliberately cut **small**, each ending in a demonstrable, committed milestone —
available hours vary week to week, and the repo should always show working progress.

## 11. Network & budget
- **Network:** **good terrace Wi-Fi** (confirmed) — helps development (SSH to the Pi) and the
  optional Phase-5 alerts. Core deterrence must still work **fully offline**.
- **Budget (decided 2026-07):** **Phase-1 ≈ ₪1,300** (Pi 5 8 GB + AI Camera + cooler + PSU +
  microSD, bought locally; see `docs/research/procurement-israel-china-global.md`). The
  **total ceiling is deliberately deferred** until Phase-1 bench measurements size the
  solar/turret spend. `[A — total ceiling pending]`

## 12. Assumptions Register (resolve these)
| # | Assumption (current concrete value) | How we confirm |
|---|---|---|
| A1 | **Resolved 2026-07:** zone ≈ 5.5 × 8.3 m envelope (terrace 3.5 × 6.3 m + 1 m margin); engagement 2–6.5 m | Measured on site |
| A2 | Climate −2…+42 °C; PSH ≈ 6; interior may exceed 60 °C | **Confirmed 2026-07** as defaults; validate with a cheap roof logger |
| A3 | **Resolved 2026-07:** species-agnostic — any bird triggers; no ignore list | Decided |
| A4 | Escalation: sound ≤2 s → if persists ≥3 s → 0.6 s water; ≤6 bursts/min | Tune on the bench |
| A5 | Confirm logic 3-of-5 @ conf ≥0.50 | Tune against the labelled clip set |
| A6 | Aim: pan ±90°, tilt 0–60°, accuracy ±3° | Validate after calibration |
| A7 | Reservoir 5 L; burst ~0.6 s ≈ 25–40 mL; low-water ≤15 % | Measure on the bench |
| A8 | Power: ~9 W active / ~3 W idle; 180 Wh/day; 100 W panel; 50 Ah LiFePO4 | **Measure** real draw in Phase 1, then resize |
| A9 | **Resolved 2026-07:** existing siren replaced by our own Pi-driven speaker | Decided |
| A10 | Architecture: monolith on the Pi to start; split-ready hardware (PCA9685 behind a clean interface) | Revisit if real-time/power needs it |
| A11 | **Confirmed 2026-07:** good terrace Wi-Fi; alerts optional; core works offline | Re-test at install |
| A12 | Budget: **phase-1 ≈ ₪1,300 set**; total ceiling deferred | Set after Phase-1 measurements |
| A13 | Quiet hours: sound off sunset→08:00 daily + Fri 15:30→Sun 08:00; water-only in those windows | Tune windows in config after field experience |

> Many of these map to the questionnaire in `docs/private/session-1-intake.md`. Answer those to
> close the register; record each resolution in the session log + `docs/decisions/decision-log.md`.
