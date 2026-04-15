# 🏠 High-Performance Smart Home SoC (VLSI Project)

An industry-grade **System-on-Chip (SoC)** designed using **Verilog HDL**, integrating multiple autonomous hardware modules for real-time smart home automation. This project demonstrates **RTL design, simulation, synthesis, and FPGA implementation** using Xilinx tools.

---

## 📌 Project Overview

This Smart Home SoC implements **parallel hardware-based decision making**, eliminating software latency by executing all modules concurrently on FPGA.

### 🔥 Key Features

* ⚡ Fully synchronous RTL design (50 MHz clock)
* 🧠 Autonomous decision-making (no CPU required)
* 🔁 True hardware parallelism
* 🧪 Verified via simulation + FPGA hardware demo
* 📊 <1% FPGA resource utilization

---

## 🧩 System Architecture

The SoC integrates the following modules:

| # | Module                     | Function                                       |
| - | -------------------------- | ---------------------------------------------- |
| 1 | Thermal Intelligence Block | Temperature monitoring with hysteresis control |
| 2 | Luminance Processing Unit  | IIR low-pass filter for ambient light          |
| 3 | Security FSM               | Intrusion detection with alarm + strobe        |
| 4 | Gate Control               | PWM-based servo control with auto-close        |
| 5 | Governance Register        | Memory-mapped control modes                    |
| 6 | Top-Level SoC              | Integration & parallel execution               |

---

## ⚙️ Technologies Used

* **Hardware Description Language:** Verilog HDL
* **FPGA Platform:** Xilinx Artix-7 (Basys3 / equivalent)
* **EDA Tools:** Vivado Design Suite
* **Simulation:** Vivado Simulator / ModelSim / GTKWave

---

## 🧠 Module Highlights

### 🔹 Thermal Intelligence

* 8-bit comparator with hysteresis
* Prevents oscillation (relay chatter)

### 🔹 Luminance Processing

* Digital IIR Low-Pass Filter
* Noise-resistant lighting control

### 🔹 Security FSM

* 3-state One-Hot FSM
* States: NORMAL → ARMED → ALARM
* Generates strobe + buzzer signals

### 🔹 Gate Control

* 50 Hz PWM signal generation
* Automatic 5-second gate closure

### 🔹 Governance Register

* 2-bit control mode
* Enables system-level configuration

---

## 🧪 Simulation & Verification

* Individual testbenches for all modules
* Full-system testbench with 10+ test cases
* Functional verification using waveform analysis

### ✔ Sample Test Cases

* Temperature threshold crossing
* Hysteresis behavior validation
* Motion-triggered alarm
* PWM gate control timing
* Mode switching via governance register

---

## 📊 FPGA Implementation

* Successfully synthesized and implemented
* Bitstream generated and deployed on FPGA
* Real-time hardware demonstration completed

### 📈 Resource Utilization (Approx)

* LUTs: ~85
* Flip-Flops: ~60
* I/O Pins: ~28
* DSP / BRAM: 0

---

## 🔌 Hardware Demo

Demonstrated on FPGA using:

* Switches → Sensor inputs
* Buttons → Control signals
* LEDs → Output indicators
* PMOD → PWM output (servo)

---

## 📁 Project Structure

```
├── rtl/
│   ├── thermal_block.v
│   ├── luminance_block.v
│   ├── security_fsm.v
│   ├── gate_control.v
│   ├── governance_reg.v
│   └── smart_home_soc_top.v
│
├── tb/
│   ├── tb_thermal.v
│   ├── tb_luminance.v
│   ├── tb_security_fsm.v
│   ├── tb_gate_control.v
│   └── tb_smart_home_soc.v
│
├── constraints/
│   └── smart_home_soc.xdc
│
├── reports/
│   └── VLSI_SmartHome_SoC_Report.pdf
│
└── README.md
```

---

## ▶️ How to Run

### 🔹 Simulation

1. Add RTL + testbench in Vivado
2. Set testbench as top
3. Run Behavioral Simulation

### 🔹 FPGA Implementation

1. Run Synthesis
2. Run Implementation
3. Generate Bitstream
4. Program FPGA

---

## 🎯 Key Learnings

* RTL design methodology
* FSM design and optimization
* Digital filtering in hardware
* FPGA synthesis & timing analysis
* Hardware-software tradeoffs

---

## 🚀 Future Enhancements

* UART-based configuration
* AXI-based system integration
* IoT connectivity (WiFi/Bluetooth)
* Advanced security features

---

## 📜 License

This project is for educational and academic use.

---

## 🙌 Acknowledgements

Developed as part of Digital VLSI Design coursework.

---

⭐ If you like this project, consider starring the repository!
