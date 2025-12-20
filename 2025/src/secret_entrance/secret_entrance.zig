const std = @import("std");
const utils = @import("../utils.zig");

// Part I
fn countZeroedA(input_path: []const u8) !i16 {
    const ticks = 100;

    // Read input file
    var gpa = std.heap.GeneralPurposeAllocator(.{ .thread_safe = true }){};
    defer if (gpa.deinit() == .leak) {
        std.log.err("memory leak", .{});
    };

    const allocator = gpa.allocator();
    const buff = try utils.readFile(allocator, input_path);
    defer allocator.free(buff);

    var cursor: i32 = 50;
    var zeroed: i16 = 0;
    // Iterate over lines and compute new position
    var lines = std.mem.split(u8, buff, "\n");
    while (lines.next()) |line| {
        const distance = try std.fmt.parseInt(i32, line[1..], 10);
        const absolute_distance = try std.math.mod(i32, distance, ticks);
        const direction: i32 = if (76 == line[0]) -1 else 1;

        const new_position = cursor + (absolute_distance * direction);
        cursor = try std.math.mod(i32, new_position, ticks);

        if (0 == cursor) {
            zeroed += 1;
        }
    }

    return zeroed;
}

// Part II
fn countZeroedB(input_path: []const u8) !i32 {
    const ticks = 100;

    var gpa = std.heap.GeneralPurposeAllocator(.{ .thread_safe = true }){};
    defer if (gpa.deinit() == .leak) {
        std.log.err("memory leak", .{});
    };

    const allocator = gpa.allocator();
    const buff = try utils.readFile(allocator, input_path);
    defer allocator.free(buff);

    var cursor: i32 = 50;
    var zeroed: i32 = 0;

    var lines = std.mem.split(u8, buff, "\n");
    while (lines.next()) |line| {
        const distance = try std.fmt.parseInt(i32, line[1..], 10);

        // calculate how many times passes across zero before moving
        const rotations = try std.math.divFloor(i32, distance, ticks);
        zeroed += rotations;

        // how far it moves
        const real_distance = try std.math.mod(i32, distance, ticks);
        const direction: i32 = if (76 == line[0]) -1 else 1;
        const new_position = cursor + (real_distance * direction);
        // whether it crosses or lands on zero
        if (0 != cursor and (new_position <= 0 or new_position >= 100)) {
            zeroed += 1;
        }

        cursor = try std.math.mod(i32, new_position, ticks);
    }

    return zeroed;
}
