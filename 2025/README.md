
# Advent 2025 - Zig

[https://adventofcode.com/2025](https://adventofcode.com/2025)

- [01 - Secret Entrance](#secret-entrance)
- [02 - Gift Shop](#gift-shop)
- [03 - Lobby](#lobby)
- [04 - Printing Department](#printing-department)

## Secret Entrance

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

The solution to the test case is `3`;

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

The solution to the test case is `6`;

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

## Gift Shop

Identify the invalid product IDs in the provided ranges. Ranges are formatted as a single comma-delimited string. Each range consists of a `first` and `last` ID value, separated by a dash (e.g., `11-22,95-115`). ID values do not include leading zeroes.

What do you get if you add up all of the invalid IDs?

#### Test Case

```
11-22,95-115,998-1012,1188511880-1188511890,222220-222224,
1698522-1698528,446443-446449,38593856-38593862,565653-565659,
824824821-824824827,2121212118-2121212124
```

*Line breaks included for legibility*

### Part I

Invalid IDs are made only of some sequence of digits repeated twice. So, 55 (5 twice), 6464 (64 twice), and 123123 (123 twice) would all be invalid IDs.

> [!success] Solution: `29818212493`

Like many others, I simply loop over each range, formatting numbers as digits, then splitting them into equal haves to do a direct slice comparison. I have no idea what the performance is like.

```zig
const str = try std.fmt.bufPrint(&buf, "{}", .{num});
if (@mod(str.len, 2) != 0) continue;

const mid = str.len / 2;

if (!std.mem.eql(u8, str[0..mid], str[mid..])) {
    continue;
}

sum += num;
```

This seemed a little more controversial. The string stuff can't be optimal, but there's also a legibility trade-off.


There are some cool [optimizations (C)](https://github.com/a-mullins/advent/blob/2025/2025/day02/p01.c), and also some radically different approaches:

- A Python solution that seems to [use math instead of string comparisons](https://github.com/mezzol2/AdventOfCode2025/blob/main/day2/main.py)
- A C++ solution that [does the same](https://github.com/vss2sn/advent_of_code/blob/master/2025/cpp/day_02a.cpp)

I found a Zig solution totally unlike mine though. It does [something with prime numbers](https://github.com/aditya-rajagopal/aoc2025/blob/master/src/day2.zig). I'd like to look into it when I have a chance: it seems to do much more work, and it's harder to follow, but it's an insightful approach if nothing else.

### Part II

Now, an ID is invalid if it is made only of some sequence of digits repeated at least twice. So, 12341234 (1234 two times), 123123123 (123 three times), 1212121212 (12 five times), and 1111111 (1 seven times) are all invalid IDs.

The solution to the test case is `4174379265`.

> [!success] Solution: `37432260594`

```zig
const str = try std.fmt.bufPrint(&buff, "{}", .{num});
for (1..(str.len / 2 + 1)) |i| {
    const slice = str[0..i];
    const count = std.mem.count(u8, str, slice);
    
    const expected = (
        @as(f64, @floatFromInt(str.len)) / @as(f64, @floatFromInt(slice.len));
    );

    if (@as(f64, @floatFromInt(count)) == expected) {
        // found invalid id
        continue :id_loop;
    }
}
```

This one seems rough. I do a *third* loop (albeit a small one) over each digit, incrementally checking whether a slices is repeated throughout the number (i.e., `slice_len * reps = total_len`).


Doing a performance comparison on these implementations seems worthwhile, though they remain interesting primarily from an algorithmic point of view (rather than vis-a-vis language features or base concepts).

## Lobby

### Part I

### Part II

## Printing Department

### Part I

### Part II

