# Asynchronous FIFO Design in Verilog HDL

## 📌 Overview

This project implements a parameterized **Asynchronous FIFO** in Verilog HDL to safely transfer data between two different clock domains. The design uses **Gray-coded pointers** and **two-stage flip-flop synchronizers** to mitigate metastability issues.

The FIFO supports independent read and write clocks and ensures safe Clock Domain Crossing (CDC).

---

## 🏗 Architecture

The FIFO consists of:

- Dual clock domains (Write & Read)
- Binary write and read pointers
- Gray code conversion for safe synchronization
- Two-stage synchronizers
- Full and Empty flag generation logic
- Parameterized memory array

---

## 🔄 Clock Domain Crossing (CDC) Handling

To safely transfer pointer values across clock domains:

- Binary pointers are converted to Gray code.
- Gray-coded pointers are passed through two flip-flop synchronizers.
- This minimizes metastability risk.
- Only one bit changes between consecutive Gray code values.

---

## ⚙️ Parameters

| Parameter     | Description |
|--------------|-------------|
| WIDTH        | Data width (default 32 bits) |
| DEPTH        | FIFO depth |
| ADDR_WIDTH   | Address width (log2(DEPTH)) |

---

## 🧠 Full and Empty Detection

### 🔹 Empty Condition
FIFO is empty when:
Read Pointer (Gray) == Synchronized Write Pointer (Gray)


### 🔹 Full Condition
FIFO is full when:
Write Pointer == Inverted MSBs of synchronized Read Pointer


This method differentiates full from empty using the extra MSB bit.

---

## 🛠 Features

- Parameterized design
- Safe CDC using Gray code
- Two-stage synchronizers
- Full and empty flag logic
- Synthesizable RTL
- Independent reset for read/write domains

---

## 📊 Simulation

Functional simulation verifies:

- Correct write and read operations
- Proper full flag assertion
- Proper empty flag assertion
- Safe operation under asynchronous clocks

---

## 📚 Key Concepts Used

- Clock Domain Crossing (CDC)
- Gray Code Pointer Synchronization
- Metastability Mitigation
- FSM and Sequential Logic
- Parameterized RTL Design

---

## 🎯 Interview Discussion Points

- Why Gray code is used instead of binary?
- Why two flip-flop synchronizers are required?
- How full and empty are distinguished?
- What happens if synchronizers are removed?
- What is metastability?
- Can this FIFO be implemented in ASIC/FPGA?

---

## 🚀 Applications

- Processor to Peripheral communication
- High-speed data buffering
- Multi-clock digital systems
- SoC integration blocks

---

## 👨‍💻 Author

Om Dwivedi  
M.Tech VLSI Design  
NIT Kurukshetra
