# artix7-multiplexed-display-driver

Multiplexed 4-digit 7-segment hex display controller implemented in synthesizable Verilog for the Digilent Basys3 (Xilinx Artix-7 XC7A35T). Supports runtime-configurable digit enable, 16-switch hex input, and time-division multiplexed anode driving at ~760Hz refresh rate.

---

## Overview

This project implements a fully synthesizable 7-segment display controller for the Basys3 FPGA development board. The design reads 16 slide switches as a 16-bit hex value and displays each nibble across the four digits of the onboard common-anode 7-segment display using time-division multiplexing. Each digit can be independently enabled or disabled at runtime via the `digit_enable` input.

---

## Hardware

| Component | Details |
|-----------|---------|
| Board | Digilent Basys3 |
| FPGA | Xilinx Artix-7 XC7A35T-1CPG236C |
| Toolchain | Vivado ML Standard Edition |
| Language | Verilog HDL |

---

## Features

- 4-digit time-division multiplexed display at ~760Hz refresh rate
- Full hexadecimal support (0–F) on each digit
- 16-bit switch input split into four 4-bit nibbles
- Runtime-configurable digit enable via `digit_enable[3:0]`
- Active-low common anode and segment driving compatible with Basys3 hardware
- Fully synthesizable — no simulation-only constructs

---

## Module Hierarchy

```
seg_top          — top level: multiplexer, anode control, switch latching
└── seg_decoder  — combinational hex to 7-segment decoder (x4 instances)
```

---

## Port Descriptions

### `seg_top`

| Port | Direction | Width | Description |
|------|-----------|-------|-------------|
| `clk` | input | 1 | 100MHz system clock |
| `sw` | input | 16 | Slide switches SW0–SW15 |
| `digit_enable` | input | 4 | Runtime digit enable, active high |
| `seg` | output | 7 | Segment cathodes CA–CG, active low |
| `an` | output | 4 | Digit anodes AN0–AN3, active low |

### `seg_decoder`

| Port | Direction | Width | Description |
|------|-----------|-------|-------------|
| `nibble` | input | 4 | 4-bit hex value (0x0–0xF) |
| `seg` | output | 7 | 7-segment pattern, active low |

---

## Segment Mapping

```
seg[0] = CA  (top)
seg[1] = CB  (top right)
seg[2] = CC  (bottom right)
seg[3] = CD  (bottom)
seg[4] = CE  (bottom left)
seg[5] = CF  (top left)
seg[6] = CG  (middle)
```

---

## How It Works

### Time-Division Multiplexing

The Basys3 7-segment display is a common anode multiplexed display — all four digits share the same segment cathode lines, meaning only one digit can be driven at a time. To display four independent values simultaneously, the controller cycles through each digit rapidly enough that the human eye perceives all four as continuously lit.

The top-level module uses bits `[16:15]` of a 17-bit free-running counter to select which digit is active. At 100MHz this produces a per-digit refresh of approximately 190Hz and a full 4-digit refresh of ~760Hz, well within the 60Hz–1KHz range specified in the Basys3 reference manual.

### Digit Enable

Each digit's anode output is masked against its corresponding `digit_enable` bit. A disabled digit has its anode held high regardless of the counter state, keeping it permanently off without affecting the other digits.

### Hex Decoder

`seg_decoder` is a purely combinational module implemented as a 16-entry case statement. It maps each 4-bit input value to the corresponding active-low 7-segment pattern. Vivado's synthesis engine automatically minimizes the boolean expressions and maps them to LUTs — no manual Karnaugh map reduction required.

---

## Resource Utilization

| Resource | Count |
|----------|-------|
| LUT1 | 1 |
| LUT3 | 4 |
| LUT4 | 28 |
| MUXF7 | 14 |
| MUXF8 | 7 |
| FDRE (flip-flops) | 33 |
| BUFG | 1 |
| CARRY4 | 5 |

---

## Pin Assignments (XDC)

Key pin assignments from `Basys3_Master.xdc`:

| Signal | FPGA Pin |
|--------|----------|
| `clk` | W5 |
| `sw[0]–sw[7]` | V17–W13 |
| `sw[8]–sw[15]` | V2–R2 |
| `seg[0]–seg[6]` | W7–U7 |
| `an[0]–an[3]` | U2–W4 |

---

## Building and Programming

(Note that all necessary files can be found and downloaded in the seg_display_demo.srcs. No need to open any other files if you are replicating this build)

1. Open Vivado and create a new RTL project targeting the Basys3 board
2. Add `seg_top.v` and `seg_decoder.v` as design sources
3. Add `Basys3_Master.xdc` as a constraint source with relevant pins uncommented
4. Run Synthesis → Implementation → Generate Bitstream
5. Open Hardware Manager, connect to the Basys3, and program the device

---

## Usage

Flip switches SW0–SW15 to set the 16-bit hex value. The display updates in real time — no button press required. Each group of four switches corresponds to one hex digit:

| Switches | Digit |
|----------|-------|
| SW[3:0] | Digit 0 (rightmost) |
| SW[7:4] | Digit 1 |
| SW[11:8] | Digit 2 |
| SW[15:12] | Digit 3 (leftmost) |

---

## License

MIT License — free to use, modify, and distribute.
