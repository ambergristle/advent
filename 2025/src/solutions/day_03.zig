const std = @import("std");
const utils = @import("utils");

// Part I
pub fn sumMaxOrderedPairs(input: *[]u8) !u16 {
    // better than splitSequence, which is looking for a slice
    var sequences = std.mem.splitScalar(u8, input.*, '\n');

    var sum: u16 = 0;
    while (sequences.next()) |sequence| {
        var pair: [2]u8 = .{ 0, 0 };

        // oof
        for (sequence, 0..) |digit, i| {
            if (0 == i) {
                pair[0] = digit;
            } else if (sequence.len - 1 == i) {
                if (digit > pair[1]) {
                    pair[1] = digit;
                }
            } else {
                if (digit > pair[0]) {
                    pair[0] = digit;
                    pair[1] = 0;
                } else if (digit > pair[1]) {
                    pair[1] = digit;
                }
            }
        }

        sum += try std.fmt.parseInt(u16, &pair, 10);
    }

    return sum;
}

test "lobby: part i" {
    const input =
        \\987654321111111
        \\811111111111119
        \\234234234234278
        \\818181911112111
    ;

    var buff: [input.len]u8 = undefined;
    var slice = try std.fmt.bufPrint(&buff, "{s}", .{input});

    const sum = try sumMaxOrderedPairs(&slice);
    try std.testing.expectEqual(@as(u16, 357), sum);
}

// Part II
pub fn sumMaxDozen(input: *[]u8) !u64 {
    var sum: u64 = 0;

    var sequences = std.mem.splitScalar(u8, input.*, '\n');
    const slice_length: usize = 12;
    while (sequences.next()) |sequence| {
        var slice: [slice_length]u8 = .{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };
        const gap = sequence.len - slice_length;

        for (sequence, 0..) |digit, i| {
            const start = if (i < gap) 0 else i - gap;
            const end = @min(i + 1, slice_length);

            for (start..end) |j| {
                if (digit > slice[j]) {
                    slice[j] = digit;
                    @memset(slice[j + 1 ..], 0);
                    break;
                }
            }
        }

        sum += try std.fmt.parseInt(u64, &slice, 10);
    }

    return sum;
}

test "lobby: part ii" {
    const input =
        \\987654321111111
        \\811111111111119
        \\234234234234278
        \\818181911112111
    ;

    var buff: [input.len]u8 = undefined;
    var slice = try std.fmt.bufPrint(&buff, "{s}", .{input});

    const sum = try sumMaxDozen(&slice);
    try std.testing.expectEqual(@as(u64, 3121910778619), sum);
}
