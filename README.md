# Test Score Calculator — LC-3 Assembly

**CIS-11 Course Project | Team: Avengers Assemble**  
David Zaragoza · Javier Martinez · Francisco Colorado

---

## Overview

An LC-3 assembly program that accepts five integer test scores, then computes and displays the minimum, maximum, and average — each with its corresponding letter grade.

## How to Run

1. Assemble `testScoreCalculator.asm` using LC3Tools (or equivalent assembler)
2. Load the generated `.obj` file into the LC-3 simulator
3. Set the program counter to `x3000`
4. Run the simulation and enter five scores when prompted (integers 0–100)

## Example

**Input:** 52, 87, 96, 79, 61

**Output:**

## Grading Scale

| Score | Grade |
|-------|-------|
| 90–100 | A |
| 80–89 | B |
| 70–79 | C |
| 60–69 | D |
| 0–59 | F |

## Program Structure

- **`READ_NUMBER`** — reads multi-digit keyboard input and converts ASCII to binary integer
- **`FIND_MIN_MAX`** — iterates the scores array and returns min (R3) and max (R4)
- **`CALC_AVERAGE`** — sums all five scores and divides by 5 via iterative subtraction, returns average in R5
- **`GET_GRADE`** — takes a score in R0, returns the ASCII letter grade in R0

All subroutines use PUSH/POP stack operations for full register save-restore.

## Team

| Member | Role |
|--------|------|
| David Zaragoza | Documentation, pseudocode, flowchart |
| Francisco Colorado | I/O routines, READ_NUMBER, PRINT_NUMBER, TRAP calls |
| Javier Martinez | FIND_MIN_MAX, CALC_AVERAGE, GET_GRADE, testing |

---

*Advisor: Kasey Nguyen, PhD · CIS-11 · May 2025*
