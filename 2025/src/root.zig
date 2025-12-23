const std = @import("std");

const day_01 = @import("solutions/day_01.zig");
const day_05 = @import("solutions/day_05.zig");

pub fn readFileToBuffer(allocator: std.mem.Allocator, path: []const u8) ![]u8 {
    // .safety = true
    // std.Io.File.OpenError
    const file = try std.fs.cwd().openFile(path, .{ .mode = .read_only });
    defer file.close();

    const stat = try file.stat();
    const buff = try file.readToEndAlloc(allocator, stat.size);
    return buff;
}

test "day 01 - part 1" {
    var alloc = std.testing.allocator;

    var buff = try readFileToBuffer(alloc, "data/day-01.txt");
    defer alloc.free(buff);

    const result = try day_01.sumLandZero(&buff);
    try std.testing.expectEqual(@as(u16, 995), result);
}

test "day 01 - part 2" {
    var alloc = std.testing.allocator;

    var buff = try readFileToBuffer(alloc, "data/day-01.txt");
    defer alloc.free(buff);

    const result = try day_01.sumPassZero(&buff);
    try std.testing.expectEqual(@as(u16, 5847), result);
}

test "day 05 - part 1" {
    var alloc = std.testing.allocator;

    var buff = try readFileToBuffer(alloc, "data/day-05.txt");
    defer alloc.free(buff);

    const result = try day_05.sumIncluded(alloc, &buff);
    try std.testing.expectEqual(@as(u64, 821), result);
}

test "day 05 - part 2" {
    var alloc = std.testing.allocator;

    var buff = try readFileToBuffer(alloc, "data/day-05.txt");
    defer alloc.free(buff);

    const result = try day_05.sumRanges(alloc, &buff);
    try std.testing.expectEqual(@as(u64, 344771884978261), result);
}
