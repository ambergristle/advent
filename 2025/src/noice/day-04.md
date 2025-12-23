## 04 - Printing Department

### Setup

Rolls of paper `@` are arranged on a grid. Determine how many rolls can be moved by forklift.


#### Test Case

```
..@@.@@@@.
@@@.@.@.@@
@@@@@.@.@@
@.@@@@..@.
@@.@@@@.@@
.@@@@@@@.@
.@.@.@.@@@
@.@@@.@@@@
.@@@@@@@@.
@.@.@@@.@.
```

```
..X.X.\n
X.X.X.X\n
X.X.X\n
X.X..X.\n
X.X.X\n
.X.X\n
.X.X.X.X\n
X.X.X\n
.X.\n
X.X.X.X.\n
```

Each cell can be represented as a slice {0, 0, 0, 0, 0, 0, 1, 1}

### Part I

Forklifts can only access a roll if there are **fewer than four** rolls in the **eight** adjacent positions.

- any corner rolls are guaranteed
- edges can ignore anything out of bounds
-  

```
..xx.xx@x.
x@@.@.@.@@
@@@@@.x.@@
@.@@@@..@.
x@.@@@@.@x
.@@@@@@@.@
.@.@.@.@@@
x.@@@.@@@@
.@@@@@@@@.
x.x.@@@.x.
```

The solution to the test case is `13`.

> [!success] Solution: `1467`

### Part II

Once forklifts can access a roll of paper, it can be removed, allowing access to more rolls of paper, which they might also be able to remove.

How many total rolls of paper could the Elves remove if they keep repeating this process?

The solution to the test case is `43`.

> [!success] Solution: `8484`

A depth-first search
