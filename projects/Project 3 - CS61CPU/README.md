# CS61CPU – Two-Cycle RISC-V CPU

## Overview

This project implements a **two-cycle RISC-V CPU**. The CPU is designed and implemented in **Logisim**. The goal is to understand how instructions are executed across multiple cycles using a shared datapath and control logic.

## Features

- 32-bit RISC-V Architecture: Implements a subset of the standard RISC-V ISA.

- Full ALU Support: Handles operations such as addition, subtraction, logical shifts, bitwise logic, comparisons, and multiplication.

- 32-Register File: A complete 32-register set with dual-read ports and a single-write port, including a hardwired zero register (x0).

- Two-Cycle Pipelining: Features a two-stage pipeline consisting

  - **Cycle 1**: Instruction Fetch / Decode
  - **Cycle 2**: Execute / Memory / Writeback

- Memory Integration: Interfaces with a word-addressable, byte-level write-enabled memory unit.

## Project Structure

The project is built across several specialized circuit files:

- `alu.circ`: The Arithmetic Logic Unit.

- `regfile.circ`: The Register File.

- `imm_gen.circ`: The Immediate Generator.

- `control_logic.circ`: The CPU control unit.

- `branch_comp.circ`: Logic for branch comparisons.

- `cpu.circ`: The top-level processor datapath where all components are integrated

## Supported Instruction Set

The processor is designed to handle the following instructions from the RISC-V ISA (**RV32I**):

| Instruction Format |                                  Instructions                                   |
| :----------------: | :-----------------------------------------------------------------------------: |
|         R          | add, sub, sll, slt, srl, sra, or, xor, and, mul, mulh, mulhu, jalr, csrw, csrwi |
|         I          |            lb, lh, lw, addi, slli, slti, srli, srai, ori, xori, andi            |
|         S          |                                   sb, sh, sw                                    |
|         B          |                         beq, bne, blt, bge, bltu, bgeu                          |
|         U          |                                   auipc, lui                                    |
|         J          |                                       jal                                       |

## Getting Started

### Prerequisites

- **Java** (to run Logisim Evolution).

- **Python 3** (to run the provided test suites).

- **logisim-evolution.jar** (must be the version provided in the project repository).

---

### How to View the Circuits

To inspect the internal wiring and logic of the CPU, follow these steps:

1. **Launch Logisim Evolution:** Open your terminal in the project directory and run:

   ```bash
   java -jar logisim-evolution.jar
   ```

1. **Navigating Sub-circuits:**

   - Go to File -> Open.

   - Navigate to your project folder and select a circuit file like `cpu.circ`.

---

### Testing

To run the built-in sanity tests, use the provided `test_runner.py` script:

```bash
python3 test_runner.py part_b pipelined
```

## Acknowledgements

Sincere thanks to the CS61C course staff at UC Berkeley for providing the starter code and detailed project specifications.
