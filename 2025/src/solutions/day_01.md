
## 01 - Secret Entrance

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

> [!success] Solution: `995`

My solution is similar to others shared to the subreddit, though it is memory- than speed-optimized. A Java user suggested that [linked lists could reduce runtime by ~70%](https://github.com/ShawnWebDev/AdventOfCode25/blob/master/src/main/java/com/webdev/day1/Day1LinkedList.java).

The solution splits the input by `\n`, then iterates over the line slices, which are further split into their direction flag (`R or L`) and their distance value.

> When evaluating distance, we need to distinguish between *relative* and *absolute* positional change. We are given an absolute distance, which may include full rotations (returning the dial to its original position). Modulo allows us to extract the relative distance the dial moves after rotations are complete.

I chose to convert the direction into a valence (`+1 or -1`), allowing me to use a single expression to calculate the new position:

```zig
const new_position = cursor + (absolute_distance * direction);
```

Other solutions used an `if` or `switch` statement, splitting the update into addition and subtraction operations:

```zig
if ('R' == line[0]) {
    cursor += absolute_distance;
} else {
    cursor -= absolute_distance;
}
```

When updating the curspor position, we use modulo again to apply only relative distance.


It took me a moment to figure out how to model this, and certainly my solution was naive, but I think I landed on something fairly intuitive and clear.

I may be able to optimize how much memory I allocate for local variables, and I think I may have over-engineered the logic at the expense of clarity, but I'm happy with my solution overall. Nonetheless, I'd be curious to look into the linked list implementation, if only for science.

### Part II

Count the number of times any click causes the dial to point at `0`, *regardless of whether it happens during a rotation or at the end of one*.

> [!success] Solution: `5847`

The second part did not substantially change the problem's logical requirements. Instead of only considering the relative distance (whether the dial lands on zero), we first need to count any full rotations:

```zig
const distance = try std.fmt.parseInt(i32, line[1..], 10);

const rotations = try std.math.divFloor(i32, distance, ticks);
zeroed += rotations;
```

And then we also need to consider any additional traversals that occur during relative repositioning:

```zig
if (0 != cursor and (new_position <= 0 or new_position >= 100)) {
    zeroed += 1;
}
```

This additional complexity puts strain on my design though. I think that splitting the logic into different cases would probably make this a lot more readable.

For me, the biggest challenge here was just getting going with Zig, and learning how numbers work. I got stuck for a while on the algorithm, but it was a good place to start.
