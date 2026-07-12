# Procurement & Sourcing — Israel / China / Global

Status: **living document** · Started 2026-06-16 · Prices are indicative and change — treat as
"order of magnitude," confirm at checkout. ₪ prices were seen on the listed Israeli sites in
June 2026.

This is the "what exactly to buy and where" companion to
`hardware-ai-software-research.md` (which explains *why* each part type was chosen). Here we
pick concrete parts, give the reason for each over its alternatives, and say where to buy in
Israel, from China, or globally.

---

## Sourcing strategy (the short version)

- **The "brain" (genuine Raspberry Pi 5, AI Camera, official PSU/cooler): buy locally in
  Israel.** The price premium over import is small, you get warranty + real stock + fast
  delivery, and the official importer supports the local maker community. Counterfeit/again
  "clone" Pi boards are a real problem when buying loose online — avoid that risk on the one
  part everything depends on.
- **Commodity mechanical / actuator / solar parts (servos, PCA9685, pumps, solenoids, relays,
  panel, charge controller, enclosure): cheapest on AliExpress (China)**, with 2–4 week
  shipping. If you want them this week, Israeli hobby shops (Hackstore, 4project, see-sys,
  myls) stock the same items at a markup.
- **Genuine ICs / quality-critical modules:** buy from reputable AliExpress sellers, or from
  **Mouser.co.il / il.farnell.com / DigiKey** if you want guaranteed-authentic parts and don't
  mind the price.
- **Lithium battery (LiFePO4): prefer buying inside Israel.** Shipping lithium packs
  internationally is slow/restricted; local solar/caravan/RV shops and Israeli marketplaces
  carry 12.8 V LiFePO4 packs.

### Israeli suppliers (verified active, June 2026)
| Shop | URL | Best for |
|---|---|---|
| Piitel (פייטל) | piitel.co.il | **Official RPi importer** — Pi 5, AI Camera, PSU, cooler, cases |
| Plonter | plonter.co.il | Raspberry Pi store, components |
| Belline / בלצר (Belshop) | belshop.co.il | RPi import/distribution |
| Talmir | talmir.co.il | General electronics, dev boards |
| Hackstore | hackstore.co.il | Hobby electronics, servos, modules |
| 4project | 4project.co.il | Components incl. PCA9685, sensors |
| שיא מערכות (See-Sys) | see-sys.co.il | Servos, motors |
| MyLS | myls.co.il | Servos, motors |
| Mouser IL / Farnell IL | mouser.co.il, il.farnell.com | Genuine ICs, official distribution |

### China / global
- **AliExpress** — commodity parts, lowest price, 2–4 wk shipping. Buy from high-rating, high-
  volume "Choice"/top-rated sellers; read reviews for the exact variant.
- **Amazon** — faster than AliExpress, handy bundles (e.g. PCA9685 + servo packs ≈ $14).

---

## Bill of materials with sourcing & reasoning

### A. Compute & perception (buy genuine, locally)
| Item | Recommended part | Why this over alternatives | Where / approx price |
|---|---|---|---|
| Single-board computer | **Raspberry Pi 5, 8 GB** | 4 GB is enough for vision, but 8 GB gives headroom for the orchestrator, logging, and a possible later move to the AI HAT/VLM. Pi over Orange Pi 5 for docs + community (matters for learning). | Piitel ≈ **₪320–1,390** by RAM (8 GB mid-range); Plonter, Belshop |
| AI accelerator/camera (Path A) | **Raspberry Pi AI Camera (Sony IMX500)** | Runs detection **on-sensor**, leaving the Pi's CPU free and cutting power — ideal for solar. Ships with CSI cables + preloaded MobileNet. | Piitel ≈ **₪400** |
| (Path B upgrade, optional) | **Raspberry Pi AI HAT+ (Hailo-8L, 13 TOPS)** + **Camera Module 3** | Only if you later want open-vocabulary (YOLO-World) or higher FPS. Reuses the same Pi. | Piitel / Plonter / Belshop (HAT not always in stock — ask) |
| Active cooler | **Raspberry Pi Active Cooler** | The Pi 5 throttles under continuous inference without it; mandatory in a hot enclosure. | Piitel ≈ **₪30** |
| Power supply (bench) | **Official 27 W USB-C PSU** | For development on the desk before solar. The deployed unit is powered from the solar rail instead. | Piitel ≈ **₪70** |
| Storage | **NVMe SSD via M.2 HAT** for deployment; bench = **owned SanDisk High Endurance 256 GB** microSD (see phase-1 batch note) | SSD is far more reliable for 24/7 outdoor logging than an SD card (SD cards wear out). Start on the owned SD, move to NVMe for deployment. | NVMe + M.2 HAT: Piitel/Plonter or AliExpress |

