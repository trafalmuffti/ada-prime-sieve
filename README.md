# Concurrent Prime Sieve in Ada

## Overview
A current prime sieve in Ada. The program is designed to find and print the first 10 prime numbers sequentially. 

## Structure
- **Main Procedure**: Initializes and controls the flow of the program, sets up the generator, and chains filters for each new prime found.
- **Generate Task**: Continuously generates integers starting from 2 and sends them to a communication channel.
- **Filter Task**: Receives integers from a channel and filters out numbers that are not divisible by a specified prime number, passing others to a new channel.
- **Channel Protected Type**: Manages inter-task communication safely, ensuring synchronization between tasks that produce and consume integers.

## Files
- `main.adb`: Contains the entire program including the Main procedure and task definitions.

## Requirements
- **Ada Compiler**: The GNAT Ada compiler is recommended. You can install GNAT through the AdaCore libre site or as part of the GNAT Programming Studio (GPS).

## Compilation
To compile the program, you can use the following command if you are using GNAT:
```bash
gnatmake main.adb
```
This command compiles the `main.adb` file and links the necessary binaries to produce an executable.

## Running the Program
Once compiled, you can run the program by executing the generated binary:
```bash
./main
```
The program will output the first 10 prime numbers, each on a new line, labeled accordingly.
