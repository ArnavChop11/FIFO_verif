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

The FIFO is verified using SystemVerilog simulation. The project currently includes a custom class-based non-UVM testbench.

The custom testbench was developed first to manually build the verification flow and better understand how generators, drivers, monitors, scoreboards, mailboxes, events, and virtual interfaces work together.

A UVM-based testbench will later recreate the same verification structure using standard UVM methodology.

#### Non-UVM Verification Components

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
