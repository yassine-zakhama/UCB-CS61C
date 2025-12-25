# Conway's Game of Life

## Overview

This project implements Conway's **[Game of Life](https://en.wikipedia.org/wiki/Conway%27s_Game_of_Life)** using **PPM images** as the input and output.
Each pixel in the input image represents a cell:

- **White (`255,255,255`)** = alive
- **Black (`0,0,0`)** = dead

The program computes the next generation of the game based on a **rule**, specified as a hexadecimal number (similar to `0x1808` for Conway's standard rules).

The grid **wraps** around edges, so the top row is adjacent to the bottom, and the left column is adjacent to the right.

---

## Files

- **`imageloader.h / imageloader.c`** – Functions to read/write PPM images and manage memory.
- **`gameoflife.c`** – Main program for computing one iteration of the Game of Life with a given rule.
- **`frames.csh`** – C shell script to generate multiple frames for animations.

---

## Compilation

To compile the project:

```bash
make gameOfLife
```

This produces the executable `gameOfLife`.

---

## Usage

```bash
./gameOfLife <input.ppm> <rule>
```

- **`<input.ppm>`** – Input PPM file containing the initial game state.
- **`<rule>`** – Hexadecimal number representing the Game of Life rule (e.g., `0x1808`).

Example:

```bash
./gameOfLife glider.ppm 0x1808 > next.ppm
```

This computes the next generation and writes it to `next.ppm`.

---

## Optional: Generate Multiple Frames

You can use the included `frames.csh` script to generate multiple frames for animation:

```bash
csh frames.csh <rootname> <rule> <num_frames>
```

Example:

```bash
csh frames.csh glider 0x1808 10
```

- Generates frames in `studentOutputs/glider/`
- Converts frames into an animated GIF using ImageMagick (`convert`)

**Note:** You need **csh** and **ImageMagick** installed to run the script.

---

## Game Rules

- **Alive cell**:
  - Fewer than 2 alive neighbors → dies
  - 2 or 3 alive neighbors → lives
  - More than 3 alive neighbors → dies
- **Dead cell**:
  - Exactly 3 alive neighbors → becomes alive

These rules can be represented by a **hexadecimal rule number**, where:

- Bits `0–8` → Dead cell with N neighbors
- Bits `9–17` → Alive cell with N neighbors

Example:

- `0x1808` → Conway’s standard rules.

---

## Memory Management

- All images are dynamically allocated.
- Properly free memory using `freeImage()` to prevent leaks.

---

## Acknowledgments

Sincere thanks to the CS61C course staff at UC Berkeley for providing the starter code and detailed project specifications.
