# 8-Bit Hardware Divider Project

Welcome to my custom 8-bit digital divider built in Verilog! I wanted to build a hardware math engine that was smart enough to handle both positive and negative numbers automatically, just like a real processor does. 

## How It Works (The Modules)

I split the project into distinct hardware blocks so the code stays clean, modular, and easy to read:

* *`divider_top.v`*: The main top-level wrapper that wires all the individual components together. 
* *`button_sync.v`*: A 2-stage synchronizer with an edge-detector. It takes messy, bouncing human button presses and turning them into a clean, 1-clock-cycle pulse to prevent system metastability.
* *`divider.v`*: The actual math engine. It uses a custom state machine to do the division step-by-step.
* *`input_sign.v`*: A helper module. If you give the divider negative numbers, this temporarily turns them positive so the math engine can do its job easily.
* *`output_sign.v`*: A second helper module. Once the math is done, it checks if the final answer should be negative and formats it correctly (using 2's complement).

## Key Features

* *Fast & Predictable*: It is optimized to always calculate the final answer in exactly 11 clock cycles.
* *Smart Sign Handling*: You can throw positive or negative numbers at it, and it does the translations automatically.
* *Divide-by-Zero Protection*: If you accidentally try to divide by zero, the hardware catches the mistake instantly, stops the math, and throws an error flag instead of freezing up.

## File Structure

```text
├── divider_top.v   # Main file that ties it all together
├── button_sync.v   # Input synchronizer and pulse generator
├── divider.v       # Math state machine
├── input_sign.v    # Input converter
├── output_sign.v   # Output converter
└── testbench.sv    # Simulation and testing file
```
