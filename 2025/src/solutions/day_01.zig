const std = @import("std");
const utils = @import("utils");

const ticks: i16 = 100;

// Part I
pub fn sumLandZero(input: *[]u8) !u16 {
    // integer sizes determined by input
    // integer overflow
    var cursor: i32 = 50;
    var count: u16 = 0;

    var turns = std.mem.splitScalar(u8, input.*, '\n');
    while (turns.next()) |rotation| {

        // use mod to get relative distance
        const relative_distance = @mod(try std.fmt.parseInt(u16, rotation[1..], 10), ticks);

        // this is more readable than collapsing into math
        if ('R' == rotation[0]) {
            cursor += @as(i32, relative_distance);
        } else {
            cursor -= @as(i32, relative_distance);
        }

        // only need to maybe track this separately in p2
        // use mod to re-relativize
        cursor = @mod(cursor, ticks);
        if (0 == cursor) {
            count += 1;
        }
    }

    return count;
}

test "secret entrance: part i" {
    const input =
        \\L68
        \\L30
        \\R48
        \\L5
        \\R60
        \\L55
        \\L1
        \\L99
        \\R14
        \\L82
    ;

    var buff: [input.len]u8 = undefined;
    var slice = try std.fmt.bufPrint(&buff, "{s}", .{input});

    const sum = try sumLandZero(&slice);
    try std.testing.expectEqual(@as(u16, 3), sum);
}

// first implementation
fn sumLandZero_old(input: *[]u8) !u16 {
    var cursor: i32 = 50;
    var count: i16 = 0;

    var rotations = std.mem.splitScalar(u8, input.*, '\n');
    while (rotations.next()) |rotation| {
        const distance = try std.fmt.parseInt(i32, rotation[1..], 10);
        const relative_distance = try std.math.mod(i32, distance, ticks);

        const direction: i32 = if (76 == rotation[0]) -1 else 1;
        const new_position = cursor + (relative_distance * direction);

        cursor = try std.math.mod(i32, new_position, ticks);
        if (0 == cursor) {
            count += 1;
        }
    }

    return count;
}

// Part II
pub fn sumPassZero(input: *[]u8) !u16 {
    var cursor: i32 = 50;
    var count: u16 = 0;

    // Iterate over lines, computing each new position
    var rotations = std.mem.splitScalar(u8, input.*, '\n');
    while (rotations.next()) |rotation| {
        const distance = try std.fmt.parseInt(u16, rotation[1..], 10);

        // How many times passes across zero before moving
        const full_rotations = try std.math.divFloor(u16, distance, ticks);
        count += full_rotations;

        const relative_distance = @as(i32, distance % ticks);

        if ('R' == rotation[0]) {
            cursor += relative_distance;
            if (cursor > 99) {
                count += 1;
                cursor -= 100;
            }
        } else {
            const prev = cursor;
            cursor -= relative_distance;
            if (cursor < 0) {
                if (0 != prev) {
                    count += 1;
                }
                cursor += 100;
            }

            if (0 == cursor) {
                count += 1;
            }
        }
    }

    return count;
}

test "secret entrance: part ii" {
    const input =
        \\L68
        \\L30
        \\R48
        \\L5
        \\R60
        \\L55
        \\L1
        \\L99
        \\R14
        \\L82
    ;

    var buff: [input.len]u8 = undefined;
    var slice = try std.fmt.bufPrint(&buff, "{s}", .{input});

    const sum = try sumPassZero(&slice);
    try std.testing.expectEqual(@as(u16, 6), sum);
}

fn sumPassZero_old(input: *[]u8) !u16 {
    var cursor: i32 = 50;
    var count: u16 = 0;

    var rotations = std.mem.splitScalar(u8, input.*, '\n');
    while (rotations.next()) |rotation| {
        const distance = try std.fmt.parseInt(u16, rotation[1..], 10);
        const relative_distance = try std.math.mod(u16, distance, ticks);

        // calculate how many times passes across zero before moving
        const full_rotations = try std.math.divFloor(u16, distance, ticks);
        count += @as(i32, full_rotations);

        const direction: i32 = if (76 == rotation[0]) -1 else 1;
        const new_position = cursor + (relative_distance * direction);

        // whether it crosses or lands on zero
        if (0 != cursor and (new_position <= 0 or new_position >= 100)) {
            count += 1;
        }

        cursor = try std.math.mod(i32, new_position, ticks);
    }

    return count;
}
