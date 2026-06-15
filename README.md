![Verilog](https://img.shields.io/badge/Verilog-RTL-blue)
![AXI](https://img.shields.io/badge/AXI-Protocol-orange)
![Digital\_Design](https://img.shields.io/badge/Digital-Design-green)
![RTL](https://img.shields.io/badge/RTL-Implementation-red)
![QuestaSim](https://img.shields.io/badge/QuestaSim-Simulator-blue)

# AXI_RTL_Design

## Overview

Designed an AXI-based communication interface in Verilog following the AXI protocol specification. Implemented the AXI channel architecture to support independent address, data, and response transfers between master and slave modules. Verified functionality through simulation using testbench-based validation.

---

## AXI Features

### Write Address Channel (AW)

* Address Transfer
* Burst Information
* Transaction Control Signals

### Write Data Channel (W)

* Data Transfer
* Write Strobes
* Burst Data Handling

### Write Response Channel (B)

* Write Transaction Acknowledgment
* Response Generation

### Read Address Channel (AR)

* Read Address Transfer
* Burst Configuration

### Read Data Channel (R)

* Read Data Transfer
* Read Response Handling

---

## Protocol Features Implemented

* Separate Read and Write Channels
* Independent Address and Data Paths
* VALID/READY Handshake Mechanism
* Read Transactions
* Write Transactions
* Burst Transfer Support (if implemented)
* Full-Duplex Communication

---

## Modules Implemented

### AXI Master

* Generates read and write requests.
* Controls transaction flow.

### AXI Slave

* Responds to master requests.
* Handles data transfers and responses.

### AXI Interconnect (if implemented)

* Routes transactions between master and slave.

---

## Design Validation

The design was validated through simulation to verify:

* Read Transactions
* Write Transactions
* VALID/READY Handshake Operation
* Data Transfer Correctness
* Address Transfer Correctness
* Response Generation

---

## Tools Used

* Verilog
* QuestaSim
* Git
* Linux

---

## Results

* Successfully implemented AXI protocol communication.
* Verified read and write transaction functionality.
* Validated VALID/READY handshake behavior.
* Confirmed correct address and data transfer operations through simulation.

---

## Repository Structure

```text
AXI_RTL_Design
│
├── rtl/
│   ├── axi_master.v
│   ├── axi_slave.v
│   └── axi_top.v
│
├── tb/
├── waveforms/
├── docs/
└── README.md
```

---

## Waveforms

Simulation waveform screenshots are available in the `waveforms/` directory.

---

## Future Improvements

* UVM-Based Verification Environment
* Functional Coverage Collection
* Assertion-Based Verification
* AXI4 Full Protocol Support
* Multi-Master Interconnect Support
