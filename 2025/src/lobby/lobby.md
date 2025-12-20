## 02 - Lobby

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

> [!success] Solution: `17403`

### Part II

Now, you need to make the largest joltage by turning on exactly twelve batteries within each bank. The only difference is that now there will be 12 digits in each bank's joltage output instead of two.

The solution to the test case is `3121910778619`.

> [!success] Solution: `173416889848394`
