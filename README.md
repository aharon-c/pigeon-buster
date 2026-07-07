# Pigeon Buster

A solar-powered, roof-mounted device that uses a camera and **on-device AI** to detect
nuisance birds entering a defined protected area and deters them **humanely** — by aiming a
low-pressure water jet via a pan/tilt turret and/or emitting a deterrent sound. The system is
deterrence-only: no part of it is designed to harm an animal.

> Status: early development. Specification first; hardware and code follow.

## Why
Passive deterrents (e.g. a fixed-timer solar siren) fire whether or not a bird is present,
which is both annoying and ineffective. This system acts **only when a bird is actually
detected**, escalating from sound to a brief water spray, and runs unattended on solar.

## How it works (intended)
- **Perception** — a camera + on-device object detector locates target birds in real time.
- **Aiming** — a pan/tilt turret converts the target's position into pan/tilt angles.
- **Deterrence** — deterrent sound, then a brief low-pressure water burst if the bird persists.
- **Monitoring** — tracks water level (distinct low-water beep pattern) and self-protection
  alerts; optional email alerts in a later phase.
- **Power** — solar panel + MPPT charge controller + LiFePO4 battery, with duty-cycling.

## Repository layout
- `docs/spec/` — the specification (what & why), built using Spec-Driven Development.
- `docs/research/` — hardware, AI, software, power research and bill of materials.
- `docs/decisions/` — dated decision log.
- `docs/onboarding/RESUME-HERE.md` — how to set up and resume the project.
- `CLAUDE.md` — engineering conventions and working agreement.

## Conventions
- Spec-Driven Development: agree the spec before writing application code.
- Conventional Commits. Git history reflects the author's own work — no AI co-author trailers.
- On-device inference; images do not leave the device except optional, user-initiated alerts.

## Responsible use
Verify local protected-species, nuisance-bird, and water-use rules before deploying. The
device includes a master switch and a panic-disable, and fails safe to "off" on any fault.

## License
MIT — see [LICENSE](LICENSE).
