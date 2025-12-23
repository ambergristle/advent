const std = @import("std");
const utils = @import("utils");

// Part I
pub fn sumDuplicateSequences(input: *[]u8) !u64 {
    // safest way to deal with usize
    var sum: u64 = 0;

    var ranges = std.mem.splitScalar(u8, input.*, ',');
    while (ranges.next()) |range| {
        var bounds = std.mem.splitScalar(u8, range, '-');

        const start = try std.fmt.parseInt(u64, bounds.next().?, 10);
        const end = try std.fmt.parseInt(u64, bounds.next().?, 10);

        var buff: [256]u8 = undefined;
        for (start..end + 1) |n| {
            const digits = try std.fmt.bufPrint(&buff, "{}", .{n});
            if (digits.len % 2 != 0) {
                continue;
            }

            const mid = digits.len / 2;
            // this loops through the arrays in parallel, which may
            // be more idiomatic than looping over the range?
            if (!std.mem.eql(u8, digits[0..mid], digits[mid..])) {
                continue;
            }

            sum += n;
        }
    }

    return sum;
}

test "gift shop: part i" {
    const input = "11-22,95-115,998-1012,1188511880-1188511890,222220-222224,1698522-1698528,446443-446449,38593856-38593862,565653-565659,824824821-824824827,2121212118-2121212124";

    var buff: [input.len]u8 = undefined;
    var slice = try std.fmt.bufPrint(&buff, "{s}", .{input});

    const sum = try sumDuplicateSequences(&slice);
    try std.testing.expectEqual(@as(u64, 1227775554), sum);
}

// Part II
pub fn sumRepeatedSequences(input: *[]u8) !u64 {
    var sum: u64 = 0;

    var ranges = std.mem.splitScalar(u8, input.*, ',');
    while (ranges.next()) |range| {
        var bounds = std.mem.splitScalar(u8, range, '-');

        const start = try std.fmt.parseInt(u64, bounds.next().?, 10);
        const end = try std.fmt.parseInt(u64, bounds.next().?, 10);

        var buff: [256]u8 = undefined;
        id_loop: for (start..end + 1) |n| {
            const digits = try std.fmt.bufPrint(&buff, "{}", .{n});
            for (1..(digits.len / 2 + 1)) |i| {
                const sequence = digits[0..i];

                const count = std.mem.count(u8, digits, sequence);
                const expected = @as(f16, @floatFromInt(digits.len)) / @as(f16, @floatFromInt(sequence.len));

                if (@as(f16, @floatFromInt(count)) == expected) {
                    sum += n;
                    continue :id_loop;
                }
            }
        }
    }

    return sum;
}

test "gift shop: part ii" {
    const input = "11-22,95-115,998-1012,1188511880-1188511890,222220-222224,1698522-1698528,446443-446449,38593856-38593862,565653-565659,824824821-824824827,2121212118-2121212124";

    var buff: [input.len]u8 = undefined;
    var slice = try std.fmt.bufPrint(&buff, "{s}", .{input});

    const sum = try sumRepeatedSequences(&slice);
    try std.testing.expectEqual(@as(u64, 4174379265), sum);
}
