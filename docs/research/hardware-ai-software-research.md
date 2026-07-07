# Research — Hardware, AI, Software, Power

Status: **living document** · Started 2026-06-16 · Owner: project author

This is a starting-point survey to make early decisions and a first purchase. Numbers marked
"measure" must be verified on real hardware before being trusted — guessed power/FPS numbers
are the most common reason these builds fail.

---

## 0. Prior art reviewed (inspiration, not to copy)

**Viral "AI pigeon deterrent"** (engineer's balcony system, went viral on Reddit/X). The
build used an **Orange Pi 5** single-board computer with a **USB camera**, ran the
**YOLO-World V2** open-vocabulary vision model to detect pigeons live, and on detection aimed
a **servo-mounted water gun** that sprayed water to scare the bird off — explicitly **without
harming it**. Because the model is open-vocabulary, the same rig can be told to deter other
visitors such as squirrels, cats, or raccoons. Takeaways we adopt: on-device detection,
servo pan/tilt aiming, low-pressure water, open-vocabulary so targets are configurable, and
humane framing. We will *not* copy code or branding — this is our own implementation.

**Real-world AIoT tutorial (internet-israel.com, by Ran Bar-Zik).** A Hebrew walkthrough of a
playful AIoT project (an AI that "nags" when a condition is detected) that demonstrates a
clean, beginner-friendly **split architecture**: a microcontroller (**ESP32**, with a camera)
handles sensing/actuation at the edge and talks to a **Raspberry Pi** "brain" over the
**MQTT** protocol, with a Bluetooth speaker for audio output. The same author has an
"What is AIoT and how to start" primer and Raspberry-Pi-on-solar / on-device-LLM posts. This
is the pattern behind our optional "split (AIoT)" architecture, and these are good
Hebrew-language learning resources since the project is being built in Israel.

---

## 1. Compute + AI accelerator

The job is real-time bird detection on a roof, on solar. That pushes us toward **on-device
("edge") inference** (privacy, no cloud cost, works offline) and toward **low, predictable
power**. Two credible single-board-computer paths:

### Path A — Raspberry Pi 5 + Raspberry Pi AI Camera (Sony IMX500)  ← recommended start
- The AI Camera runs the neural network **on the camera sensor itself** (IMX500 has an
  integrated accelerator + 8 MB on-sensor memory), doing real-time object detection while
  leaving the Pi's CPU/GPU free. This keeps system power and complexity down — attractive for
  a solar build.
- Best when we use a **fixed-class detector** (e.g., bird/pigeon) compiled for the sensor.
- Trade-off: less flexible than a general NPU; running open-vocabulary YOLO-World on-sensor is
  not its sweet spot.

### Path B — Raspberry Pi 5 + AI HAT+ (Hailo-8L 13 TOPS / Hailo-8 26 TOPS), or AI HAT+ 2 (Hailo-10H, 40 TOPS)
- A Hailo NPU on an M.2/HAT gives flexible, higher-throughput vision inference (YOLO family,
  pose, segmentation) with tight integration into the Pi camera stack (libcamera, Picamera2).
  The newer **AI HAT+ 2** (announced Jan 2026, Hailo-10H, 40 TOPS, 8 GB on-board RAM) also
  runs generative models (VLMs/LLMs); for our **vision** task its CV performance is broadly
  equivalent to the 26-TOPS predecessor, so we don't need it unless we later want a VLM.
- Best when we want **open-vocabulary** detection (YOLO-World) or to retrain/swap models
  freely, and to also deter cats/squirrels by naming them.
- Trade-off: more power and more cost than the AI Camera.

### Other options (noted, not recommended for us)
- **Orange Pi 5** — what the viral build used; capable, but Raspberry Pi has better docs and a
  bigger beginner community, which matters for a learning project.
- **NVIDIA Jetson Orin Nano** — strongest raw AI, but higher power and price; overkill on solar.
- **Google Coral USB** — proven for edge detection (used in some sentry-turret builds), a fine
  fallback accelerator on a Pi.

### Decision lean
Start on **Path A (Pi 5 + AI Camera)** for the lowest-power, simplest perception MVP. Keep
**Path B (Pi 5 + AI HAT+ with Hailo-8L)** as the upgrade if we need open-vocabulary targeting
or higher FPS. Both reuse the same Pi 5 and most of the rig, so the upgrade is cheap to make
later. Record the final call in `decisions/decision-log.md` after measuring FPS/power.

> Useful starting code (study, don't copy wholesale): community Raspberry-Pi wildlife/animal
> detection examples exist for both the **Hailo HAT** and the **IMX500** camera, plus a
> **USB-camera + Hailo** variant. Lightweight models like **YOLO-nano / MobileNet-SSD /
> TinyYOLO via TensorFlow Lite** are recommended over classical OpenCV (e.g. Haar cascades),
> which struggles with animal shapes and outdoor lighting.

---

## 2. AI model

| Option | What it is | Pros | Cons |
|---|---|---|---|
| **YOLOv8 / YOLOv11 (nano)** | Fixed-class real-time detector | Fast on edge, mature, easy to fine-tune on pigeon images | Must retrain to add/remove classes |
| **MobileNet-SSD (TFLite)** | Lightweight detector | Very low power, simple, runs on IMX500 | Lower accuracy on small/odd shapes |
| **YOLO-World (V2)** | **Open-vocabulary** detector | Name targets in plain text ("pigeon", "cat") with no retraining; matches the viral build | Heavier; best on a real NPU (Path B) |

**Plan:** prototype with a fixed-class **YOLO-nano / MobileNet-SSD** (Path A) to get an
honest FPS/accuracy/power baseline; evaluate **YOLO-World** if/when we move to Path B and want
configurable, multi-species targeting. Require **N-of-M consecutive frames** before acting to
cut false positives, with per-class confidence thresholds in config. Keep a small labelled
clip set and **measure** precision/recall — never report invented metrics.

**Concept note (for the learning log):** "open vocabulary" means the model isn't locked to a
fixed list of trained classes — you describe the target in text and it finds it. That's why
the viral rig could be re-pointed at squirrels or cats without retraining.

---

## 3. Actuation — turret, water, sound

Lessons distilled from comparable DIY turret builds (cat/critter water turrets, sentry guns):

- **Pan/tilt:** use **proportional hobby servos** (e.g., MG996R-class) for pan and tilt —
  faster than steppers for this size and drivable directly. Offload PWM to a **PCA9685**
  16-channel I²C servo driver so timing is rock-solid. A ready pan/tilt kit + the Adafruit
  servo HAT is a well-trodden path. Add **mechanical end-stops**.
- **Water delivery — two approaches:**
  1. **Low-voltage diaphragm pump** (e.g., 5–12 V) gated by a **relay/MOSFET**, drawing from
     a tank/bottle. Simple; modest range.
  2. **Pressurised tank + 12 V solenoid valve** (an air pump pressurises the tank; the valve
     releases a burst). More range/snap, more parts. A `ULN2803` or MOSFET driver switches
     the solenoid.
  Keep pressure **low** (deter, don't injure) and document the chosen nozzle/pressure.
- **⚠️ Critical power lesson (from a real cat-turret build):** energising the pump on the same
  rail as the servos caused a **voltage drop that made the servos go haywire and lose the
  target**. **Fix: give the Pi, the servos, and the pump/solenoid separate regulated supplies
  with a common ground**, size the actuator supply for the *sum* of peak currents × 1.25–1.5,
  and add bulk capacitance. This goes straight into the spec (§8) and the hardware build.
- **Aiming method:** detect → compute target box centre → map to pan/tilt angles via a
  calibrated transform → drive servos → optionally keep a simple tracker locked while firing.
- **Sound:** a small amplified speaker driven by the Pi (predator/distress audio) gated on
  detection. For the **existing solar siren** (fires on a fixed timer — annoying), investigate
  whether its trigger can be interrupted/driven by a GPIO+relay/transistor so it sounds **only
  on detection**; if it can't be cleanly gated, replace it with our own speaker module.

---

## 4. Software architecture

**Language:** Python on the Pi (great AI/vision/GPIO ecosystem; matches your Python skills).
Where hard real-time timing is needed, push it to the PCA9685 or to an ESP32.

**Two candidate shapes (decide in `decisions/`):**
- **Monolith on the Pi:** perception + orchestration + actuation drivers in one Python app.
  Simplest to start and to learn on.
- **Split (AIoT):** Pi = brain (AI + decision state machine); **ESP32** = limbs
  (servos/pump/sensors), Pi↔ESP32 over **MQTT** or serial. Isolates noisy actuator power and
  real-time control from the compute. This is the pattern in the internet-israel.com tutorial.

**Suggested modules:** `perception/` (camera + model + detections), `aiming/` (calibration +
angle math), `actuators/` (servo/pump/sound drivers), `power/` (battery/health), `orchestrator/`
(the state machine + escalation policy), `telemetry/` (logging/status), `config/` (all
thresholds/timings), and **`sim/`** so the whole pipeline can be tested with recorded video and
fake actuators — **no hardware required**. A **dry-run mode** (detect + log, never fire) is a
hard requirement for safe development.

---

## 5. Power (solar) — first-pass sizing

Battery: **LiFePO4, 12.8 V** — right chemistry for a hot sealed roof enclosure (wide temp
range, 3,000–6,000 cycles, no thermal-runaway risk). Use an **MPPT** charge controller (more
harvest than PWM). Regulate down to the Pi's 5 V on its own rail; keep actuator rails separate
with common ground.

Sizing formulas (from multiple solar-Pi guides):
- `Panel_W = Daily_Wh ÷ Peak_Sun_Hours ÷ 0.7`  (0.7 = controller/wiring/temp losses)
- `Battery_Ah = Daily_Wh ÷ Battery_V`, then add margin and **don't deep-discharge**.

Worked first-pass (to be replaced by **measured** numbers):
- Pi 5 idle ≈ 5 W; under continuous inference with accelerator ≈ 10–15 W; SSD +1–2 W; servos
  ~0 idle / bursts when aiming; pump/solenoid bursty (seconds).
- If we **duty-cycle** (active in daylight only, motion-gated, low-power idle at night),
  assume an average of ~8–12 W → ~150–290 Wh/day.
- Israel gets strong sun (~5–6 peak-sun-hours typical). At 200 Wh/day and 5 PSH:
  `200 ÷ 5 ÷ 0.7 ≈ 57 W` → buy a **100 W** panel for cloudy-day margin.
- Battery to bridge nights + ~3 overcast days: a **12.8 V, 30–50 Ah** LiFePO4 (≈ 380–640 Wh).

**Action:** measure real draw of the chosen compute+accelerator under continuous inference in
Phase 1, then re-size. Duty-cycling is both a power win and a humane/UX win (no firing at night
when target birds aren't active).

---

## 6. Enclosure & resilience
- Target **IP65** enclosure; UV-stable materials; sun shade. Camera window: optically clear,
  rain-shedding, no fogging.
- **Thermal:** a sealed box on a roof can hit ~60 °C; plan passive ventilation/heat-sinking and
  pick the Pi's active cooler. LiFePO4 tolerates this better than Li-ion.
- Cable glands for all penetrations; drip loops; mount servos/turret so water can't run back
  into electronics. Mechanical end-stops + a hardware master switch + "panic disable".

---

## 7. Indicative bill of materials (first buy)

> **Concrete parts, prices, and where to buy them (Israel / China / global) are in
> `procurement-israel-china-global.md`.** This table is the at-a-glance type list; that doc
> is the actionable shopping guide.

> Prices are rough and change; verify locally. In Israel, Raspberry Pi gear (incl. the AI
> Camera) is sold by local shops (e.g. piitel.co.il and others) — buy locally to avoid import
> hassle, or from official resellers.

| Group | Item | Notes |
|---|---|---|
| Compute | Raspberry Pi 5 (4–8 GB) + active cooler + fast microSD/NVMe | The brain |
| Perception (Path A) | Raspberry Pi AI Camera (IMX500) | On-sensor inference, low power |
| Perception (Path B, optional) | AI HAT+ (Hailo-8L 13 TOPS) + Camera Module 3 | Open-vocab / higher FPS upgrade |
| Aiming | Pan/tilt kit + 2× MG996R-class servos + PCA9685 driver | Mechanical end-stops |
| Water | 12 V diaphragm pump *or* air pump + pressurised tank + 12 V solenoid; nozzle; tubing; tank | Low pressure only |
| Switching | Relay/MOSFET board (pump/solenoid/siren); ULN2803 if using solenoids | |
| Sound | Small amplified speaker (or gate the existing siren) | Deterrent audio |
| Sensors | Water-level sensor (float/ultrasonic/load-cell); IMU/accelerometer for tamper detect | Pick per §9 of spec |
| Power | 100 W solar panel; MPPT controller; 12.8 V 30–50 Ah LiFePO4; 12→5 V buck (≥5 A); fuses | Separate actuator rail |
| Enclosure | IP65 box; cable glands; clear camera window; mounts; master switch | UV-stable |

Keep the **running cost total** updated here as you buy.

---

## 8. Top open questions to resolve early
1. Measured FPS + power of Path A vs Path B on *our* scene — drives the compute decision.
2. Can the existing solar siren be electrically gated, or must it be replaced?
3. Water range/pressure that reliably deters without any chance of harm; refill interval.
4. Local protected-species / nuisance-bird / water-use rules for lawful deployment.
5. Network on the roof (for optional Phase-2 email alerts) — Wi-Fi reach or add a link?

---

## 9. Sources (for the curious; re-verify, the field moves fast)
- Raspberry Pi AI HAT+ 2 announcement & AI docs (raspberrypi.com).
- Raspberry Pi AI Camera / IMX500 hands-on (hackster.io; raspberrypi.com docs).
- Community wildlife/animal detection examples for Hailo & IMX500 (Raspberry Pi forums).
- DIY water-turret power lesson — "Counterstrike" cat sprayer (Raspberry Pi forums).
- Sentry/turret pan-tilt + solenoid patterns (Hackaday; community projects).
- Solar-Pi sizing math & LiFePO4 rationale (multiple off-grid Pi guides).
- Inspiration write-ups: kikar.co.il (AI pigeon deterrent); internet-israel.com (AIoT, by Ran Bar-Zik).
