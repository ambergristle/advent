const std = @import("std");

// Part I
pub fn sumUnblocked(input: *[]u8) !u16 {
    var sum: u16 = 0;

    // could do something with storing prev adjacency count
    // rather than re-counting
    var prev: []const u8 = &.{};
    var rows = std.mem.splitScalar(u8, input.*, '\n');
    while (rows.next()) |row| {
        // i think this is a bredth-first search
        // i'm looking for everything at X before continuing
        // but i'm not exiting
        for (0..row.len) |i| {
            if ('.' == row[i]) {
                continue;
            }

            var count: u64 = 0;

            const start = if (i > 0) i - 1 else i;
            const end = if (i < row.len - 1) i + 2 else i + 1;

            if (prev.len > 0) {
                count += std.mem.count(u8, prev[start..end], "@");
            }

            count += std.mem.count(u8, row[start..end], "@") - 1;

            if (count < 4) {
                if (rows.peek()) |next| {
                    count += std.mem.count(u8, next[start..end], "@");
                }
            }

            if (count < 4) {
                sum += 1;
            }
        }

        prev = row;
    }

    return sum;
}

fn rollToInt(value: u8) u8 {
    return if ('@' == value) 1 else 0;
}

pub fn _sumUnblocked(input: *[]u8) !u16 {
    var sum: u16 = 0;

    var prev: []const u8 = &.{};
    var rows = std.mem.splitScalar(u8, input.*, '\n');
    while (rows.next()) |row| {
        // var slice: [10]u8 = .{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };

        for (0..row.len) |i| {
            if ('.' == row[i]) {
                // slice[i] = '.';
                continue;
            }

            var count: u16 = 0;

            if (prev.len > 0) {
                if (i > 0) {
                    count += rollToInt(prev[i - 1]);
                }

                count += rollToInt(prev[i]);

                if (i < prev.len - 1) {
                    count += rollToInt(prev[i + 1]);
                }
            }

            if (i > 0) {
                count += rollToInt(row[i - 1]);
            }

            if (i < row.len - 1) {
                count += rollToInt(row[i + 1]);
            }

            if (rows.peek()) |next| {
                if (i > 0) {
                    count += rollToInt(next[i - 1]);
                }

                count += rollToInt(next[i]);

                if (i < next.len - 1) {
                    count += rollToInt(next[i + 1]);
                }
            }

            if (count < 4) {
                // slice[i] = count + 48;
                sum += 1;
            } else {
                // slice[i] = 'x';
            }
        }
        // std.debug.print("{s}\n", .{slice});
        prev = row;
    }

    return sum;
}

test "printing department: part i" {
    const input =
        \\..@@.@@@@.
        \\@@@.@.@.@@
        \\@@@@@.@.@@
        \\@.@@@@..@.
        \\@@.@@@@.@@
        \\.@@@@@@@.@
        \\.@.@.@.@@@
        \\@.@@@.@@@@
        \\.@@@@@@@@.
        \\@.@.@@@.@.
    ;

    var buff: [input.len]u8 = undefined;
    var slice = try std.fmt.bufPrint(&buff, "{s}", .{input});

    const sum = try sumUnblocked(&slice);
    try std.testing.expectEqual(@as(u16, 13), sum);
}

// Part II
fn whatever(matrix: std.ArrayList([]u8)) !u16 {
    var sum: u16 = 0;

    // do i need this? does it work?
    for (matrix.items, 0..) |row, i| {
        for (0..row.len) |j| {
            if ('@' != row[j]) {
                continue;
            }

            var count: u64 = 0;

            const start = if (j > 0) j - 1 else j;
            const end = if (j < row.len - 1) j + 2 else j + 1;

            if (i > 0) {
                count += std.mem.count(u8, matrix.items[i - 1][start..end], "@");
            }

            count += std.mem.count(u8, matrix.items[i][start..end], "@") - 1;

            if (count < 4 and i < matrix.items.len - 1) {
                count += std.mem.count(u8, matrix.items[i + 1][start..end], "@");
            }

            if (count < 4) {
                sum += 1;
                matrix.items[i][j] = 'x';
            }
        }

        std.debug.print("{s}\n", .{matrix.items[i]});
    }

    std.debug.print("\n \n", .{});

    if (0 == sum) {
        return sum;
    } else {
        return sum + try whatever(matrix);
    }
}

pub fn sumUnblockedRecursive(allocator: std.mem.Allocator, input: *[]u8) !u16 {
    var rows = std.mem.splitScalar(u8, input.*, '\n');

    const row_count = std.mem.count(u8, input.*, "\n") + 1;
    const line_len = rows.peek().?.len;

    const buf = try allocator.alloc(u8, line_len * row_count);
    defer allocator.free(buf);

    var matrix = try std.ArrayList([]u8).initCapacity(allocator, row_count);
    defer matrix.deinit(allocator);

    var i: usize = 0;
    while (rows.next()) |row| {
        const row_start = i * line_len;

        @memcpy(buf[row_start .. row_start + line_len], row);
        try matrix.append(allocator, buf[row_start .. row_start + line_len]);

        i += 1;
    }

    for (matrix.items) |r| {
        std.debug.print("{s}\n", .{r});
    }

    std.debug.print("->\n", .{});

    return whatever(matrix);
}

test "printing department: part ii" {
    const input =
        \\..@@.@@@@.
        \\@@@.@.@.@@
        \\@@@@@.@.@@
        \\@.@@@@..@.
        \\@@.@@@@.@@
        \\.@@@@@@@.@
        \\.@.@.@.@@@
        \\@.@@@.@@@@
        \\.@@@@@@@@.
        \\@.@.@@@.@.
    ;

    var buff: [input.len]u8 = undefined;
    var slice = try std.fmt.bufPrint(&buff, "{s}", .{input});

    // pass alloc?
    const sum = sumUnblockedRecursive(std.testing.allocator, &slice);
    try std.testing.expectEqual(@as(u16, 43), sum);
}

// what would depth-first even look like?
// go to first cell, if roll
// check if roll can be removed
// if not, check if others can be removed
