# 📜 RISC-V CPU Instruction Set (RV32I) - Supported Instructions

This file outlines the full set of **RISC-V RV32I instructions** supported by our **5-stage pipelined CPU with a Two-Bit Branch Predictor**, designed and simulated using Vivado 2023.1.

---

## 🧠 Instruction Format Types

RISC-V instructions are fixed at **32-bits**, with various formats:

| Format | Description                        |
|--------|------------------------------------|
| R-Type | Register-Register operations       |
| I-Type | Immediate values, loads, jalr      |
| S-Type | Store to memory                    |
| B-Type | Branching operations               |
| U-Type | Upper Immediate instructions       |
| J-Type | Jump instructions                  |

---

## 🔢 Arithmetic and Logical Instructions

| Instruction | Format | Description                       |
|-------------|--------|-----------------------------------|
| `ADD`       | R-Type | Add two registers                 |
| `SUB`       | R-Type | Subtract two registers            |
| `AND`       | R-Type | Bitwise AND                       |
| `OR`        | R-Type | Bitwise OR                        |
| `XOR`       | R-Type | Bitwise XOR                       |
| `SLT`       | R-Type | Set if less than (signed)         |
| `SLTU`      | R-Type | Set if less than (unsigned)       |
| `SLL`       | R-Type | Logical shift left                |
| `SRL`       | R-Type | Logical shift right               |
| `SRA`       | R-Type | Arithmetic shift right            |

---

## 🧮 Immediate Arithmetic Instructions

| Instruction | Format | Description                       |
|-------------|--------|-----------------------------------|
| `ADDI`      | I-Type | Add immediate                     |
| `ANDI`      | I-Type | AND with immediate                |
| `ORI`       | I-Type | OR with immediate                 |
| `XORI`      | I-Type | XOR with immediate                |
| `SLTI`      | I-Type | Set if less than (immediate)      |
| `SLTIU`     | I-Type | Set if less than (unsigned, imm)  |
| `SLLI`      | I-Type | Shift left logical (immediate)    |
| `SRLI`      | I-Type | Shift right logical (imm)         |
| `SRAI`      | I-Type | Shift right arithmetic (imm)      |

---

## 📦 Memory Access Instructions

### Load

| Instruction | Format | Description              |
|-------------|--------|--------------------------|
| `LW`        | I-Type | Load Word                |
| `LH`        | I-Type | Load Halfword            |
| `LHU`       | I-Type | Load Halfword Unsigned   |
| `LB`        | I-Type | Load Byte                |
| `LBU`       | I-Type | Load Byte Unsigned       |

### Store

| Instruction | Format | Description              |
|-------------|--------|--------------------------|
| `SW`        | S-Type | Store Word               |
| `SH`        | S-Type | Store Halfword           |
| `SB`        | S-Type | Store Byte               |

---

## 🔀 Branch Instructions

| Instruction | Format | Description                        |
|-------------|--------|------------------------------------|
| `BEQ`       | B-Type | Branch if equal                    |
| `BNE`       | B-Type | Branch if not equal                |
| `BLT`       | B-Type | Branch if less than (signed)       |
| `BGE`       | B-Type | Branch if greater/equal (signed)   |
| `BLTU`      | B-Type | Branch if less than (unsigned)     |
| `BGEU`      | B-Type | Branch if greater/equal (unsigned) |

✅ These branch instructions are enhanced using a **2-bit Branch Predictor** for performance optimization.

---

## 🚀 Jump Instructions

| Instruction | Format | Description                |
|-------------|--------|----------------------------|
| `JAL`       | J-Type | Jump and link              |
| `JALR`      | I-Type | Jump and link register     |

---

## 🛠️ Upper Immediate Instructions

| Instruction | Format | Description                        |
|-------------|--------|------------------------------------|
| `LUI`       | U-Type | Load upper immediate               |
| `AUIPC`     | U-Type | Add upper immediate to PC          |

---

## 🧪 Simulated In Vivado 2023.1

All the above instructions have been:

- ✅ Synthesized and simulated
- ✅ Verified through waveform analysis
- ✅ Tested with real assembly programs
- ✅ Integrated into a 5-stage pipeline with branch prediction and hazard unit

---

Let us know if you'd like:

- [x] Example programs
- [x] Hazard diagrams
- [x] CPU waveform results

> 📌 Feel free to fork and modify! Contributions welcome 🚀
