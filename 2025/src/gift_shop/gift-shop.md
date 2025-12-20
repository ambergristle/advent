## 01 - Gift Shop

### Setup

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

The solution to the test case is `1227775554`.

```zig
const str = try std.fmt.bufPrint(&buf, "{}", .{num});
if (@mod(str.len, 2) != 0) continue;

const mid = str.len / 2;

if (!std.mem.eql(u8, str[0..mid], str[mid..])) {
    continue;
}

sum += num;
```

> [!success] Solution: `29818212493`

### Part II

Now, an ID is invalid if it is made only of some sequence of digits repeated at least twice. So, 12341234 (1234 two times), 123123123 (123 three times), 1212121212 (12 five times), and 1111111 (1 seven times) are all invalid IDs.

The solution to the test case is `4174379265`.

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

> [!success] Solution: `37432260594`
