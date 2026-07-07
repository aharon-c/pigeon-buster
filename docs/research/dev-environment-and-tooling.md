# Development Environment & Tooling

Status: **living document** · The project's software stack and the tools used to build it.
Update as choices are confirmed.

This is the project-facing tooling doc (the software stack and dev workflow).

## Language & runtime
- **Python 3.11+** on Raspberry Pi OS (64-bit, Trixie) — best ecosystem for vision/AI/GPIO and
  matches the author's Python background.
- A virtual environment (`.venv`) per machine; dependencies pinned in `requirements.txt` (or
  `pyproject.toml` if we adopt a build tool later).

## Project software stack (by subsystem)
| Subsystem | Libraries / tools | Notes |
|---|---|---|
| Camera capture | `picamera2`, `libcamera`, `rpicam-apps` | Standard Raspberry Pi camera stack |
| Inference — Path A | Sony **IMX500 / AITRIOS** tooling, `picamera2` IMX500 helpers | Model runs on-sensor |
| Inference — Path B | **Hailo SDK** (`hailo-apps`), `degirum`/`ultralytics` exports | If we move to the AI HAT+ |
| Detection models | `ultralytics` (YOLOv8/v11), MobileNet-SSD (TFLite); evaluate YOLO-World | Start fixed-class, measure first |
| Vision utilities | `opencv-python`, `numpy` | Pre/post-processing, drawing, simple tracking |
| Servo / turret | `adafruit-circuitpython-pca9685`, `adafruit-blinka`; `gpiozero`/`lgpio` | PCA9685 over I²C; GPIO for relays |
| Actuators (pump/relay/solenoid) | `gpiozero`/`lgpio` + relay/MOSFET | Fail-safe defaults to OFF |
| Messaging (split arch, optional) | `paho-mqtt` (Pi) + ESP32 firmware (Arduino/ESP-IDF/MicroPython) | Pi brain ↔ ESP32 limbs |
| Config | `pydantic` + a `config.yaml`/`.env` | All thresholds/timings live here, not in code |
| Telemetry / status | `logging` (structured/JSON), **FastAPI** local status endpoint, an LED | Read-only health view |
| Testing | **pytest**, recorded video clips, fake/stub actuators (`sim/`) | Hardware-free **dry-run** is mandatory |
| Quality | `ruff` (lint+format), `mypy` (types), `pre-commit` | Keeps the public repo tidy |

## Dev workflow tooling
- **Git + Conventional Commits**; clean history (no AI co-author trailers — see `CLAUDE.md`).
- **Plan-before-build**: agree a written plan for each non-trivial change before code (SDD).
- **Two-machine friendly**: everything needed to resume is in `docs/`. See
  `docs/onboarding/RESUME-HERE.md`.
- **Deploy to the Pi**: SSH/`scp` or `rsync` from the dev machine; a `systemd` service runs the
  app on boot with a watchdog that fails safe to OFF.

## How work is divided (SDD phases + when to use subagents)
Two separate ideas that compose:
- **SDD = sequencing.** *What exists before what:* spec → plan → tests → implementation → docs.
  It says nothing about who/what executes; it holds for one agent or many.
- **Subagents = distributing execution.** Optional specialised roles the main Claude Code
  session can delegate to. We use **Claude Code's native subagents** (in `.claude/agents/`) —
  **no external multi-agent framework** (LangGraph/CrewAI/etc.) is needed or wanted for a
  project this size.

Default to **one agent following SDD**. Reach for a subagent only when you can name the benefit:
- **researcher** — isolate exploration (hardware/packages/models) so it doesn't fill the main
  context or touch code. Read-only.
- **implementer** — build one agreed spec section (tests → code → docs). Doesn't push.
- **verifier** — review/test with *fresh context* after code is written. The strongest case for
  separation: the writer is biased toward its own code; an independent reviewer catches more.
  Read-only (reports, doesn't edit).

Typical loop for a feature: *(main agent, Plan Mode) plan → researcher if unknowns → implementer
builds → verifier reviews → main agent integrates and updates docs.* Don't over-split: each
subagent boundary costs coordination and context; a solo SDD pass is the right default.
Definitions live in `.claude/agents/{researcher,implementer,verifier}.md`; invoke explicitly
(e.g. "use the verifier subagent on the water-monitor module") or let Claude auto-delegate by
their `description`.
- **GitHub** (issues/PRs/repo) — manage the project from the assistant.
- **Pi access** (SSH/filesystem) — push code and read logs from the device.
- Add only what earns its place; document any integration here and in decisions.

## Hardware-side toolchain
- ESP32 (if used): Arduino IDE / PlatformIO / ESP-IDF, or MicroPython.
- 3D-printed mounts: any slicer; keep STLs in the repo (or a release) if we design parts.
