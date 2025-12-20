## 00 - Secret Entrance

### Setup

A safe has a dial with only an arrow on it; around the dial are the numbers 0 through 99 in order. As you turn the dial, it makes a small click noise as it reaches each number.

Puzzle input contains a sequence of rotations, one per line. A rotation starts with an L or R which indicates whether the rotation should be to the left (toward lower numbers) or to the right (toward higher numbers). Then, the rotation has a distance value which indicates how many clicks the dial should be rotated in that direction.

If the dial begins at `11`, the following rotations would leave it at `0`:

```
R8  -> 19
L19 -> 0
```

Because the dial is a circle, turning the dial left from `0` one click makes it point at `99`. Similarly, turning the dial right from `99` one click makes it point at `0`.

If the dial begins at `5`, the following rotations would also leave it at `0`.

```
L10 -> 95
R5  -> 0
```

#### Test Case

```
L68
L30
R48
L5
R60
L55
L1
L99
R14
L82
```

### Part I

Count the number of times the dial is left pointing at `0` after any rotation in the sequence.

The solution to the test case is `3`.

```
L68 -> 82
L30 -> 52
R48 ---> 0
L5  -> 95
R60 -> 55
L55 ---> 0
L1  -> 99
L99 ---> 0
R14 -> 14
L82 -> 32
```

> [!success] Solution: `995`

### Part II

Count the number of times any click causes the dial to point at `0`, *regardless of whether it happens during a rotation or at the end of one*.

The solution to the test case from Part I is actually `6`, not `3`.

```
L68 -> 0 -> 82
L30 -> 52
R48 ------> 0
L5  -> 95
R60 -> 0 -> 55
L55 ------> 0
L1  -> 99
L99 ------> 0
R14 -> 14
L82 -> 0 -> 32
```

> [!success] Solution: `5847`
