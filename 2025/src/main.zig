const std = @import("std");
const utils = @import("utils.zig");
const lobby = @import("lobby/lobby.zig");
// const foo = @import("foo");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{ .thread_safe = true }){};
    defer if (gpa.deinit() == .leak) {
        std.log.err("memory leak", .{});
    };

    const allocator = gpa.allocator();

    const buff = try utils.readFileToBuffer(allocator, "data/test.txt");
    defer allocator.free(buff);

    // oof
    const sum = try lobby.highestOrderedPairC(buff);
    std.debug.print("sum: {d}\n", .{sum});
}

// pub fn main() !void {
//     // Prints to stderr, ignoring potential errors.
//     std.debug.print("All your {s} are belong to us.\n", .{"codebase"});
//     try foo.bufferedPrint();
// }

// test "simple test" {
//     const gpa = std.testing.allocator;
//     var list: std.ArrayList(i32) = .empty;
//     defer list.deinit(gpa); // Try commenting this out and see if zig detects the memory leak!
//     try list.append(gpa, 42);
//     try std.testing.expectEqual(@as(i32, 42), list.pop());
// }

// test "fuzz example" {
//     const Context = struct {
//         fn testOne(context: @This(), input: []const u8) anyerror!void {
//             _ = context;
//             // Try passing `--fuzz` to `zig build test` and see if it manages to fail this test case!
//             try std.testing.expect(!std.mem.eql(u8, "canyoufindme", input));
//         }
//     };
//     try std.testing.fuzz(Context{}, Context.testOne, .{});
// }