> ⚠️ **Thermal caveat:** the AI Camera's rated operating range is **0–50 °C**. An unshaded
> roof box in an Israeli summer can exceed that. This is *why* the spec calls for a shaded,
> ventilated enclosure and duty-cycling (and possibly pausing inference in extreme heat).
> Capture this in the enclosure design.

### B. Aiming — turret (commodity; AliExpress or local hobby shops)
| Item | Recommended part | Why this over alternatives | Where / approx price |
|---|---|---|---|
| Pan/tilt servos | **2× MG996R** (metal-gear) | Metal gears + ~10 kg·cm torque handle an outdoor turret + nozzle better than plastic SG90s; proportional servos are faster than steppers here and drive directly. | AliExpress ≈ $3–5 ea; Hackstore/See-Sys/MyLS locally (₪ tens each) |
| PWM/servo driver | **PCA9685 16-ch I²C board** (Adafruit-style) | Offloads servo PWM from the Pi for jitter-free aim and frees GPIO; standard, well-documented. | AliExpress ≈ $3–6; Amazon PCA9685+servo bundle ≈ $14; 4project (Grove variant) locally |
| Pan/tilt bracket | **Metal pan/tilt bracket kit** for MG996R | Metal over plastic for outdoor longevity and to carry the nozzle mass. Add mechanical end-stops. | AliExpress ≈ $5–12 |

### C. Water deterrent (commodity)
| Item | Recommended part | Why this over alternatives | Where / approx price |
|---|---|---|---|
| Option 1 — pump | **12 V diaphragm water pump** + **relay/MOSFET module** | Simplest reliable path; pump draws from a bottle/tank. Low pressure = humane. | AliExpress ≈ $6–12 (pump) + $1–3 (relay) |
| Option 2 — pressurised | **12 V solenoid valve** + small air pump + pressurised tank + **ULN2803/MOSFET** | More range/snap and a crisp burst, but more parts and pressure to manage (keep it low). | AliExpress ≈ $5–10 (solenoid) |
| Nozzle + tubing + tank | Adjustable spray nozzle, silicone tubing, sealed reservoir | Adjustable nozzle lets you tune to "startle, not harm." | AliExpress / local hardware |

### D. Sound & sensing (commodity)
| Item | Recommended part | Why this over alternatives | Where / approx price |
|---|---|---|---|
| Deterrent sound | Small **amplified speaker** (or gate the existing solar siren via a relay/transistor on its trigger) | Reusing your siren saves money *if* its trigger can be driven; otherwise a Pi-driven speaker is more controllable (sound only on detection). | AliExpress / local; reuse existing siren = ₪0 |
| Water-level sensing | **Float switch** (simple) or **ultrasonic (HC-SR04-style)** or **load cell + HX711** | Float = cheapest/robust; ultrasonic = contactless level; load cell = "weight of water left." Start with a float switch. | AliExpress ≈ $2–8 each |
| Tamper / "attack" detect | **MPU-6050 IMU (accelerometer)** | Detects jolts/peck-impacts on the chassis cheaply; pairs with a "bird detected *on* the unit" check from the camera. | AliExpress ≈ $2–4 |
| Buzzer (low-water beeps) | Active piezo buzzer | Distinct beep patterns for refill-needed / refill-done / fault. | AliExpress / local ≈ $1 |

