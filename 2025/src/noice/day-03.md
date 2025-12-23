## 03 - Lobby

### Setup

Maximizing the [joltage](https://adventofcode.com/2020/day/10) produced by a series of batter banks.

Each battery is labeled by its joltage rating, a value from 1 to 9. The joltage produced by the bank is the number formed by the digits of the batteries you've turned on. You cannot rearrange batteries.

For example, if you have a bank `12345`, turning on batteries `2` and `4` yields `24` jolts.

#### Test Case

```
987654321111111
811111111111119
234234234234278
818181911112111
```

### Part I

Within each bank of batteries, turn on exactly **two** batteries, maximizing joltage.

The solution to the test case is `357`.

After splitting the lines by `\n`, I iterate through each, looking (somewhat inelegantly) for the largest values, and clearing downstream values on write.

> [!success] Solution: `17403`

- A C++ solution with some [string ops](https://github.com/vss2sn/advent_of_code/blob/master/2025/cpp/day_03a.cpp) that probably have overlaps to Zig.
- A Python solution that [simplifies Part I logic and uses recursion for Part II](https://www.reddit.com/user/_san4d_/).
- A Go solution that seems to do [some interesting math stuff](https://github.com/craigalodon/adventofcode2025/blob/main/cmd/daythree/main.go). Not sure how much applies to Zig, but worth a look:

### Part II

Now, you need to make the largest joltage by turning on exactly twelve batteries within each bank. The only difference is that now there will be 12 digits in each bank's joltage output instead of two.

The solution to the test case is `3121910778619`.

Clearing downstream values was key here (I lost a few cycles debugging this), but I also had a hard time with the algorithm. Perhaps because I was so focused on operating on/comparing to a literal slice? I'm not sure.

It was a good learning exercize in local memory management, and byte-level operations though.

> [!success] Solution: `173416889848394`
