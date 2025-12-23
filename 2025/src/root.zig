const std = @import("std");

pub fn readFileToBuffer(allocator: std.mem.Allocator, path: []const u8) ![]u8 {
    // .safety = true
    // std.Io.File.OpenError
    const file = try std.fs.cwd().openFile(path, .{ .mode = .read_only });
    defer file.close();

    const stat = try file.stat();
    const buff = try file.readToEndAlloc(allocator, stat.size);
    return buff;
}
