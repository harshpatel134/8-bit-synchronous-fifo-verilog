# 8-Bit Synchronous FIFO Using Verilog HDL

## Overview

This project implements and verifies an 8-bit synchronous FIFO using Verilog HDL.

The FIFO supports synchronous write and read operations with full and empty status flag generation.

## Features

- 8-bit data width
- Synchronous FIFO operation
- Write and read control
- Full flag generation
- Empty flag generation
- Reset functionality
- Simultaneous read/write operation

## Verification

The FIFO was verified using ModelSim for:

- Reset operation
- Multiple write operations
- Full condition
- Multiple read operations
- Data integrity during read operations
- Empty condition
- Simultaneous read/write operation

All eight stored data values were successfully read back and verified during simulation.


## Project Files

| File | Description |
|---|---|
| `Fifo_arm.v` | FIFO RTL design |
| `Fifo_arm_tb.v` | Verilog testbench |

## Simulation Result

The testbench successfully verified FIFO functionality, including data integrity, full/empty flags, and simultaneous read/write operation.

Detailed simulation waveforms and documentation will be added in a future update.
