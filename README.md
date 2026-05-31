# FIFO_verif

# SystemVerilog FIFO Verification Project

A parameterized FIFO design written in SystemVerilog, verified using both a class-based non-UVM testbench and a planned UVM-based verification environment.

This purpose of this project is to build a foundation with UVM verification methodology by building a simple RTL design, and focusing on comprehensive verification strategy. I first focused on creating a non-UVM class based verification enviorment in order to truly understand what is going on under the hood of UVM, and then transitioned into a full UVM enviorment. The FIFO RTL is in [FIFO.sv](https://github.com/ArnavChop11/FIFO_verif/blob/main/FIFO.sv), the non-UVM testbench is in [Class-Based Non-UVM Testbench](https://github.com/ArnavChop11/FIFO_verif/tree/main/Class%20Based%20Non-UVM%20Testbench), and the UVM testbench is in [UVM Testbench](https://github.com/ArnavChop11/FIFO_verif/tree/main/UVM%20Testbench). Below is the verification strategy used in completing this project, credit for verficiation strategy format goes to ChipVerify. Visit them at ChipVerify.com. 


This project will lay the foundation for me to pursue the complex UVM verification of an ABP-Based Aligner project.

---

## Repository Structure

Finish at the end

---

## Verification Strategy

### 1. Introduction

#### Design Description

The design under verification is a parameterized synchronous FIFO written in SystemVerilog. The FIFO stores data in first-in first-out order and supports configurable data width and depth.

The FIFO includes:

- Circular read and write pointers
- Count-based occupancy tracking
- Full and empty status flags
- Read operation
- Write operation
- Simultaneous read/write operation
- Protection against invalid reads and writes

#### Verification Goals

The goal of the verification process is to ensure that the FIFO behaves correctly across normal operation, boundary conditions, and invalid request scenarios.

The verification environment should confirm that:

- Data is read out in the same order it was written
- The FIFO correctly detects full and empty conditions
- Read and write pointers wrap around correctly
- Simultaneous read/write operations behave correctly
- Invalid reads and writes are handled safely
- The design behaves correctly after reset

---

### 2. Verification Environment

#### Simulation Environment

The FIFO will be verified using SystemVerilog simulation. The project will include both a custom SystemVerilog testbench and a UVM-based testbench.

The custom testbench will be developed first to build the verification flow manually. The UVM testbench will later recreate the same structure using standard UVM methodology.

#### Verification Components

The custom verification environment is planned to include:

| Component | Purpose |
|---|---|
| Transaction | Represents one FIFO operation |
| Generator | Creates directed and randomized transactions |
| Driver | Drives FIFO inputs based on transactions |
| Monitor | Observes FIFO inputs and outputs |
| Scoreboard | Compares DUT behavior against expected behavior |
| Reference Model | Models correct FIFO behavior |
| Testbench Top | Connects the DUT, interface, and verification components |

The UVM environment is planned to include:

| Component | Purpose |
|---|---|
| Sequence Item | Represents a FIFO transaction |
| Sequence | Generates stimulus |
| Sequencer | Sends transactions to the driver |
| Driver | Drives DUT signals |
| Monitor | Samples DUT behavior |
| Agent | Encapsulates driver, monitor, and sequencer |
| Scoreboard | Checks correctness |
| Environment | Top-level UVM verification container |
| Test | Defines the specific verification scenario |

#### Simulation Flow

The general simulation flow is:

```text
Reset DUT
Generate FIFO transactions
Drive read/write operations
Monitor DUT behavior
Update reference model
Compare actual output against expected output
Collect coverage
Report pass/fail status

```

---

## Non-UVM Testbench Results

---

## UVM Enviorment Results
