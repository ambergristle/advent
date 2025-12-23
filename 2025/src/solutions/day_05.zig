const std = @import("std");

const Range = struct {
    min: u64,
    max: u64,
};

pub fn sumIncluded(allocator: std.mem.Allocator, input: *[]u8) !u16 {
    var ranges = std.ArrayList(Range).empty;
    defer ranges.deinit(allocator);

    const delimiter_index = std.mem.indexOf(u8, input.*, "\n\n").?;

    // #region Init Ranges
    var range_lines = std.mem.splitScalar(u8, input.*[0..delimiter_index], '\n');
    while (range_lines.next()) |r| {
        var bounds = std.mem.splitScalar(u8, r, '-');

        try ranges.append(allocator, .{
            .min = try std.fmt.parseInt(u64, bounds.next().?, 10),
            .max = try std.fmt.parseInt(u64, bounds.next().?, 10),
        });
    }
    // #endregion

    var count: u16 = 0;

    // #region Validate IDs
    var id_lines = std.mem.splitScalar(u8, input.*[delimiter_index + 2 ..], '\n');
    while (id_lines.next()) |digits| {
        const id = try std.fmt.parseInt(u64, digits, 10);

        for (ranges.items) |range| {
            if (id >= range.min and id <= range.max) {
                count += 1;
                break;
            }
        }
    }
    // #endregion

    return count;
}

test "cafeteria: part i" {
    const input =
        \\3-5
        \\10-14
        \\16-20
        \\12-18
        \\
        \\1
        \\5
        \\8
        \\11
        \\17
        \\32
    ;

    var buff: [input.len]u8 = undefined;
    var slice = try std.fmt.bufPrint(&buff, "{s}", .{input});

    const sum = try sumIncluded(std.testing.allocator, &slice);
    try std.testing.expectEqual(@as(u16, 3), sum);
}

pub fn rangeAsc(_: void, a: Range, b: Range) bool {
    return a.min < b.min;
}

pub fn sumRanges(allocator: std.mem.Allocator, input: *[]u8) !u64 {
    var ranges = std.ArrayList(Range).empty;
    defer ranges.deinit(allocator);

    const delimiter_index = std.mem.indexOf(u8, input.*, "\n\n").?;

    var range_lines = std.mem.splitScalar(u8, input.*[0..delimiter_index], '\n');
    while (range_lines.next()) |r| {
        var bounds = std.mem.splitScalar(u8, r, '-');

        try ranges.append(allocator, .{
            .min = try std.fmt.parseInt(u64, bounds.next().?, 10),
            .max = try std.fmt.parseInt(u64, bounds.next().?, 10),
        });
    }

    std.mem.sort(Range, ranges.items, {}, comptime rangeAsc);

    var flat = std.ArrayList(Range).empty;
    defer flat.deinit(allocator);

    try flat.append(allocator, ranges.items[0]);
    for (ranges.items[1..]) |range| {
        const r_min = range.min;
        const r_max = range.max;

        const prev_index = flat.items.len - 1;
        // const p_min = flat.items[prev_index].min;
        const p_max = flat.items[prev_index].max;

        // 10 14
        // 12 18

        if (r_min <= p_max) {
            // this start overlaps w last end
            if (r_max > p_max) {
                flat.items[prev_index].max = r_max;
                continue;
            }
        } else {
            // this start is after last (need to ad new el)
            try flat.append(allocator, range);
        }
    }

    var sum: u64 = 0;
    for (flat.items) |s| {
        sum += s.max - s.min + 1;
    }

    return sum;
}

test "cafeteria: part iI" {
    const input =
        \\3-5
        \\16-20
        \\10-14
        \\12-18
        \\
        \\1
        \\5
        \\8
        \\11
        \\17
        \\32
    ;

    var buff: [input.len]u8 = undefined;
    var slice = try std.fmt.bufPrint(&buff, "{s}", .{input});

    const sum = try sumRanges(std.testing.allocator, &slice);
    try std.testing.expectEqual(@as(u16, 14), sum);
}