### E. Power — solar (panel/MPPT from China; battery locally)
| Item | Recommended part | Why this over alternatives | Where / approx price |
|---|---|---|---|
| Solar panel | **~100 W 12 V panel** | Sized with margin (see research §5: ≈57 W needed at 5 PSH; 100 W covers cloudy days + actuator bursts). Rigid glass panel for rooftop longevity. | AliExpress / local solar shops |
| Charge controller | **MPPT** controller (not PWM) | MPPT harvests meaningfully more from the same panel — important on a tight off-grid budget. | AliExpress ≈ $15–40 |
| Battery | **12.8 V LiFePO4, 30–50 Ah** | Right chemistry for a hot sealed roof box (wide temp, 3,000–6,000 cycles, no thermal runaway). 30–50 Ah bridges night + ~3 overcast days. | **Buy in Israel** (lithium shipping is slow/restricted): solar/caravan shops, local marketplaces |
| DC-DC for the Pi | **12 V → 5 V buck, ≥ 5 A** | Clean 5 V/5 A rail for the Pi **separate** from the actuator rail (the documented brown-out lesson). | AliExpress ≈ $3–8 |
| Fusing & wiring | Inline fuses, bus bars, proper gauge wire | Safety on a lithium + solar system; never skip fusing. | Local auto/solar shop |

> ⚠️ **Power-rail lesson (already in the spec):** MG996R **stall current ≈ 2.5 A each**, and
> the pump is also bursty. Size the **actuator rail** for the sum of peak currents × 1.25–1.5,
> keep it **separate** from the Pi's 5 V rail, and tie **grounds together**. Add bulk
> capacitance. Sharing one rail is what makes servos jitter and lose aim when the pump fires.

### F. Enclosure & mounting (commodity / local)
| Item | Recommended part | Why this over alternatives | Where / approx price |
|---|---|---|---|
| Enclosure | **IP65 box** with a clear camera window + sun shade | Weather + dust rating for rooftop; clear window for the camera; shade to fight the 0–50 °C limit. | AliExpress / local electrical |
| Cable glands | IP-rated glands for every penetration | Keeps water out where wires enter; add drip loops. | AliExpress / local |
| Mounting | UV-stable bracket; route servos so water can't run back into electronics | UV-stable so it survives years on a roof. | Local hardware |

---

## First purchase — two ways to buy

**Fast (mostly local, ready in days):** Pi 5 (8 GB) + AI Camera + active cooler + 27 W PSU +
microSD from **Piitel/Plonter/Belshop**; servos + PCA9685 + brackets + relay + small pump from
**Hackstore/4project**. Gets perception + a basic turret on the bench quickly.

**Cheap (mostly AliExpress, ~2–4 wks):** buy only the genuine Pi 5 + AI Camera locally; get
servos, PCA9685, brackets, pump/solenoid, sensors, buck converter, panel, MPPT, and enclosure
from AliExpress. Lowest cost, longer wait. Buy the **LiFePO4 battery locally** either way.

**Suggested phase-1 batch (just enough to start perception, no actuators):** Pi 5 (8 GB),
AI Camera, active cooler, 27 W PSU — ≈ **₪1,300** at the local reseller (prices verified
2026-07-10). **No microSD purchase:** the bench card is an already-owned **SanDisk High
Endurance 256 GB**. Caveat: High Endurance cards are not A-rated, so random I/O may be
slower than A1 — acceptable for the bench, and their continuous-write endurance is actually
a bonus for detection logging. If on-Pi development feels sluggish, consider an A2 card
then; deployment storage remains NVMe as planned. Everything else waits until perception is
measured (FPS/accuracy/power) and the compute path (A vs B) is confirmed — don't buy the
solar/turret/water parts until that decision is locked, to avoid buying the wrong size.

---

## Open sourcing questions
- Confirm current Pi 5 (8 GB) and AI HAT+ stock/price at Piitel/Plonter/Belshop at buy time.
- Decide pump vs pressurised-solenoid before buying the water parts.
- Find a local LiFePO4 12.8 V 30–50 Ah source with a sensible price and BMS included.
- Confirm whether the existing solar siren's trigger can be driven (saves the speaker cost).
