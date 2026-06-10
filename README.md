# FIFO_verif

# SystemVerilog FIFO Verification Project

A parameterized FIFO design written in SystemVerilog, verified using both a class-based non-UVM testbench and a planned UVM-based verification environment.

This purpose of this project is to build a foundation with UVM verification methodology by building a simple RTL design, and focusing on comprehensive verification strategy. I first focused on creating a non-UVM class based verification enviorment in order to truly understand what is going on under the hood of UVM, and then transitioned into a full UVM enviorment. The FIFO RTL is in [FIFO.sv](https://github.com/ArnavChop11/FIFO_verif/blob/main/FIFO.sv), the non-UVM testbench is in [Class-Based Non-UVM Testbench](https://github.com/ArnavChop11/FIFO_verif/tree/main/Class%20Based%20Non-UVM%20Testbench), and the UVM testbench is in [UVM Testbench](https://github.com/ArnavChop11/FIFO_verif/tree/main/UVM%20Testbench). Below is the verification strategy used in completing this project, credit for verficiation strategy format goes to ChipVerify. Visit them at ChipVerify.com. 


This project will lay the foundation for me to pursue the complex UVM verification of an ABP-Based Aligner project.

---

## Repository Structure

```text

Class-Based Non-UVM/
├── top_tb.sv              # Top-level testbench: DUT, interface, clock, reset, test
├── interface.sv           # FIFO interface signals
├── transaction_item.sv    # FIFO transaction object
├── generator.sv           # Creates randomized FIFO transactions
├── driver.sv              # Drives transactions onto the DUT interface
├── monitor.sv             # Samples DUT inputs/outputs
├── scoreboard.sv          # Reference model and result checking
├── environment.sv         # Connects generator, driver, monitor, scoreboard
└── test.sv                # Instantiates and runs the environment

```

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

The verification environment checks that:

- Data is read out in FIFO order: first written, first read
- The FIFO correctly asserts and deasserts `empty`
- The FIFO correctly asserts and deasserts `full`
- Valid writes are stored in the expected order
- Valid reads return the oldest stored value
- Simultaneous read/write operations behave correctly
- Reads while empty are safely ignored
- Writes while full are safely ignored
- The design initializes correctly after reset

Future directed tests will further stress:

- Pointer wraparound after many writes and reads
- Sustained full-condition behavior
- Sustained empty-condition behavior
- Longer randomized regression runs

---

### 2. Verification Environment

#### Simulation Environment

The custom testbench was developed first to manually build the verification flow and better understand how generators, drivers, monitors, scoreboards, mailboxes, events, and virtual interfaces work together.

#### Non-UVM Verification Enviornment Components

The custom non-UVM verification environment includes:

| Component | Purpose |
|---|---|
| Interface | Groups FIFO DUT signals and provides access through a virtual interface |
| Transaction Item | Represents one FIFO operation, including input stimulus and observed DUT outputs |
| Generator | Creates randomized FIFO transactions |
| Driver | Receives transactions from the generator and drives FIFO inputs |
| Monitor | Samples FIFO inputs and outputs after each clocked operation |
| Scoreboard | Checks DUT behavior against expected FIFO behavior |
| Reference Model | Implemented inside the scoreboard using a SystemVerilog queue |
| Environment | Connects the generator, driver, monitor, scoreboard, mailboxes, event, and virtual interface |
| Test | Instantiates and runs the environment |
| Testbench Top | Instantiates the DUT, interface, clock, reset, and test |

Finally, the UVM verification environment was developed to transition the project into a reusable, industry-standard verification flow using sequences, sequencers, drivers, monitors, agents, scoreboards, analysis ports, factory registration, and configuration database-based virtual interface passing.

#### UVM Verification Enviornment Components

The UVM verification environment includes:

| Component | Purpose |
|---|---|
| Interface | Groups FIFO DUT signals and provides access to UVM components through a virtual interface |
| Sequence Item | Represents one FIFO transaction, including randomized input stimulus and observed DUT outputs |
| Sequence | Generates constrained-random FIFO transactions and sends them to the sequencer |
| Sequencer | Controls the flow of sequence items from the sequence to the driver |
| Driver | Receives sequence items from the sequencer and drives FIFO inputs through the virtual interface |
| Monitor | Samples FIFO inputs, outputs, and status flags after each clocked operation |
| Analysis Port | Sends observed transactions from the monitor to the scoreboard |
| Scoreboard | Checks DUT behavior against expected FIFO behavior using a self-checking reference model |
| Reference Model | Implemented inside the scoreboard using a SystemVerilog queue to model FIFO ordering |
| Agent | Encapsulates the sequencer, driver, and monitor for the FIFO interface |
| Environment | Instantiates and connects the agent and scoreboard |
| Test | Builds the environment, applies reset, creates the sequence, and starts randomized testing |
| Testbench Top | Instantiates the DUT, interface, clock generation, UVM configuration database setup, and calls run_test() |

---

## Non-UVM Verification Results


### Terminal Output

```text
SUCCESS "Compile success 0 Errors 10 Warnings  Analysis time: 0[s]."

# KERNEL: T=50 [Generator] Creating item number: 1 / 25
# KERNEL: T=71 [Monitor] data_in=0x911a9c60 wr=0 rd=1 data_out=0x0 full=0 empty=1
# KERNEL: [Scoreboard] Read while empty case
# KERNEL: PASS: [Scoreboard] read correctly ignored because FIFO was empty
# KERNEL: PASS: [Scoreboard] empty flag correct
# KERNEL: PASS: [Scoreboard] full flag correct

...

# KERNEL: T=1030 [Generator] Done generation of 25 items
# KERNEL: T=1031 [Monitor] data_in=0x746750fe wr=0 rd=1 data_out=0xd705bf20 full=0 empty=0
# KERNEL: PASS: [Scoreboard] read output correct
# KERNEL: PASS: [Scoreboard] empty flag correct
# KERNEL: PASS: [Scoreboard] full flag correct

# KERNEL: ALL TEST CASES PASSING!

```

<details> 
<summary>Full simulation log</summary>

```text

SUCCESS "Compile success 0 Errors 10 Warnings  Analysis time: 0[s]."
done
# Aldec, Inc. Riviera-PRO version 2025.04.139.9738 built for Linux64 on May 30, 2025.
# HDL, SystemC, and Assertions simulator, debugger, and design environment.
# (c) 1999-2025 Aldec, Inc. All rights reserved.
# ELBREAD: Elaboration process.
# ELBREAD: Elaboration time 0.0 [s].
# KERNEL: Main thread initiated.
# KERNEL: Kernel process initialization phase.
# ELAB2: Elaboration final pass...
# KERNEL: PLI/VHPI kernel's engine initialization done.
# PLI: Loading library '/usr/share/Riviera-PRO/bin/libsystf.so'
# ELAB2: Create instances ...
# KERNEL: Time resolution set to 1ns.
# ELAB2: Create instances complete.
# SLP: Started
# SLP: Elaboration phase ...
# SLP: Elaboration phase ... done : 0.0 [s]
# SLP: Generation phase ...
# SLP: Generation phase ... done : 0.1 [s]
# SLP: Finished : 0.1 [s]
# SLP: 0 primitives and 4 (80.00%) other processes in SLP
# SLP: 16 (4.20%) signals in SLP and 17 (4.46%) interface signals
# ELAB2: Elaboration final pass complete - time: 0.1 [s].
# KERNEL: SLP loading done - time: 0.0 [s].
# KERNEL: Warning: You are using the Riviera-PRO EDU Edition. The performance of simulation is reduced.
# KERNEL: Warning: Contact Aldec for available upgrade options - sales@aldec.com.
# KERNEL: SLP simulation initialization done - time: 0.0 [s].
# KERNEL: Kernel process initialization done.
# Allocation: Simulator allocated 5501 kB (elbread=459 elab2=4999 kernel=42 sdf=0)
# KERNEL: ASDB file was created in location /home/runner/dataset.asdb
# KERNEL: [Driver] Retrieving transaction from Generator @ time = 50
# KERNEL: T=50 [Generator] Creating item number: 1 / 25
# KERNEL: T=60 [Driver] data_in=0x911a9c60 wr=0 rd=1 data_out=0xxxxxxxxx full=x empty=x
# KERNEL: T=70 [Generator] Creating item number: 2 / 25
# KERNEL: T=71 [Monitor] data_in=0x911a9c60 wr=0 rd=1 data_out=0x0 full=0 empty=1
# KERNEL: [Scoreboard] Read while empty case
# KERNEL: PASS: [Scoreboard] read correctly ignored because FIFO was empty
# KERNEL: PASS: [Scoreboard] empty flag correct
# KERNEL: PASS: [Scoreboard] full flag correct
# KERNEL: T=71 [Scoreboard] data_in=0x911a9c60 wr=0 rd=1 data_out=0x0 full=0 empty=1
# KERNEL: [Driver] Retrieving transaction from Generator @ time = 80
# KERNEL: T=91 [Monitor] data_in=0x911a9c60 wr=0 rd=0 data_out=0x0 full=0 empty=1
# KERNEL: PASS: [Scoreboard] idle cycle
# KERNEL: PASS: [Scoreboard] empty flag correct
# KERNEL: PASS: [Scoreboard] full flag correct
# KERNEL: T=91 [Scoreboard] data_in=0x911a9c60 wr=0 rd=0 data_out=0x0 full=0 empty=1
# KERNEL: T=100 [Driver] data_in=0x29629af4 wr=1 rd=1 data_out=0xxxxxxxxx full=x empty=x
# KERNEL: T=110 [Generator] Creating item number: 3 / 25
# KERNEL: T=111 [Monitor] data_in=0x29629af4 wr=1 rd=1 data_out=0x0 full=0 empty=0
# KERNEL: [Scoreboard] Read+write while empty case
# KERNEL: [Scoreboard] Read ignored, write accepted
# KERNEL: PASS: [Scoreboard] write stored in expected queue
# KERNEL: PASS: [Scoreboard] empty flag correct
# KERNEL: PASS: [Scoreboard] full flag correct
# KERNEL: T=111 [Scoreboard] data_in=0x29629af4 wr=1 rd=1 data_out=0x0 full=0 empty=0
# KERNEL: [Driver] Retrieving transaction from Generator @ time = 120
# KERNEL: T=131 [Monitor] data_in=0x29629af4 wr=0 rd=0 data_out=0x0 full=0 empty=0
# KERNEL: PASS: [Scoreboard] idle cycle
# KERNEL: PASS: [Scoreboard] empty flag correct
# KERNEL: PASS: [Scoreboard] full flag correct
# KERNEL: T=131 [Scoreboard] data_in=0x29629af4 wr=0 rd=0 data_out=0x0 full=0 empty=0
# KERNEL: T=140 [Driver] data_in=0x1a088bec wr=1 rd=1 data_out=0xxxxxxxxx full=x empty=x
# KERNEL: T=150 [Generator] Creating item number: 4 / 25
# KERNEL: T=151 [Monitor] data_in=0x1a088bec wr=1 rd=1 data_out=0x29629af4 full=0 empty=0
# KERNEL: [Scoreboard] Normal read+write case
# KERNEL: PASS: [Scoreboard] read+write output correct
# KERNEL: PASS: [Scoreboard] write stored in expected queue
# KERNEL: PASS: [Scoreboard] empty flag correct
# KERNEL: PASS: [Scoreboard] full flag correct
# KERNEL: T=151 [Scoreboard] data_in=0x1a088bec wr=1 rd=1 data_out=0x29629af4 full=0 empty=0
# KERNEL: [Driver] Retrieving transaction from Generator @ time = 160
# KERNEL: T=171 [Monitor] data_in=0x1a088bec wr=0 rd=0 data_out=0x29629af4 full=0 empty=0
# KERNEL: PASS: [Scoreboard] idle cycle
# KERNEL: PASS: [Scoreboard] empty flag correct
# KERNEL: PASS: [Scoreboard] full flag correct
# KERNEL: T=171 [Scoreboard] data_in=0x1a088bec wr=0 rd=0 data_out=0x29629af4 full=0 empty=0
# KERNEL: T=180 [Driver] data_in=0x60a04c54 wr=0 rd=1 data_out=0xxxxxxxxx full=x empty=x
# KERNEL: T=190 [Generator] Creating item number: 5 / 25
# KERNEL: T=191 [Monitor] data_in=0x60a04c54 wr=0 rd=1 data_out=0x1a088bec full=0 empty=1
# KERNEL: PASS: [Scoreboard] read output correct
# KERNEL: PASS: [Scoreboard] empty flag correct
# KERNEL: PASS: [Scoreboard] full flag correct
# KERNEL: T=191 [Scoreboard] data_in=0x60a04c54 wr=0 rd=1 data_out=0x1a088bec full=0 empty=1
# KERNEL: [Driver] Retrieving transaction from Generator @ time = 200
# KERNEL: T=211 [Monitor] data_in=0x60a04c54 wr=0 rd=0 data_out=0x1a088bec full=0 empty=1
# KERNEL: PASS: [Scoreboard] idle cycle
# KERNEL: PASS: [Scoreboard] empty flag correct
# KERNEL: PASS: [Scoreboard] full flag correct
# KERNEL: T=211 [Scoreboard] data_in=0x60a04c54 wr=0 rd=0 data_out=0x1a088bec full=0 empty=1
# KERNEL: T=220 [Driver] data_in=0xfba352d1 wr=0 rd=1 data_out=0xxxxxxxxx full=x empty=x
# KERNEL: T=230 [Generator] Creating item number: 6 / 25
# KERNEL: T=231 [Monitor] data_in=0xfba352d1 wr=0 rd=1 data_out=0x1a088bec full=0 empty=1
# KERNEL: [Scoreboard] Read while empty case
# KERNEL: PASS: [Scoreboard] read correctly ignored because FIFO was empty
# KERNEL: PASS: [Scoreboard] empty flag correct
# KERNEL: PASS: [Scoreboard] full flag correct
# KERNEL: T=231 [Scoreboard] data_in=0xfba352d1 wr=0 rd=1 data_out=0x1a088bec full=0 empty=1
# KERNEL: [Driver] Retrieving transaction from Generator @ time = 240
# KERNEL: T=251 [Monitor] data_in=0xfba352d1 wr=0 rd=0 data_out=0x1a088bec full=0 empty=1
# KERNEL: PASS: [Scoreboard] idle cycle
# KERNEL: PASS: [Scoreboard] empty flag correct
# KERNEL: PASS: [Scoreboard] full flag correct
# KERNEL: T=251 [Scoreboard] data_in=0xfba352d1 wr=0 rd=0 data_out=0x1a088bec full=0 empty=1
# KERNEL: T=260 [Driver] data_in=0x7f6f351b wr=0 rd=1 data_out=0xxxxxxxxx full=x empty=x
# KERNEL: T=270 [Generator] Creating item number: 7 / 25
# KERNEL: T=271 [Monitor] data_in=0x7f6f351b wr=0 rd=1 data_out=0x1a088bec full=0 empty=1
# KERNEL: [Scoreboard] Read while empty case
# KERNEL: PASS: [Scoreboard] read correctly ignored because FIFO was empty
# KERNEL: PASS: [Scoreboard] empty flag correct
# KERNEL: PASS: [Scoreboard] full flag correct
# KERNEL: T=271 [Scoreboard] data_in=0x7f6f351b wr=0 rd=1 data_out=0x1a088bec full=0 empty=1
# KERNEL: [Driver] Retrieving transaction from Generator @ time = 280
# KERNEL: T=291 [Monitor] data_in=0x7f6f351b wr=0 rd=0 data_out=0x1a088bec full=0 empty=1
# KERNEL: PASS: [Scoreboard] idle cycle
# KERNEL: PASS: [Scoreboard] empty flag correct
# KERNEL: PASS: [Scoreboard] full flag correct
# KERNEL: T=291 [Scoreboard] data_in=0x7f6f351b wr=0 rd=0 data_out=0x1a088bec full=0 empty=1
# KERNEL: T=300 [Driver] data_in=0xca7843e3 wr=0 rd=1 data_out=0xxxxxxxxx full=x empty=x
# KERNEL: T=310 [Generator] Creating item number: 8 / 25
# KERNEL: T=311 [Monitor] data_in=0xca7843e3 wr=0 rd=1 data_out=0x1a088bec full=0 empty=1
# KERNEL: [Scoreboard] Read while empty case
# KERNEL: PASS: [Scoreboard] read correctly ignored because FIFO was empty
# KERNEL: PASS: [Scoreboard] empty flag correct
# KERNEL: PASS: [Scoreboard] full flag correct
# KERNEL: T=311 [Scoreboard] data_in=0xca7843e3 wr=0 rd=1 data_out=0x1a088bec full=0 empty=1
# KERNEL: [Driver] Retrieving transaction from Generator @ time = 320
# KERNEL: T=331 [Monitor] data_in=0xca7843e3 wr=0 rd=0 data_out=0x1a088bec full=0 empty=1
# KERNEL: PASS: [Scoreboard] idle cycle
# KERNEL: PASS: [Scoreboard] empty flag correct
# KERNEL: PASS: [Scoreboard] full flag correct
# KERNEL: T=331 [Scoreboard] data_in=0xca7843e3 wr=0 rd=0 data_out=0x1a088bec full=0 empty=1
# KERNEL: T=340 [Driver] data_in=0xfd43abda wr=0 rd=0 data_out=0xxxxxxxxx full=x empty=x
# KERNEL: T=350 [Generator] Creating item number: 9 / 25
# KERNEL: T=351 [Monitor] data_in=0xfd43abda wr=0 rd=0 data_out=0x1a088bec full=0 empty=1
# KERNEL: PASS: [Scoreboard] idle cycle
# KERNEL: PASS: [Scoreboard] empty flag correct
# KERNEL: PASS: [Scoreboard] full flag correct
# KERNEL: T=351 [Scoreboard] data_in=0xfd43abda wr=0 rd=0 data_out=0x1a088bec full=0 empty=1
# KERNEL: [Driver] Retrieving transaction from Generator @ time = 360
# KERNEL: T=371 [Monitor] data_in=0xfd43abda wr=0 rd=0 data_out=0x1a088bec full=0 empty=1
# KERNEL: PASS: [Scoreboard] idle cycle
# KERNEL: PASS: [Scoreboard] empty flag correct
# KERNEL: PASS: [Scoreboard] full flag correct
# KERNEL: T=371 [Scoreboard] data_in=0xfd43abda wr=0 rd=0 data_out=0x1a088bec full=0 empty=1
# KERNEL: T=380 [Driver] data_in=0xb2758546 wr=0 rd=0 data_out=0xxxxxxxxx full=x empty=x
# KERNEL: T=390 [Generator] Creating item number: 10 / 25
# KERNEL: T=391 [Monitor] data_in=0xb2758546 wr=0 rd=0 data_out=0x1a088bec full=0 empty=1
# KERNEL: PASS: [Scoreboard] idle cycle
# KERNEL: PASS: [Scoreboard] empty flag correct
# KERNEL: PASS: [Scoreboard] full flag correct
# KERNEL: T=391 [Scoreboard] data_in=0xb2758546 wr=0 rd=0 data_out=0x1a088bec full=0 empty=1
# KERNEL: [Driver] Retrieving transaction from Generator @ time = 400
# KERNEL: T=411 [Monitor] data_in=0xb2758546 wr=0 rd=0 data_out=0x1a088bec full=0 empty=1
# KERNEL: PASS: [Scoreboard] idle cycle
# KERNEL: PASS: [Scoreboard] empty flag correct
# KERNEL: PASS: [Scoreboard] full flag correct
# KERNEL: T=411 [Scoreboard] data_in=0xb2758546 wr=0 rd=0 data_out=0x1a088bec full=0 empty=1
# KERNEL: T=420 [Driver] data_in=0xa7b7bbb1 wr=0 rd=0 data_out=0xxxxxxxxx full=x empty=x
# KERNEL: T=430 [Generator] Creating item number: 11 / 25
# KERNEL: T=431 [Monitor] data_in=0xa7b7bbb1 wr=0 rd=0 data_out=0x1a088bec full=0 empty=1
# KERNEL: PASS: [Scoreboard] idle cycle
# KERNEL: PASS: [Scoreboard] empty flag correct
# KERNEL: PASS: [Scoreboard] full flag correct
# KERNEL: T=431 [Scoreboard] data_in=0xa7b7bbb1 wr=0 rd=0 data_out=0x1a088bec full=0 empty=1
# KERNEL: [Driver] Retrieving transaction from Generator @ time = 440
# KERNEL: T=451 [Monitor] data_in=0xa7b7bbb1 wr=0 rd=0 data_out=0x1a088bec full=0 empty=1
# KERNEL: PASS: [Scoreboard] idle cycle
# KERNEL: PASS: [Scoreboard] empty flag correct
# KERNEL: PASS: [Scoreboard] full flag correct
# KERNEL: T=451 [Scoreboard] data_in=0xa7b7bbb1 wr=0 rd=0 data_out=0x1a088bec full=0 empty=1
# KERNEL: T=460 [Driver] data_in=0x693db61c wr=0 rd=0 data_out=0xxxxxxxxx full=x empty=x
# KERNEL: T=470 [Generator] Creating item number: 12 / 25
# KERNEL: T=471 [Monitor] data_in=0x693db61c wr=0 rd=0 data_out=0x1a088bec full=0 empty=1
# KERNEL: PASS: [Scoreboard] idle cycle
# KERNEL: PASS: [Scoreboard] empty flag correct
# KERNEL: PASS: [Scoreboard] full flag correct
# KERNEL: T=471 [Scoreboard] data_in=0x693db61c wr=0 rd=0 data_out=0x1a088bec full=0 empty=1
# KERNEL: [Driver] Retrieving transaction from Generator @ time = 480
# KERNEL: T=491 [Monitor] data_in=0x693db61c wr=0 rd=0 data_out=0x1a088bec full=0 empty=1
# KERNEL: PASS: [Scoreboard] idle cycle
# KERNEL: PASS: [Scoreboard] empty flag correct
# KERNEL: PASS: [Scoreboard] full flag correct
# KERNEL: T=491 [Scoreboard] data_in=0x693db61c wr=0 rd=0 data_out=0x1a088bec full=0 empty=1
# KERNEL: T=500 [Driver] data_in=0xfcd48596 wr=1 rd=0 data_out=0xxxxxxxxx full=x empty=x
# KERNEL: T=510 [Generator] Creating item number: 13 / 25
# KERNEL: T=511 [Monitor] data_in=0xfcd48596 wr=1 rd=0 data_out=0x1a088bec full=0 empty=0
# KERNEL: PASS: [Scoreboard] write stored in expected queue
# KERNEL: PASS: [Scoreboard] empty flag correct
# KERNEL: PASS: [Scoreboard] full flag correct
# KERNEL: T=511 [Scoreboard] data_in=0xfcd48596 wr=1 rd=0 data_out=0x1a088bec full=0 empty=0
# KERNEL: [Driver] Retrieving transaction from Generator @ time = 520
# KERNEL: T=531 [Monitor] data_in=0xfcd48596 wr=0 rd=0 data_out=0x1a088bec full=0 empty=0
# KERNEL: PASS: [Scoreboard] idle cycle
# KERNEL: PASS: [Scoreboard] empty flag correct
# KERNEL: PASS: [Scoreboard] full flag correct
# KERNEL: T=531 [Scoreboard] data_in=0xfcd48596 wr=0 rd=0 data_out=0x1a088bec full=0 empty=0
# KERNEL: T=540 [Driver] data_in=0xf21aa251 wr=1 rd=0 data_out=0xxxxxxxxx full=x empty=x
# KERNEL: T=550 [Generator] Creating item number: 14 / 25
# KERNEL: T=551 [Monitor] data_in=0xf21aa251 wr=1 rd=0 data_out=0x1a088bec full=0 empty=0
# KERNEL: PASS: [Scoreboard] write stored in expected queue
# KERNEL: PASS: [Scoreboard] empty flag correct
# KERNEL: PASS: [Scoreboard] full flag correct
# KERNEL: T=551 [Scoreboard] data_in=0xf21aa251 wr=1 rd=0 data_out=0x1a088bec full=0 empty=0
# KERNEL: [Driver] Retrieving transaction from Generator @ time = 560
# KERNEL: T=571 [Monitor] data_in=0xf21aa251 wr=0 rd=0 data_out=0x1a088bec full=0 empty=0
# KERNEL: PASS: [Scoreboard] idle cycle
# KERNEL: PASS: [Scoreboard] empty flag correct
# KERNEL: PASS: [Scoreboard] full flag correct
# KERNEL: T=571 [Scoreboard] data_in=0xf21aa251 wr=0 rd=0 data_out=0x1a088bec full=0 empty=0
# KERNEL: T=580 [Driver] data_in=0x2f4d86a1 wr=0 rd=0 data_out=0xxxxxxxxx full=x empty=x
# KERNEL: T=590 [Generator] Creating item number: 15 / 25
# KERNEL: T=591 [Monitor] data_in=0x2f4d86a1 wr=0 rd=0 data_out=0x1a088bec full=0 empty=0
# KERNEL: PASS: [Scoreboard] idle cycle
# KERNEL: PASS: [Scoreboard] empty flag correct
# KERNEL: PASS: [Scoreboard] full flag correct
# KERNEL: T=591 [Scoreboard] data_in=0x2f4d86a1 wr=0 rd=0 data_out=0x1a088bec full=0 empty=0
# KERNEL: [Driver] Retrieving transaction from Generator @ time = 600
# KERNEL: T=611 [Monitor] data_in=0x2f4d86a1 wr=0 rd=0 data_out=0x1a088bec full=0 empty=0
# KERNEL: PASS: [Scoreboard] idle cycle
# KERNEL: PASS: [Scoreboard] empty flag correct
# KERNEL: PASS: [Scoreboard] full flag correct
# KERNEL: T=611 [Scoreboard] data_in=0x2f4d86a1 wr=0 rd=0 data_out=0x1a088bec full=0 empty=0
# KERNEL: T=620 [Driver] data_in=0xa9322db4 wr=1 rd=0 data_out=0xxxxxxxxx full=x empty=x
# KERNEL: T=630 [Generator] Creating item number: 16 / 25
# KERNEL: T=631 [Monitor] data_in=0xa9322db4 wr=1 rd=0 data_out=0x1a088bec full=0 empty=0
# KERNEL: PASS: [Scoreboard] write stored in expected queue
# KERNEL: PASS: [Scoreboard] empty flag correct
# KERNEL: PASS: [Scoreboard] full flag correct
# KERNEL: T=631 [Scoreboard] data_in=0xa9322db4 wr=1 rd=0 data_out=0x1a088bec full=0 empty=0
# KERNEL: [Driver] Retrieving transaction from Generator @ time = 640
# KERNEL: T=651 [Monitor] data_in=0xa9322db4 wr=0 rd=0 data_out=0x1a088bec full=0 empty=0
# KERNEL: PASS: [Scoreboard] idle cycle
# KERNEL: PASS: [Scoreboard] empty flag correct
# KERNEL: PASS: [Scoreboard] full flag correct
# KERNEL: T=651 [Scoreboard] data_in=0xa9322db4 wr=0 rd=0 data_out=0x1a088bec full=0 empty=0
# KERNEL: T=660 [Driver] data_in=0xd705bf20 wr=1 rd=0 data_out=0xxxxxxxxx full=x empty=x
# KERNEL: T=670 [Generator] Creating item number: 17 / 25
# KERNEL: T=671 [Monitor] data_in=0xd705bf20 wr=1 rd=0 data_out=0x1a088bec full=0 empty=0
# KERNEL: PASS: [Scoreboard] write stored in expected queue
# KERNEL: PASS: [Scoreboard] empty flag correct
# KERNEL: PASS: [Scoreboard] full flag correct
# KERNEL: T=671 [Scoreboard] data_in=0xd705bf20 wr=1 rd=0 data_out=0x1a088bec full=0 empty=0
# KERNEL: [Driver] Retrieving transaction from Generator @ time = 680
# KERNEL: T=691 [Monitor] data_in=0xd705bf20 wr=0 rd=0 data_out=0x1a088bec full=0 empty=0
# KERNEL: PASS: [Scoreboard] idle cycle
# KERNEL: PASS: [Scoreboard] empty flag correct
# KERNEL: PASS: [Scoreboard] full flag correct
# KERNEL: T=691 [Scoreboard] data_in=0xd705bf20 wr=0 rd=0 data_out=0x1a088bec full=0 empty=0
# KERNEL: T=700 [Driver] data_in=0xc72eef39 wr=0 rd=0 data_out=0xxxxxxxxx full=x empty=x
# KERNEL: T=710 [Generator] Creating item number: 18 / 25
# KERNEL: T=711 [Monitor] data_in=0xc72eef39 wr=0 rd=0 data_out=0x1a088bec full=0 empty=0
# KERNEL: PASS: [Scoreboard] idle cycle
# KERNEL: PASS: [Scoreboard] empty flag correct
# KERNEL: PASS: [Scoreboard] full flag correct
# KERNEL: T=711 [Scoreboard] data_in=0xc72eef39 wr=0 rd=0 data_out=0x1a088bec full=0 empty=0
# KERNEL: [Driver] Retrieving transaction from Generator @ time = 720
# KERNEL: T=731 [Monitor] data_in=0xc72eef39 wr=0 rd=0 data_out=0x1a088bec full=0 empty=0
# KERNEL: PASS: [Scoreboard] idle cycle
# KERNEL: PASS: [Scoreboard] empty flag correct
# KERNEL: PASS: [Scoreboard] full flag correct
# KERNEL: T=731 [Scoreboard] data_in=0xc72eef39 wr=0 rd=0 data_out=0x1a088bec full=0 empty=0
# KERNEL: T=740 [Driver] data_in=0x54d3e71f wr=1 rd=0 data_out=0xxxxxxxxx full=x empty=x
# KERNEL: T=750 [Generator] Creating item number: 19 / 25
# KERNEL: T=751 [Monitor] data_in=0x54d3e71f wr=1 rd=0 data_out=0x1a088bec full=0 empty=0
# KERNEL: PASS: [Scoreboard] write stored in expected queue
# KERNEL: PASS: [Scoreboard] empty flag correct
# KERNEL: PASS: [Scoreboard] full flag correct
# KERNEL: T=751 [Scoreboard] data_in=0x54d3e71f wr=1 rd=0 data_out=0x1a088bec full=0 empty=0
# KERNEL: [Driver] Retrieving transaction from Generator @ time = 760
# KERNEL: T=771 [Monitor] data_in=0x54d3e71f wr=0 rd=0 data_out=0x1a088bec full=0 empty=0
# KERNEL: PASS: [Scoreboard] idle cycle
# KERNEL: PASS: [Scoreboard] empty flag correct
# KERNEL: PASS: [Scoreboard] full flag correct
# KERNEL: T=771 [Scoreboard] data_in=0x54d3e71f wr=0 rd=0 data_out=0x1a088bec full=0 empty=0
# KERNEL: T=780 [Driver] data_in=0xe3506ee1 wr=1 rd=1 data_out=0xxxxxxxxx full=x empty=x
# KERNEL: T=790 [Generator] Creating item number: 20 / 25
# KERNEL: T=791 [Monitor] data_in=0xe3506ee1 wr=1 rd=1 data_out=0xfcd48596 full=0 empty=0
# KERNEL: [Scoreboard] Normal read+write case
# KERNEL: PASS: [Scoreboard] read+write output correct
# KERNEL: PASS: [Scoreboard] write stored in expected queue
# KERNEL: PASS: [Scoreboard] empty flag correct
# KERNEL: PASS: [Scoreboard] full flag correct
# KERNEL: T=791 [Scoreboard] data_in=0xe3506ee1 wr=1 rd=1 data_out=0xfcd48596 full=0 empty=0
# KERNEL: [Driver] Retrieving transaction from Generator @ time = 800
# KERNEL: T=811 [Monitor] data_in=0xe3506ee1 wr=0 rd=0 data_out=0xfcd48596 full=0 empty=0
# KERNEL: PASS: [Scoreboard] idle cycle
# KERNEL: PASS: [Scoreboard] empty flag correct
# KERNEL: PASS: [Scoreboard] full flag correct
# KERNEL: T=811 [Scoreboard] data_in=0xe3506ee1 wr=0 rd=0 data_out=0xfcd48596 full=0 empty=0
# KERNEL: T=820 [Driver] data_in=0x64f15667 wr=1 rd=0 data_out=0xxxxxxxxx full=x empty=x
# KERNEL: T=830 [Generator] Creating item number: 21 / 25
# KERNEL: T=831 [Monitor] data_in=0x64f15667 wr=1 rd=0 data_out=0xfcd48596 full=0 empty=0
# KERNEL: PASS: [Scoreboard] write stored in expected queue
# KERNEL: PASS: [Scoreboard] empty flag correct
# KERNEL: PASS: [Scoreboard] full flag correct
# KERNEL: T=831 [Scoreboard] data_in=0x64f15667 wr=1 rd=0 data_out=0xfcd48596 full=0 empty=0
# KERNEL: [Driver] Retrieving transaction from Generator @ time = 840
# KERNEL: T=851 [Monitor] data_in=0x64f15667 wr=0 rd=0 data_out=0xfcd48596 full=0 empty=0
# KERNEL: PASS: [Scoreboard] idle cycle
# KERNEL: PASS: [Scoreboard] empty flag correct
# KERNEL: PASS: [Scoreboard] full flag correct
# KERNEL: T=851 [Scoreboard] data_in=0x64f15667 wr=0 rd=0 data_out=0xfcd48596 full=0 empty=0
# KERNEL: T=860 [Driver] data_in=0x242ec870 wr=0 rd=0 data_out=0xxxxxxxxx full=x empty=x
# KERNEL: T=870 [Generator] Creating item number: 22 / 25
# KERNEL: T=871 [Monitor] data_in=0x242ec870 wr=0 rd=0 data_out=0xfcd48596 full=0 empty=0
# KERNEL: PASS: [Scoreboard] idle cycle
# KERNEL: PASS: [Scoreboard] empty flag correct
# KERNEL: PASS: [Scoreboard] full flag correct
# KERNEL: T=871 [Scoreboard] data_in=0x242ec870 wr=0 rd=0 data_out=0xfcd48596 full=0 empty=0
# KERNEL: [Driver] Retrieving transaction from Generator @ time = 880
# KERNEL: T=891 [Monitor] data_in=0x242ec870 wr=0 rd=0 data_out=0xfcd48596 full=0 empty=0
# KERNEL: PASS: [Scoreboard] idle cycle
# KERNEL: PASS: [Scoreboard] empty flag correct
# KERNEL: PASS: [Scoreboard] full flag correct
# KERNEL: T=891 [Scoreboard] data_in=0x242ec870 wr=0 rd=0 data_out=0xfcd48596 full=0 empty=0
# KERNEL: T=900 [Driver] data_in=0x20d33864 wr=0 rd=1 data_out=0xxxxxxxxx full=x empty=x
# KERNEL: T=910 [Generator] Creating item number: 23 / 25
# KERNEL: T=911 [Monitor] data_in=0x20d33864 wr=0 rd=1 data_out=0xf21aa251 full=0 empty=0
# KERNEL: PASS: [Scoreboard] read output correct
# KERNEL: PASS: [Scoreboard] empty flag correct
# KERNEL: PASS: [Scoreboard] full flag correct
# KERNEL: T=911 [Scoreboard] data_in=0x20d33864 wr=0 rd=1 data_out=0xf21aa251 full=0 empty=0
# KERNEL: [Driver] Retrieving transaction from Generator @ time = 920
# KERNEL: T=931 [Monitor] data_in=0x20d33864 wr=0 rd=0 data_out=0xf21aa251 full=0 empty=0
# KERNEL: PASS: [Scoreboard] idle cycle
# KERNEL: PASS: [Scoreboard] empty flag correct
# KERNEL: PASS: [Scoreboard] full flag correct
# KERNEL: T=931 [Scoreboard] data_in=0x20d33864 wr=0 rd=0 data_out=0xf21aa251 full=0 empty=0
# KERNEL: T=940 [Driver] data_in=0x9941dae8 wr=1 rd=1 data_out=0xxxxxxxxx full=x empty=x
# KERNEL: T=950 [Generator] Creating item number: 24 / 25
# KERNEL: T=951 [Monitor] data_in=0x9941dae8 wr=1 rd=1 data_out=0xa9322db4 full=0 empty=0
# KERNEL: [Scoreboard] Normal read+write case
# KERNEL: PASS: [Scoreboard] read+write output correct
# KERNEL: PASS: [Scoreboard] write stored in expected queue
# KERNEL: PASS: [Scoreboard] empty flag correct
# KERNEL: PASS: [Scoreboard] full flag correct
# KERNEL: T=951 [Scoreboard] data_in=0x9941dae8 wr=1 rd=1 data_out=0xa9322db4 full=0 empty=0
# KERNEL: [Driver] Retrieving transaction from Generator @ time = 960
# KERNEL: T=971 [Monitor] data_in=0x9941dae8 wr=0 rd=0 data_out=0xa9322db4 full=0 empty=0
# KERNEL: PASS: [Scoreboard] idle cycle
# KERNEL: PASS: [Scoreboard] empty flag correct
# KERNEL: PASS: [Scoreboard] full flag correct
# KERNEL: T=971 [Scoreboard] data_in=0x9941dae8 wr=0 rd=0 data_out=0xa9322db4 full=0 empty=0
# KERNEL: T=980 [Driver] data_in=0x1901ae62 wr=1 rd=0 data_out=0xxxxxxxxx full=x empty=x
# KERNEL: T=990 [Generator] Creating item number: 25 / 25
# KERNEL: T=991 [Monitor] data_in=0x1901ae62 wr=1 rd=0 data_out=0xa9322db4 full=0 empty=0
# KERNEL: PASS: [Scoreboard] write stored in expected queue
# KERNEL: PASS: [Scoreboard] empty flag correct
# KERNEL: PASS: [Scoreboard] full flag correct
# KERNEL: T=991 [Scoreboard] data_in=0x1901ae62 wr=1 rd=0 data_out=0xa9322db4 full=0 empty=0
# KERNEL: [Driver] Retrieving transaction from Generator @ time = 1000
# KERNEL: T=1011 [Monitor] data_in=0x1901ae62 wr=0 rd=0 data_out=0xa9322db4 full=0 empty=0
# KERNEL: PASS: [Scoreboard] idle cycle
# KERNEL: PASS: [Scoreboard] empty flag correct
# KERNEL: PASS: [Scoreboard] full flag correct
# KERNEL: T=1011 [Scoreboard] data_in=0x1901ae62 wr=0 rd=0 data_out=0xa9322db4 full=0 empty=0
# KERNEL: T=1020 [Driver] data_in=0x746750fe wr=0 rd=1 data_out=0xxxxxxxxx full=x empty=x
# KERNEL: T=1030 [Generator] Done generation of 25 items
# KERNEL: T=1031 [Monitor] data_in=0x746750fe wr=0 rd=1 data_out=0xd705bf20 full=0 empty=0
# KERNEL: PASS: [Scoreboard] read output correct
# KERNEL: PASS: [Scoreboard] empty flag correct
# KERNEL: PASS: [Scoreboard] full flag correct
# KERNEL: T=1031 [Scoreboard] data_in=0x746750fe wr=0 rd=1 data_out=0xd705bf20 full=0 empty=0
# KERNEL: [Driver] Retrieving transaction from Generator @ time = 1040
# KERNEL: T=1051 [Monitor] data_in=0x746750fe wr=0 rd=0 data_out=0xd705bf20 full=0 empty=0
# KERNEL: PASS: [Scoreboard] idle cycle
# KERNEL: PASS: [Scoreboard] empty flag correct
# KERNEL: PASS: [Scoreboard] full flag correct
# KERNEL: T=1051 [Scoreboard] data_in=0x746750fe wr=0 rd=0 data_out=0xd705bf20 full=0 empty=0
# KERNEL: ALL TEST CASES PASSING!
```
</details>

---

## UVM Enviorment Results

### Terminal Output

```text

# KERNEL: UVM_INFO /home/runner/gen.sv(34) @ 145: uvm_test_top.e0.a0.s0@@seq [SEQ] Generate new FIFO item:

# KERNEL: ---------------------------------------------------------------------------------
# KERNEL: Name                           Type               Size  Value                    
# KERNEL: ---------------------------------------------------------------------------------
# KERNEL: m_item                         uvm_sequence_item  -     @694                     
# KERNEL:   data_in                      integral           32    'hfb29e375               
# KERNEL:   write_enable                 integral           1     'h1                      
# KERNEL:   read_enable                  integral           1     'h1                      
# KERNEL:   data_out                     integral           32    'hxxxxxxxx               
# KERNEL:   full                         integral           1     'hX                      
# KERNEL:   empty                        integral           1     'hX                      
# KERNEL:   begin_time                   time               64    145                      
# KERNEL:   depth                        int                32    'd2                      
# KERNEL:   parent sequence (name)       string             3     seq                      
# KERNEL:   parent sequence (full name)  string             25    uvm_test_top.e0.a0.s0.seq
# KERNEL:   sequencer                    string             21    uvm_test_top.e0.a0.s0    
# KERNEL: ---------------------------------------------------------------------------------
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 150: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] idle cycle
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 150: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] empty flag correct
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 150: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] full flag correct
# KERNEL: UVM_INFO /home/runner/gen.sv(34) @ 150: uvm_test_top.e0.a0.s0@@seq [SEQ] Generate new FIFO item:
# KERNEL: ---------------------------------------------------------------------------------
# KERNEL: Name                           Type               Size  Value                    
# KERNEL: ---------------------------------------------------------------------------------
# KERNEL: m_item                         uvm_sequence_item  -     @704                     
# KERNEL:   data_in                      integral           32    'hda16c9e2               
# KERNEL:   write_enable                 integral           1     'h0                      
# KERNEL:   read_enable                  integral           1     'h0                      
# KERNEL:   data_out                     integral           32    'hxxxxxxxx               
# KERNEL:   full                         integral           1     'hX                      
# KERNEL:   empty                        integral           1     'hX                      
# KERNEL:   begin_time                   time               64    150                      
# KERNEL:   depth                        int                32    'd2                      
# KERNEL:   parent sequence (name)       string             3     seq                      
# KERNEL:   parent sequence (full name)  string             25    uvm_test_top.e0.a0.s0.seq
# KERNEL:   sequencer                    string             21    uvm_test_top.e0.a0.s0    
# KERNEL: ---------------------------------------------------------------------------------
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(54) @ 160: uvm_test_top.e0.sb0 [Scoreboard] Read+write while empty case
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(55) @ 160: uvm_test_top.e0.sb0 [Scoreboard] Read ignored, write accepted
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 160: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] write stored in expected queue
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 160: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] empty flag correct
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 160: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] full flag correct

...

# KERNEL: UVM_INFO /home/runner/scoreboard.sv(141) @ 620: uvm_test_top.e0.sb0 [Scoreboard] ALL TEST CASES PASSING!
# KERNEL: UVM_INFO ./uvm-1.2/src/base/uvm_report_server.svh(869) @ 620: reporter [UVM/REPORT/SERVER] 
# KERNEL: --- UVM Report Summary ---
# KERNEL: 
# KERNEL: ** Report counts by severity
# KERNEL: UVM_INFO :  270
# KERNEL: UVM_WARNING :    0
# KERNEL: UVM_ERROR :    0
# KERNEL: UVM_FATAL :    0
# KERNEL: ** Report counts by id
# KERNEL: [RNTST]     1
# KERNEL: [SCB_PASS]   203
# KERNEL: [SEQ]    29
# KERNEL: [Scoreboard]    35
# KERNEL: [TEST_DONE]     1
# KERNEL: [UVM/RELNOTES]     1
# KERNEL: 

```

<details> 
<summary>Full simulation log</summary>

```text

[2026-06-09 21:00:42 UTC] vlib work && vlog '-timescale' '1ns/1ns' +incdir+$RIVIERA_HOME/vlib/uvm-1.2/src -l uvm_1_2 -err VCP2947 W9 -err VCP2974 W9 -err VCP3003 W9 -err VCP5417 W9 -err VCP6120 W9 -err VCP7862 W9 -err VCP2129 W9 design.sv testbench.sv  && vsim -c -do "vsim +access+r; run -all; exit"  
VSIMSA: Configuration file changed: `/home/runner/library.cfg'
ALIB: Library "work" attached.
work = ./work/work.lib
MESSAGE_SP VCP2124 "Package uvm_pkg found in library uvm_1_2."
MESSAGE "Unit top modules: tb_top."
SUCCESS "Compile success 0 Errors 0 Warnings  Analysis time: 6[s]."
done
# Aldec, Inc. Riviera-PRO version 2025.04.139.9738 built for Linux64 on May 30, 2025.
# HDL, SystemC, and Assertions simulator, debugger, and design environment.
# (c) 1999-2025 Aldec, Inc. All rights reserved.
# ELBREAD: Elaboration process.
# ELBREAD: Warning: ELBREAD_0049 The "uvm_pkg" design unit does not have a time unit/precision defined but other design units do.
# ELBREAD: Elaboration time 0.7 [s].
# KERNEL: Main thread initiated.
# KERNEL: Kernel process initialization phase.
# ELAB2: Elaboration final pass...
# KERNEL: PLI/VHPI kernel's engine initialization done.
# PLI: Loading library '/usr/share/Riviera-PRO/bin/libsystf.so'
# ELAB2: Create instances ...
# KERNEL: Info: Loading library:  /usr/share/Riviera-PRO/bin/uvm_1_2_dpi
# KERNEL: Time resolution set to 1ns.
# ELAB2: Create instances complete.
# SLP: Started
# SLP: Elaboration phase ...
# SLP: Elaboration phase ... done : 0.0 [s]
# SLP: Generation phase ...
# SLP: Generation phase ... done : 0.1 [s]
# SLP: Finished : 0.1 [s]
# SLP: 0 primitives and 3 (37.50%) other processes in SLP
# SLP: 32 (0.11%) signals in SLP and 15 (0.05%) interface signals
# ELAB2: Elaboration final pass complete - time: 2.5 [s].
# KERNEL: SLP loading done - time: 0.0 [s].
# KERNEL: Warning: You are using the Riviera-PRO EDU Edition. The performance of simulation is reduced.
# KERNEL: Warning: Contact Aldec for available upgrade options - sales@aldec.com.
# KERNEL: SLP simulation initialization done - time: 0.0 [s].
# KERNEL: Kernel process initialization done.
# Allocation: Simulator allocated 29444 kB (elbread=2090 elab2=22604 kernel=4749 sdf=0)
# KERNEL: UVM_INFO ./uvm-1.2/src/base/uvm_root.svh(392) @ 0: reporter [UVM/RELNOTES] 
# KERNEL: ----------------------------------------------------------------
# KERNEL: UVM-1.2
# KERNEL: (C) 2007-2014 Mentor Graphics Corporation
# KERNEL: (C) 2007-2014 Cadence Design Systems, Inc.
# KERNEL: (C) 2006-2014 Synopsys, Inc.
# KERNEL: (C) 2011-2013 Cypress Semiconductor Corp.
# KERNEL: (C) 2013-2014 NVIDIA Corporation
# KERNEL: ----------------------------------------------------------------
# KERNEL: 
# KERNEL:   ***********       IMPORTANT RELEASE NOTES         ************
# KERNEL: 
# KERNEL:   You are using a version of the UVM library that has been compiled
# KERNEL:   with `UVM_NO_DEPRECATED undefined.
# KERNEL:   See http://www.eda.org/svdb/view.php?id=3313 for more details.
# KERNEL: 
# KERNEL:   You are using a version of the UVM library that has been compiled
# KERNEL:   with `UVM_OBJECT_DO_NOT_NEED_CONSTRUCTOR undefined.
# KERNEL:   See http://www.eda.org/svdb/view.php?id=3770 for more details.
# KERNEL: 
# KERNEL:       (Specify +UVM_NO_RELNOTES to turn off this notice)
# KERNEL: 
# KERNEL: ASDB file was created in location /home/runner/dataset.asdb
# KERNEL: UVM_INFO @ 0: reporter [RNTST] Running test test...
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 60: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] idle cycle
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 60: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] empty flag correct
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 60: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] full flag correct
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 70: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] idle cycle
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 70: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] empty flag correct
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 70: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] full flag correct
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 80: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] idle cycle
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 80: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] empty flag correct
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 80: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] full flag correct
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 90: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] idle cycle
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 90: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] empty flag correct
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 90: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] full flag correct
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 100: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] idle cycle
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 100: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] empty flag correct
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 100: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] full flag correct
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 110: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] idle cycle
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 110: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] empty flag correct
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 110: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] full flag correct
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 120: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] idle cycle
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 120: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] empty flag correct
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 120: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] full flag correct
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 130: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] idle cycle
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 130: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] empty flag correct
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 130: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] full flag correct
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 140: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] idle cycle
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 140: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] empty flag correct
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 140: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] full flag correct
# KERNEL: UVM_INFO /home/runner/gen.sv(34) @ 145: uvm_test_top.e0.a0.s0@@seq [SEQ] Generate new FIFO item:
# KERNEL: ---------------------------------------------------------------------------------
# KERNEL: Name                           Type               Size  Value                    
# KERNEL: ---------------------------------------------------------------------------------
# KERNEL: m_item                         uvm_sequence_item  -     @694                     
# KERNEL:   data_in                      integral           32    'hfb29e375               
# KERNEL:   write_enable                 integral           1     'h1                      
# KERNEL:   read_enable                  integral           1     'h1                      
# KERNEL:   data_out                     integral           32    'hxxxxxxxx               
# KERNEL:   full                         integral           1     'hX                      
# KERNEL:   empty                        integral           1     'hX                      
# KERNEL:   begin_time                   time               64    145                      
# KERNEL:   depth                        int                32    'd2                      
# KERNEL:   parent sequence (name)       string             3     seq                      
# KERNEL:   parent sequence (full name)  string             25    uvm_test_top.e0.a0.s0.seq
# KERNEL:   sequencer                    string             21    uvm_test_top.e0.a0.s0    
# KERNEL: ---------------------------------------------------------------------------------
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 150: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] idle cycle
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 150: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] empty flag correct
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 150: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] full flag correct
# KERNEL: UVM_INFO /home/runner/gen.sv(34) @ 150: uvm_test_top.e0.a0.s0@@seq [SEQ] Generate new FIFO item:
# KERNEL: ---------------------------------------------------------------------------------
# KERNEL: Name                           Type               Size  Value                    
# KERNEL: ---------------------------------------------------------------------------------
# KERNEL: m_item                         uvm_sequence_item  -     @704                     
# KERNEL:   data_in                      integral           32    'hda16c9e2               
# KERNEL:   write_enable                 integral           1     'h0                      
# KERNEL:   read_enable                  integral           1     'h0                      
# KERNEL:   data_out                     integral           32    'hxxxxxxxx               
# KERNEL:   full                         integral           1     'hX                      
# KERNEL:   empty                        integral           1     'hX                      
# KERNEL:   begin_time                   time               64    150                      
# KERNEL:   depth                        int                32    'd2                      
# KERNEL:   parent sequence (name)       string             3     seq                      
# KERNEL:   parent sequence (full name)  string             25    uvm_test_top.e0.a0.s0.seq
# KERNEL:   sequencer                    string             21    uvm_test_top.e0.a0.s0    
# KERNEL: ---------------------------------------------------------------------------------
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(54) @ 160: uvm_test_top.e0.sb0 [Scoreboard] Read+write while empty case
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(55) @ 160: uvm_test_top.e0.sb0 [Scoreboard] Read ignored, write accepted
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 160: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] write stored in expected queue
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 160: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] empty flag correct
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 160: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] full flag correct
# KERNEL: UVM_INFO /home/runner/gen.sv(34) @ 160: uvm_test_top.e0.a0.s0@@seq [SEQ] Generate new FIFO item:
# KERNEL: ---------------------------------------------------------------------------------
# KERNEL: Name                           Type               Size  Value                    
# KERNEL: ---------------------------------------------------------------------------------
# KERNEL: m_item                         uvm_sequence_item  -     @718                     
# KERNEL:   data_in                      integral           32    'h97f096bc               
# KERNEL:   write_enable                 integral           1     'h0                      
# KERNEL:   read_enable                  integral           1     'h0                      
# KERNEL:   data_out                     integral           32    'hxxxxxxxx               
# KERNEL:   full                         integral           1     'hX                      
# KERNEL:   empty                        integral           1     'hX                      
# KERNEL:   begin_time                   time               64    160                      
# KERNEL:   depth                        int                32    'd2                      
# KERNEL:   parent sequence (name)       string             3     seq                      
# KERNEL:   parent sequence (full name)  string             25    uvm_test_top.e0.a0.s0.seq
# KERNEL:   sequencer                    string             21    uvm_test_top.e0.a0.s0    
# KERNEL: ---------------------------------------------------------------------------------
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 170: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] idle cycle
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 170: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] empty flag correct
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 170: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] full flag correct
# KERNEL: UVM_INFO /home/runner/gen.sv(34) @ 170: uvm_test_top.e0.a0.s0@@seq [SEQ] Generate new FIFO item:
# KERNEL: ---------------------------------------------------------------------------------
# KERNEL: Name                           Type               Size  Value                    
# KERNEL: ---------------------------------------------------------------------------------
# KERNEL: m_item                         uvm_sequence_item  -     @728                     
# KERNEL:   data_in                      integral           32    'h34b74a03               
# KERNEL:   write_enable                 integral           1     'h1                      
# KERNEL:   read_enable                  integral           1     'h1                      
# KERNEL:   data_out                     integral           32    'hxxxxxxxx               
# KERNEL:   full                         integral           1     'hX                      
# KERNEL:   empty                        integral           1     'hX                      
# KERNEL:   begin_time                   time               64    170                      
# KERNEL:   depth                        int                32    'd2                      
# KERNEL:   parent sequence (name)       string             3     seq                      
# KERNEL:   parent sequence (full name)  string             25    uvm_test_top.e0.a0.s0.seq
# KERNEL:   sequencer                    string             21    uvm_test_top.e0.a0.s0    
# KERNEL: ---------------------------------------------------------------------------------
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 180: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] idle cycle
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 180: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] empty flag correct
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 180: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] full flag correct
# KERNEL: UVM_INFO /home/runner/gen.sv(34) @ 180: uvm_test_top.e0.a0.s0@@seq [SEQ] Generate new FIFO item:
# KERNEL: ---------------------------------------------------------------------------------
# KERNEL: Name                           Type               Size  Value                    
# KERNEL: ---------------------------------------------------------------------------------
# KERNEL: m_item                         uvm_sequence_item  -     @738                     
# KERNEL:   data_in                      integral           32    'hb06ae3b7               
# KERNEL:   write_enable                 integral           1     'h1                      
# KERNEL:   read_enable                  integral           1     'h1                      
# KERNEL:   data_out                     integral           32    'hxxxxxxxx               
# KERNEL:   full                         integral           1     'hX                      
# KERNEL:   empty                        integral           1     'hX                      
# KERNEL:   begin_time                   time               64    180                      
# KERNEL:   depth                        int                32    'd2                      
# KERNEL:   parent sequence (name)       string             3     seq                      
# KERNEL:   parent sequence (full name)  string             25    uvm_test_top.e0.a0.s0.seq
# KERNEL:   sequencer                    string             21    uvm_test_top.e0.a0.s0    
# KERNEL: ---------------------------------------------------------------------------------
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(60) @ 190: uvm_test_top.e0.sb0 [Scoreboard] Normal read+write case
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 190: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] read+write output correct
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 190: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] write stored in expected queue
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 190: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] empty flag correct
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 190: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] full flag correct
# KERNEL: UVM_INFO /home/runner/gen.sv(34) @ 190: uvm_test_top.e0.a0.s0@@seq [SEQ] Generate new FIFO item:
# KERNEL: ---------------------------------------------------------------------------------
# KERNEL: Name                           Type               Size  Value                    
# KERNEL: ---------------------------------------------------------------------------------
# KERNEL: m_item                         uvm_sequence_item  -     @752                     
# KERNEL:   data_in                      integral           32    'hb0b63d8                
# KERNEL:   write_enable                 integral           1     'h0                      
# KERNEL:   read_enable                  integral           1     'h0                      
# KERNEL:   data_out                     integral           32    'hxxxxxxxx               
# KERNEL:   full                         integral           1     'hX                      
# KERNEL:   empty                        integral           1     'hX                      
# KERNEL:   begin_time                   time               64    190                      
# KERNEL:   depth                        int                32    'd2                      
# KERNEL:   parent sequence (name)       string             3     seq                      
# KERNEL:   parent sequence (full name)  string             25    uvm_test_top.e0.a0.s0.seq
# KERNEL:   sequencer                    string             21    uvm_test_top.e0.a0.s0    
# KERNEL: ---------------------------------------------------------------------------------
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(60) @ 200: uvm_test_top.e0.sb0 [Scoreboard] Normal read+write case
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 200: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] read+write output correct
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 200: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] write stored in expected queue
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 200: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] empty flag correct
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 200: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] full flag correct
# KERNEL: UVM_INFO /home/runner/gen.sv(34) @ 200: uvm_test_top.e0.a0.s0@@seq [SEQ] Generate new FIFO item:
# KERNEL: ---------------------------------------------------------------------------------
# KERNEL: Name                           Type               Size  Value                    
# KERNEL: ---------------------------------------------------------------------------------
# KERNEL: m_item                         uvm_sequence_item  -     @766                     
# KERNEL:   data_in                      integral           32    'h4498ca66               
# KERNEL:   write_enable                 integral           1     'h0                      
# KERNEL:   read_enable                  integral           1     'h0                      
# KERNEL:   data_out                     integral           32    'hxxxxxxxx               
# KERNEL:   full                         integral           1     'hX                      
# KERNEL:   empty                        integral           1     'hX                      
# KERNEL:   begin_time                   time               64    200                      
# KERNEL:   depth                        int                32    'd2                      
# KERNEL:   parent sequence (name)       string             3     seq                      
# KERNEL:   parent sequence (full name)  string             25    uvm_test_top.e0.a0.s0.seq
# KERNEL:   sequencer                    string             21    uvm_test_top.e0.a0.s0    
# KERNEL: ---------------------------------------------------------------------------------
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 210: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] idle cycle
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 210: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] empty flag correct
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 210: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] full flag correct
# KERNEL: UVM_INFO /home/runner/gen.sv(34) @ 210: uvm_test_top.e0.a0.s0@@seq [SEQ] Generate new FIFO item:
# KERNEL: ---------------------------------------------------------------------------------
# KERNEL: Name                           Type               Size  Value                    
# KERNEL: ---------------------------------------------------------------------------------
# KERNEL: m_item                         uvm_sequence_item  -     @776                     
# KERNEL:   data_in                      integral           32    'h5d131761               
# KERNEL:   write_enable                 integral           1     'h1                      
# KERNEL:   read_enable                  integral           1     'h1                      
# KERNEL:   data_out                     integral           32    'hxxxxxxxx               
# KERNEL:   full                         integral           1     'hX                      
# KERNEL:   empty                        integral           1     'hX                      
# KERNEL:   begin_time                   time               64    210                      
# KERNEL:   depth                        int                32    'd2                      
# KERNEL:   parent sequence (name)       string             3     seq                      
# KERNEL:   parent sequence (full name)  string             25    uvm_test_top.e0.a0.s0.seq
# KERNEL:   sequencer                    string             21    uvm_test_top.e0.a0.s0    
# KERNEL: ---------------------------------------------------------------------------------
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 220: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] idle cycle
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 220: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] empty flag correct
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 220: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] full flag correct
# KERNEL: UVM_INFO /home/runner/gen.sv(34) @ 220: uvm_test_top.e0.a0.s0@@seq [SEQ] Generate new FIFO item:
# KERNEL: ---------------------------------------------------------------------------------
# KERNEL: Name                           Type               Size  Value                    
# KERNEL: ---------------------------------------------------------------------------------
# KERNEL: m_item                         uvm_sequence_item  -     @786                     
# KERNEL:   data_in                      integral           32    'h547a4ac9               
# KERNEL:   write_enable                 integral           1     'h1                      
# KERNEL:   read_enable                  integral           1     'h1                      
# KERNEL:   data_out                     integral           32    'hxxxxxxxx               
# KERNEL:   full                         integral           1     'hX                      
# KERNEL:   empty                        integral           1     'hX                      
# KERNEL:   begin_time                   time               64    220                      
# KERNEL:   depth                        int                32    'd2                      
# KERNEL:   parent sequence (name)       string             3     seq                      
# KERNEL:   parent sequence (full name)  string             25    uvm_test_top.e0.a0.s0.seq
# KERNEL:   sequencer                    string             21    uvm_test_top.e0.a0.s0    
# KERNEL: ---------------------------------------------------------------------------------
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(60) @ 230: uvm_test_top.e0.sb0 [Scoreboard] Normal read+write case
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 230: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] read+write output correct
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 230: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] write stored in expected queue
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 230: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] empty flag correct
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 230: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] full flag correct
# KERNEL: UVM_INFO /home/runner/gen.sv(34) @ 230: uvm_test_top.e0.a0.s0@@seq [SEQ] Generate new FIFO item:
# KERNEL: ---------------------------------------------------------------------------------
# KERNEL: Name                           Type               Size  Value                    
# KERNEL: ---------------------------------------------------------------------------------
# KERNEL: m_item                         uvm_sequence_item  -     @800                     
# KERNEL:   data_in                      integral           32    'h2ace649e               
# KERNEL:   write_enable                 integral           1     'h0                      
# KERNEL:   read_enable                  integral           1     'h0                      
# KERNEL:   data_out                     integral           32    'hxxxxxxxx               
# KERNEL:   full                         integral           1     'hX                      
# KERNEL:   empty                        integral           1     'hX                      
# KERNEL:   begin_time                   time               64    230                      
# KERNEL:   depth                        int                32    'd2                      
# KERNEL:   parent sequence (name)       string             3     seq                      
# KERNEL:   parent sequence (full name)  string             25    uvm_test_top.e0.a0.s0.seq
# KERNEL:   sequencer                    string             21    uvm_test_top.e0.a0.s0    
# KERNEL: ---------------------------------------------------------------------------------
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(60) @ 240: uvm_test_top.e0.sb0 [Scoreboard] Normal read+write case
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 240: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] read+write output correct
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 240: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] write stored in expected queue
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 240: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] empty flag correct
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 240: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] full flag correct
# KERNEL: UVM_INFO /home/runner/gen.sv(34) @ 240: uvm_test_top.e0.a0.s0@@seq [SEQ] Generate new FIFO item:
# KERNEL: ---------------------------------------------------------------------------------
# KERNEL: Name                           Type               Size  Value                    
# KERNEL: ---------------------------------------------------------------------------------
# KERNEL: m_item                         uvm_sequence_item  -     @814                     
# KERNEL:   data_in                      integral           32    'he00f64e0               
# KERNEL:   write_enable                 integral           1     'h0                      
# KERNEL:   read_enable                  integral           1     'h0                      
# KERNEL:   data_out                     integral           32    'hxxxxxxxx               
# KERNEL:   full                         integral           1     'hX                      
# KERNEL:   empty                        integral           1     'hX                      
# KERNEL:   begin_time                   time               64    240                      
# KERNEL:   depth                        int                32    'd2                      
# KERNEL:   parent sequence (name)       string             3     seq                      
# KERNEL:   parent sequence (full name)  string             25    uvm_test_top.e0.a0.s0.seq
# KERNEL:   sequencer                    string             21    uvm_test_top.e0.a0.s0    
# KERNEL: ---------------------------------------------------------------------------------
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 250: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] idle cycle
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 250: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] empty flag correct
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 250: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] full flag correct
# KERNEL: UVM_INFO /home/runner/gen.sv(34) @ 250: uvm_test_top.e0.a0.s0@@seq [SEQ] Generate new FIFO item:
# KERNEL: ---------------------------------------------------------------------------------
# KERNEL: Name                           Type               Size  Value                    
# KERNEL: ---------------------------------------------------------------------------------
# KERNEL: m_item                         uvm_sequence_item  -     @824                     
# KERNEL:   data_in                      integral           32    'h743d4b8f               
# KERNEL:   write_enable                 integral           1     'h1                      
# KERNEL:   read_enable                  integral           1     'h1                      
# KERNEL:   data_out                     integral           32    'hxxxxxxxx               
# KERNEL:   full                         integral           1     'hX                      
# KERNEL:   empty                        integral           1     'hX                      
# KERNEL:   begin_time                   time               64    250                      
# KERNEL:   depth                        int                32    'd2                      
# KERNEL:   parent sequence (name)       string             3     seq                      
# KERNEL:   parent sequence (full name)  string             25    uvm_test_top.e0.a0.s0.seq
# KERNEL:   sequencer                    string             21    uvm_test_top.e0.a0.s0    
# KERNEL: ---------------------------------------------------------------------------------
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 260: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] idle cycle
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 260: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] empty flag correct
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 260: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] full flag correct
# KERNEL: UVM_INFO /home/runner/gen.sv(34) @ 260: uvm_test_top.e0.a0.s0@@seq [SEQ] Generate new FIFO item:
# KERNEL: ---------------------------------------------------------------------------------
# KERNEL: Name                           Type               Size  Value                    
# KERNEL: ---------------------------------------------------------------------------------
# KERNEL: m_item                         uvm_sequence_item  -     @834                     
# KERNEL:   data_in                      integral           32    'he75818ab               
# KERNEL:   write_enable                 integral           1     'h1                      
# KERNEL:   read_enable                  integral           1     'h1                      
# KERNEL:   data_out                     integral           32    'hxxxxxxxx               
# KERNEL:   full                         integral           1     'hX                      
# KERNEL:   empty                        integral           1     'hX                      
# KERNEL:   begin_time                   time               64    260                      
# KERNEL:   depth                        int                32    'd2                      
# KERNEL:   parent sequence (name)       string             3     seq                      
# KERNEL:   parent sequence (full name)  string             25    uvm_test_top.e0.a0.s0.seq
# KERNEL:   sequencer                    string             21    uvm_test_top.e0.a0.s0    
# KERNEL: ---------------------------------------------------------------------------------
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(60) @ 270: uvm_test_top.e0.sb0 [Scoreboard] Normal read+write case
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 270: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] read+write output correct
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 270: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] write stored in expected queue
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 270: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] empty flag correct
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 270: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] full flag correct
# KERNEL: UVM_INFO /home/runner/gen.sv(34) @ 270: uvm_test_top.e0.a0.s0@@seq [SEQ] Generate new FIFO item:
# KERNEL: ---------------------------------------------------------------------------------
# KERNEL: Name                           Type               Size  Value                    
# KERNEL: ---------------------------------------------------------------------------------
# KERNEL: m_item                         uvm_sequence_item  -     @848                     
# KERNEL:   data_in                      integral           32    'h395fcc34               
# KERNEL:   write_enable                 integral           1     'h0                      
# KERNEL:   read_enable                  integral           1     'h0                      
# KERNEL:   data_out                     integral           32    'hxxxxxxxx               
# KERNEL:   full                         integral           1     'hX                      
# KERNEL:   empty                        integral           1     'hX                      
# KERNEL:   begin_time                   time               64    270                      
# KERNEL:   depth                        int                32    'd2                      
# KERNEL:   parent sequence (name)       string             3     seq                      
# KERNEL:   parent sequence (full name)  string             25    uvm_test_top.e0.a0.s0.seq
# KERNEL:   sequencer                    string             21    uvm_test_top.e0.a0.s0    
# KERNEL: ---------------------------------------------------------------------------------
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(60) @ 280: uvm_test_top.e0.sb0 [Scoreboard] Normal read+write case
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 280: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] read+write output correct
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 280: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] write stored in expected queue
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 280: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] empty flag correct
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 280: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] full flag correct
# KERNEL: UVM_INFO /home/runner/gen.sv(34) @ 280: uvm_test_top.e0.a0.s0@@seq [SEQ] Generate new FIFO item:
# KERNEL: ---------------------------------------------------------------------------------
# KERNEL: Name                           Type               Size  Value                    
# KERNEL: ---------------------------------------------------------------------------------
# KERNEL: m_item                         uvm_sequence_item  -     @862                     
# KERNEL:   data_in                      integral           32    'h6a54662a               
# KERNEL:   write_enable                 integral           1     'h0                      
# KERNEL:   read_enable                  integral           1     'h0                      
# KERNEL:   data_out                     integral           32    'hxxxxxxxx               
# KERNEL:   full                         integral           1     'hX                      
# KERNEL:   empty                        integral           1     'hX                      
# KERNEL:   begin_time                   time               64    280                      
# KERNEL:   depth                        int                32    'd2                      
# KERNEL:   parent sequence (name)       string             3     seq                      
# KERNEL:   parent sequence (full name)  string             25    uvm_test_top.e0.a0.s0.seq
# KERNEL:   sequencer                    string             21    uvm_test_top.e0.a0.s0    
# KERNEL: ---------------------------------------------------------------------------------
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 290: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] idle cycle
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 290: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] empty flag correct
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 290: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] full flag correct
# KERNEL: UVM_INFO /home/runner/gen.sv(34) @ 290: uvm_test_top.e0.a0.s0@@seq [SEQ] Generate new FIFO item:
# KERNEL: ---------------------------------------------------------------------------------
# KERNEL: Name                           Type               Size  Value                    
# KERNEL: ---------------------------------------------------------------------------------
# KERNEL: m_item                         uvm_sequence_item  -     @872                     
# KERNEL:   data_in                      integral           32    'h7a35e68d               
# KERNEL:   write_enable                 integral           1     'h1                      
# KERNEL:   read_enable                  integral           1     'h1                      
# KERNEL:   data_out                     integral           32    'hxxxxxxxx               
# KERNEL:   full                         integral           1     'hX                      
# KERNEL:   empty                        integral           1     'hX                      
# KERNEL:   begin_time                   time               64    290                      
# KERNEL:   depth                        int                32    'd2                      
# KERNEL:   parent sequence (name)       string             3     seq                      
# KERNEL:   parent sequence (full name)  string             25    uvm_test_top.e0.a0.s0.seq
# KERNEL:   sequencer                    string             21    uvm_test_top.e0.a0.s0    
# KERNEL: ---------------------------------------------------------------------------------
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 300: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] idle cycle
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 300: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] empty flag correct
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 300: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] full flag correct
# KERNEL: UVM_INFO /home/runner/gen.sv(34) @ 300: uvm_test_top.e0.a0.s0@@seq [SEQ] Generate new FIFO item:
# KERNEL: ---------------------------------------------------------------------------------
# KERNEL: Name                           Type               Size  Value                    
# KERNEL: ---------------------------------------------------------------------------------
# KERNEL: m_item                         uvm_sequence_item  -     @882                     
# KERNEL:   data_in                      integral           32    'h69044d5d               
# KERNEL:   write_enable                 integral           1     'h1                      
# KERNEL:   read_enable                  integral           1     'h1                      
# KERNEL:   data_out                     integral           32    'hxxxxxxxx               
# KERNEL:   full                         integral           1     'hX                      
# KERNEL:   empty                        integral           1     'hX                      
# KERNEL:   begin_time                   time               64    300                      
# KERNEL:   depth                        int                32    'd2                      
# KERNEL:   parent sequence (name)       string             3     seq                      
# KERNEL:   parent sequence (full name)  string             25    uvm_test_top.e0.a0.s0.seq
# KERNEL:   sequencer                    string             21    uvm_test_top.e0.a0.s0    
# KERNEL: ---------------------------------------------------------------------------------
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(60) @ 310: uvm_test_top.e0.sb0 [Scoreboard] Normal read+write case
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 310: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] read+write output correct
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 310: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] write stored in expected queue
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 310: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] empty flag correct
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 310: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] full flag correct
# KERNEL: UVM_INFO /home/runner/gen.sv(34) @ 310: uvm_test_top.e0.a0.s0@@seq [SEQ] Generate new FIFO item:
# KERNEL: ---------------------------------------------------------------------------------
# KERNEL: Name                           Type               Size  Value                    
# KERNEL: ---------------------------------------------------------------------------------
# KERNEL: m_item                         uvm_sequence_item  -     @896                     
# KERNEL:   data_in                      integral           32    'h36bf9a9a               
# KERNEL:   write_enable                 integral           1     'h0                      
# KERNEL:   read_enable                  integral           1     'h0                      
# KERNEL:   data_out                     integral           32    'hxxxxxxxx               
# KERNEL:   full                         integral           1     'hX                      
# KERNEL:   empty                        integral           1     'hX                      
# KERNEL:   begin_time                   time               64    310                      
# KERNEL:   depth                        int                32    'd2                      
# KERNEL:   parent sequence (name)       string             3     seq                      
# KERNEL:   parent sequence (full name)  string             25    uvm_test_top.e0.a0.s0.seq
# KERNEL:   sequencer                    string             21    uvm_test_top.e0.a0.s0    
# KERNEL: ---------------------------------------------------------------------------------
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(60) @ 320: uvm_test_top.e0.sb0 [Scoreboard] Normal read+write case
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 320: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] read+write output correct
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 320: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] write stored in expected queue
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 320: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] empty flag correct
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 320: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] full flag correct
# KERNEL: UVM_INFO /home/runner/gen.sv(34) @ 320: uvm_test_top.e0.a0.s0@@seq [SEQ] Generate new FIFO item:
# KERNEL: ---------------------------------------------------------------------------------
# KERNEL: Name                           Type               Size  Value                    
# KERNEL: ---------------------------------------------------------------------------------
# KERNEL: m_item                         uvm_sequence_item  -     @910                     
# KERNEL:   data_in                      integral           32    'he367ce44               
# KERNEL:   write_enable                 integral           1     'h0                      
# KERNEL:   read_enable                  integral           1     'h0                      
# KERNEL:   data_out                     integral           32    'hxxxxxxxx               
# KERNEL:   full                         integral           1     'hX                      
# KERNEL:   empty                        integral           1     'hX                      
# KERNEL:   begin_time                   time               64    320                      
# KERNEL:   depth                        int                32    'd2                      
# KERNEL:   parent sequence (name)       string             3     seq                      
# KERNEL:   parent sequence (full name)  string             25    uvm_test_top.e0.a0.s0.seq
# KERNEL:   sequencer                    string             21    uvm_test_top.e0.a0.s0    
# KERNEL: ---------------------------------------------------------------------------------
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 330: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] idle cycle
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 330: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] empty flag correct
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 330: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] full flag correct
# KERNEL: UVM_INFO /home/runner/gen.sv(34) @ 330: uvm_test_top.e0.a0.s0@@seq [SEQ] Generate new FIFO item:
# KERNEL: ---------------------------------------------------------------------------------
# KERNEL: Name                           Type               Size  Value                    
# KERNEL: ---------------------------------------------------------------------------------
# KERNEL: m_item                         uvm_sequence_item  -     @920                     
# KERNEL:   data_in                      integral           32    'h6efce85b               
# KERNEL:   write_enable                 integral           1     'h1                      
# KERNEL:   read_enable                  integral           1     'h1                      
# KERNEL:   data_out                     integral           32    'hxxxxxxxx               
# KERNEL:   full                         integral           1     'hX                      
# KERNEL:   empty                        integral           1     'hX                      
# KERNEL:   begin_time                   time               64    330                      
# KERNEL:   depth                        int                32    'd2                      
# KERNEL:   parent sequence (name)       string             3     seq                      
# KERNEL:   parent sequence (full name)  string             25    uvm_test_top.e0.a0.s0.seq
# KERNEL:   sequencer                    string             21    uvm_test_top.e0.a0.s0    
# KERNEL: ---------------------------------------------------------------------------------
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 340: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] idle cycle
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 340: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] empty flag correct
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 340: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] full flag correct
# KERNEL: UVM_INFO /home/runner/gen.sv(34) @ 340: uvm_test_top.e0.a0.s0@@seq [SEQ] Generate new FIFO item:
# KERNEL: ---------------------------------------------------------------------------------
# KERNEL: Name                           Type               Size  Value                    
# KERNEL: ---------------------------------------------------------------------------------
# KERNEL: m_item                         uvm_sequence_item  -     @930                     
# KERNEL:   data_in                      integral           32    'hd97ee8df               
# KERNEL:   write_enable                 integral           1     'h1                      
# KERNEL:   read_enable                  integral           1     'h1                      
# KERNEL:   data_out                     integral           32    'hxxxxxxxx               
# KERNEL:   full                         integral           1     'hX                      
# KERNEL:   empty                        integral           1     'hX                      
# KERNEL:   begin_time                   time               64    340                      
# KERNEL:   depth                        int                32    'd2                      
# KERNEL:   parent sequence (name)       string             3     seq                      
# KERNEL:   parent sequence (full name)  string             25    uvm_test_top.e0.a0.s0.seq
# KERNEL:   sequencer                    string             21    uvm_test_top.e0.a0.s0    
# KERNEL: ---------------------------------------------------------------------------------
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(60) @ 350: uvm_test_top.e0.sb0 [Scoreboard] Normal read+write case
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 350: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] read+write output correct
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 350: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] write stored in expected queue
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 350: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] empty flag correct
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 350: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] full flag correct
# KERNEL: UVM_INFO /home/runner/gen.sv(34) @ 350: uvm_test_top.e0.a0.s0@@seq [SEQ] Generate new FIFO item:
# KERNEL: ---------------------------------------------------------------------------------
# KERNEL: Name                           Type               Size  Value                    
# KERNEL: ---------------------------------------------------------------------------------
# KERNEL: m_item                         uvm_sequence_item  -     @944                     
# KERNEL:   data_in                      integral           32    'h22edcfd0               
# KERNEL:   write_enable                 integral           1     'h0                      
# KERNEL:   read_enable                  integral           1     'h0                      
# KERNEL:   data_out                     integral           32    'hxxxxxxxx               
# KERNEL:   full                         integral           1     'hX                      
# KERNEL:   empty                        integral           1     'hX                      
# KERNEL:   begin_time                   time               64    350                      
# KERNEL:   depth                        int                32    'd2                      
# KERNEL:   parent sequence (name)       string             3     seq                      
# KERNEL:   parent sequence (full name)  string             25    uvm_test_top.e0.a0.s0.seq
# KERNEL:   sequencer                    string             21    uvm_test_top.e0.a0.s0    
# KERNEL: ---------------------------------------------------------------------------------
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(60) @ 360: uvm_test_top.e0.sb0 [Scoreboard] Normal read+write case
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 360: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] read+write output correct
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 360: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] write stored in expected queue
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 360: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] empty flag correct
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 360: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] full flag correct
# KERNEL: UVM_INFO /home/runner/gen.sv(34) @ 360: uvm_test_top.e0.a0.s0@@seq [SEQ] Generate new FIFO item:
# KERNEL: ---------------------------------------------------------------------------------
# KERNEL: Name                           Type               Size  Value                    
# KERNEL: ---------------------------------------------------------------------------------
# KERNEL: m_item                         uvm_sequence_item  -     @958                     
# KERNEL:   data_in                      integral           32    'h4b499d2e               
# KERNEL:   write_enable                 integral           1     'h0                      
# KERNEL:   read_enable                  integral           1     'h0                      
# KERNEL:   data_out                     integral           32    'hxxxxxxxx               
# KERNEL:   full                         integral           1     'hX                      
# KERNEL:   empty                        integral           1     'hX                      
# KERNEL:   begin_time                   time               64    360                      
# KERNEL:   depth                        int                32    'd2                      
# KERNEL:   parent sequence (name)       string             3     seq                      
# KERNEL:   parent sequence (full name)  string             25    uvm_test_top.e0.a0.s0.seq
# KERNEL:   sequencer                    string             21    uvm_test_top.e0.a0.s0    
# KERNEL: ---------------------------------------------------------------------------------
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 370: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] idle cycle
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 370: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] empty flag correct
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 370: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] full flag correct
# KERNEL: UVM_INFO /home/runner/gen.sv(34) @ 370: uvm_test_top.e0.a0.s0@@seq [SEQ] Generate new FIFO item:
# KERNEL: ---------------------------------------------------------------------------------
# KERNEL: Name                           Type               Size  Value                    
# KERNEL: ---------------------------------------------------------------------------------
# KERNEL: m_item                         uvm_sequence_item  -     @968                     
# KERNEL:   data_in                      integral           32    'h529250f9               
# KERNEL:   write_enable                 integral           1     'h1                      
# KERNEL:   read_enable                  integral           1     'h1                      
# KERNEL:   data_out                     integral           32    'hxxxxxxxx               
# KERNEL:   full                         integral           1     'hX                      
# KERNEL:   empty                        integral           1     'hX                      
# KERNEL:   begin_time                   time               64    370                      
# KERNEL:   depth                        int                32    'd2                      
# KERNEL:   parent sequence (name)       string             3     seq                      
# KERNEL:   parent sequence (full name)  string             25    uvm_test_top.e0.a0.s0.seq
# KERNEL:   sequencer                    string             21    uvm_test_top.e0.a0.s0    
# KERNEL: ---------------------------------------------------------------------------------
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 380: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] idle cycle
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 380: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] empty flag correct
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 380: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] full flag correct
# KERNEL: UVM_INFO /home/runner/gen.sv(34) @ 380: uvm_test_top.e0.a0.s0@@seq [SEQ] Generate new FIFO item:
# KERNEL: ---------------------------------------------------------------------------------
# KERNEL: Name                           Type               Size  Value                    
# KERNEL: ---------------------------------------------------------------------------------
# KERNEL: m_item                         uvm_sequence_item  -     @978                     
# KERNEL:   data_in                      integral           32    'h38c7eb31               
# KERNEL:   write_enable                 integral           1     'h1                      
# KERNEL:   read_enable                  integral           1     'h1                      
# KERNEL:   data_out                     integral           32    'hxxxxxxxx               
# KERNEL:   full                         integral           1     'hX                      
# KERNEL:   empty                        integral           1     'hX                      
# KERNEL:   begin_time                   time               64    380                      
# KERNEL:   depth                        int                32    'd2                      
# KERNEL:   parent sequence (name)       string             3     seq                      
# KERNEL:   parent sequence (full name)  string             25    uvm_test_top.e0.a0.s0.seq
# KERNEL:   sequencer                    string             21    uvm_test_top.e0.a0.s0    
# KERNEL: ---------------------------------------------------------------------------------
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(60) @ 390: uvm_test_top.e0.sb0 [Scoreboard] Normal read+write case
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 390: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] read+write output correct
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 390: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] write stored in expected queue
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 390: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] empty flag correct
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 390: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] full flag correct
# KERNEL: UVM_INFO /home/runner/gen.sv(34) @ 390: uvm_test_top.e0.a0.s0@@seq [SEQ] Generate new FIFO item:
# KERNEL: ---------------------------------------------------------------------------------
# KERNEL: Name                           Type               Size  Value                    
# KERNEL: ---------------------------------------------------------------------------------
# KERNEL: m_item                         uvm_sequence_item  -     @992                     
# KERNEL:   data_in                      integral           32    'hfdea6bd6               
# KERNEL:   write_enable                 integral           1     'h0                      
# KERNEL:   read_enable                  integral           1     'h0                      
# KERNEL:   data_out                     integral           32    'hxxxxxxxx               
# KERNEL:   full                         integral           1     'hX                      
# KERNEL:   empty                        integral           1     'hX                      
# KERNEL:   begin_time                   time               64    390                      
# KERNEL:   depth                        int                32    'd2                      
# KERNEL:   parent sequence (name)       string             3     seq                      
# KERNEL:   parent sequence (full name)  string             25    uvm_test_top.e0.a0.s0.seq
# KERNEL:   sequencer                    string             21    uvm_test_top.e0.a0.s0    
# KERNEL: ---------------------------------------------------------------------------------
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(60) @ 400: uvm_test_top.e0.sb0 [Scoreboard] Normal read+write case
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 400: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] read+write output correct
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 400: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] write stored in expected queue
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 400: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] empty flag correct
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 400: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] full flag correct
# KERNEL: UVM_INFO /home/runner/gen.sv(34) @ 400: uvm_test_top.e0.a0.s0@@seq [SEQ] Generate new FIFO item:
# KERNEL: ---------------------------------------------------------------------------------
# KERNEL: Name                           Type               Size  Value                    
# KERNEL: ---------------------------------------------------------------------------------
# KERNEL: m_item                         uvm_sequence_item  -     @1006                    
# KERNEL:   data_in                      integral           32    'ha1f9d2e8               
# KERNEL:   write_enable                 integral           1     'h0                      
# KERNEL:   read_enable                  integral           1     'h0                      
# KERNEL:   data_out                     integral           32    'hxxxxxxxx               
# KERNEL:   full                         integral           1     'hX                      
# KERNEL:   empty                        integral           1     'hX                      
# KERNEL:   begin_time                   time               64    400                      
# KERNEL:   depth                        int                32    'd2                      
# KERNEL:   parent sequence (name)       string             3     seq                      
# KERNEL:   parent sequence (full name)  string             25    uvm_test_top.e0.a0.s0.seq
# KERNEL:   sequencer                    string             21    uvm_test_top.e0.a0.s0    
# KERNEL: ---------------------------------------------------------------------------------
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 410: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] idle cycle
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 410: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] empty flag correct
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 410: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] full flag correct
# KERNEL: UVM_INFO /home/runner/gen.sv(34) @ 410: uvm_test_top.e0.a0.s0@@seq [SEQ] Generate new FIFO item:
# KERNEL: ---------------------------------------------------------------------------------
# KERNEL: Name                           Type               Size  Value                    
# KERNEL: ---------------------------------------------------------------------------------
# KERNEL: m_item                         uvm_sequence_item  -     @1016                    
# KERNEL:   data_in                      integral           32    'h24f62067               
# KERNEL:   write_enable                 integral           1     'h1                      
# KERNEL:   read_enable                  integral           1     'h1                      
# KERNEL:   data_out                     integral           32    'hxxxxxxxx               
# KERNEL:   full                         integral           1     'hX                      
# KERNEL:   empty                        integral           1     'hX                      
# KERNEL:   begin_time                   time               64    410                      
# KERNEL:   depth                        int                32    'd2                      
# KERNEL:   parent sequence (name)       string             3     seq                      
# KERNEL:   parent sequence (full name)  string             25    uvm_test_top.e0.a0.s0.seq
# KERNEL:   sequencer                    string             21    uvm_test_top.e0.a0.s0    
# KERNEL: ---------------------------------------------------------------------------------
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 420: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] idle cycle
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 420: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] empty flag correct
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 420: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] full flag correct
# KERNEL: UVM_INFO /home/runner/gen.sv(41) @ 420: uvm_test_top.e0.a0.s0@@seq [SEQ] Done generation of 28 items
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(60) @ 430: uvm_test_top.e0.sb0 [Scoreboard] Normal read+write case
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 430: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] read+write output correct
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 430: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] write stored in expected queue
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 430: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] empty flag correct
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 430: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] full flag correct
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(60) @ 440: uvm_test_top.e0.sb0 [Scoreboard] Normal read+write case
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 440: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] read+write output correct
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 440: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] write stored in expected queue
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 440: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] empty flag correct
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 440: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] full flag correct
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(60) @ 450: uvm_test_top.e0.sb0 [Scoreboard] Normal read+write case
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 450: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] read+write output correct
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 450: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] write stored in expected queue
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 450: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] empty flag correct
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 450: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] full flag correct
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(60) @ 460: uvm_test_top.e0.sb0 [Scoreboard] Normal read+write case
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 460: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] read+write output correct
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 460: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] write stored in expected queue
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 460: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] empty flag correct
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 460: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] full flag correct
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(60) @ 470: uvm_test_top.e0.sb0 [Scoreboard] Normal read+write case
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 470: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] read+write output correct
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 470: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] write stored in expected queue
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 470: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] empty flag correct
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 470: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] full flag correct
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(60) @ 480: uvm_test_top.e0.sb0 [Scoreboard] Normal read+write case
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 480: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] read+write output correct
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 480: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] write stored in expected queue
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 480: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] empty flag correct
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 480: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] full flag correct
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(60) @ 490: uvm_test_top.e0.sb0 [Scoreboard] Normal read+write case
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 490: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] read+write output correct
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 490: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] write stored in expected queue
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 490: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] empty flag correct
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 490: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] full flag correct
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(60) @ 500: uvm_test_top.e0.sb0 [Scoreboard] Normal read+write case
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 500: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] read+write output correct
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 500: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] write stored in expected queue
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 500: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] empty flag correct
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 500: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] full flag correct
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(60) @ 510: uvm_test_top.e0.sb0 [Scoreboard] Normal read+write case
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 510: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] read+write output correct
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 510: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] write stored in expected queue
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 510: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] empty flag correct
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 510: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] full flag correct
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(60) @ 520: uvm_test_top.e0.sb0 [Scoreboard] Normal read+write case
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 520: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] read+write output correct
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 520: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] write stored in expected queue
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 520: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] empty flag correct
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 520: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] full flag correct
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(60) @ 530: uvm_test_top.e0.sb0 [Scoreboard] Normal read+write case
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 530: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] read+write output correct
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 530: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] write stored in expected queue
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 530: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] empty flag correct
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 530: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] full flag correct
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(60) @ 540: uvm_test_top.e0.sb0 [Scoreboard] Normal read+write case
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 540: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] read+write output correct
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 540: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] write stored in expected queue
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 540: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] empty flag correct
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 540: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] full flag correct
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(60) @ 550: uvm_test_top.e0.sb0 [Scoreboard] Normal read+write case
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 550: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] read+write output correct
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 550: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] write stored in expected queue
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 550: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] empty flag correct
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 550: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] full flag correct
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(60) @ 560: uvm_test_top.e0.sb0 [Scoreboard] Normal read+write case
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 560: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] read+write output correct
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 560: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] write stored in expected queue
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 560: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] empty flag correct
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 560: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] full flag correct
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(60) @ 570: uvm_test_top.e0.sb0 [Scoreboard] Normal read+write case
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 570: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] read+write output correct
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 570: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] write stored in expected queue
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 570: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] empty flag correct
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 570: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] full flag correct
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(60) @ 580: uvm_test_top.e0.sb0 [Scoreboard] Normal read+write case
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 580: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] read+write output correct
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 580: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] write stored in expected queue
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 580: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] empty flag correct
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 580: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] full flag correct
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(60) @ 590: uvm_test_top.e0.sb0 [Scoreboard] Normal read+write case
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 590: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] read+write output correct
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 590: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] write stored in expected queue
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 590: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] empty flag correct
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 590: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] full flag correct
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(60) @ 600: uvm_test_top.e0.sb0 [Scoreboard] Normal read+write case
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 600: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] read+write output correct
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 600: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] write stored in expected queue
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 600: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] empty flag correct
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 600: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] full flag correct
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(60) @ 610: uvm_test_top.e0.sb0 [Scoreboard] Normal read+write case
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 610: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] read+write output correct
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 610: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] write stored in expected queue
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 610: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] empty flag correct
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 610: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] full flag correct
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(60) @ 620: uvm_test_top.e0.sb0 [Scoreboard] Normal read+write case
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 620: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] read+write output correct
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 620: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] write stored in expected queue
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 620: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] empty flag correct
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(21) @ 620: uvm_test_top.e0.sb0 [SCB_PASS] [Scoreboard] full flag correct
# KERNEL: UVM_INFO ./uvm-1.2/src/base/uvm_objection.svh(1271) @ 620: reporter [TEST_DONE] 'run' phase is ready to proceed to the 'extract' phase
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(141) @ 620: uvm_test_top.e0.sb0 [Scoreboard] ALL TEST CASES PASSING!
# KERNEL: UVM_INFO ./uvm-1.2/src/base/uvm_report_server.svh(869) @ 620: reporter [UVM/REPORT/SERVER] 
# KERNEL: --- UVM Report Summary ---
# KERNEL: 
# KERNEL: ** Report counts by severity
# KERNEL: UVM_INFO :  270
# KERNEL: UVM_WARNING :    0
# KERNEL: UVM_ERROR :    0
# KERNEL: UVM_FATAL :    0
# KERNEL: ** Report counts by id
# KERNEL: [RNTST]     1
# KERNEL: [SCB_PASS]   203
# KERNEL: [SEQ]    29
# KERNEL: [Scoreboard]    35
# KERNEL: [TEST_DONE]     1
# KERNEL: [UVM/RELNOTES]     1
# KERNEL: 
# RUNTIME: Info: RUNTIME_0068 uvm_root.svh (521): $finish called.
# KERNEL: Time: 620 ns,  Iteration: 57,  Instance: /tb_top,  Process: @INITIAL#51_1@.
# KERNEL: stopped at time: 620 ns
# VSIM: Simulation has finished. There are no more test vectors to simulate.
# VSIM: Simulation has finished.

```
</details>
