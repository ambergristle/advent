const std = @import("std");
const utils = @import("../utils.zig");

// Part I
pub fn sumInvalidIDsA(input: []u8) !usize {
    var sum: usize = 0;

    var ranges = std.mem.splitScalar(u8, input, ',');

    while (ranges.next()) |range| {
        var ids = std.mem.splitScalar(u8, range, '-');

        const start_int = try std.fmt.parseInt(usize, ids.next().?, 10);
        const end_int = try std.fmt.parseInt(usize, ids.next().?, 10);

        var buf: [256]u8 = undefined;
        for (start_int..end_int + 1) |num| {
            const str = try std.fmt.bufPrint(&buf, "{}", .{num});
            if (@mod(str.len, 2) != 0) continue;

            const mid = str.len / 2;

            if (!std.mem.eql(u8, str[0..mid], str[mid..])) {
                continue;
            }

            sum += num;
        }
    }

    return sum;
}

// Part I (Old?)
// fn sumInvalidIDs(input_path: []const u8) !usize {
//     var gpa = std.heap.GeneralPurposeAllocator(.{ .thread_safe = true }){};
//     defer if (gpa.deinit() == .leak) {
//         std.log.err("memory leak", .{});
//     };

//     const allocator = gpa.allocator();
//     const buff = try files.readFile(allocator, input_path);
//     defer allocator.free(buff);

//     var sum: usize = 0;

//     var ranges = std.mem.splitScalar(u8, buff, ',');
//     while (ranges.next()) |range| {
//         var ids = std.mem.splitScalar(u8, range, '-');

//         const start = ids.next().?;
//         const end = ids.next().?;

//         const start_int = try std.fmt.parseInt(usize, start, 10);
//         const end_int = try std.fmt.parseInt(usize, end, 10);

//         var buf: [256]u8 = undefined;
//         range_loop: for (start_int..end_int + 1) |num| {
//             const str = try std.fmt.bufPrint(&buf, "{}", .{num});

//             if (@rem(str.len, 2) != 0) continue;

//             if (2 == str.len) {
//                 if (str[0] != str[1]) continue;
//             } else {
//                 const half = str.len / 2;
//                 for (0..half) |i| {
//                     const j = half + i;
//                     if (str[i] != str[j]) {
//                         continue :range_loop;
//                     }
//                 }
//             }

//             sum += num;
//         }
//     }

//     return sum;
// }

// Part II
pub fn sumInvalidIDsB(input: []u8) !u64 {
    var sum: u64 = 0;

    var ranges = std.mem.splitScalar(u8, input, ',');

    while (ranges.next()) |range| {
        var bounds = std.mem.splitScalar(u8, range, '-');

        const sid = bounds.next().?;
        const eid = bounds.next().?;

        // if (std.mem.endsWith(u8, eid, {})) {
        //     std.debug.print("{s}\n", .{eid});
        // }

        const start = try std.fmt.parseInt(u64, sid, 10);
        const end = try std.fmt.parseInt(u64, eid, 10);
        // std.debug.print("{d} {d}\n", .{ start, end });
        var buff: [256]u8 = undefined;
        id_loop: for (start..end + 1) |num| {
            const str = try std.fmt.bufPrint(&buff, "{}", .{num});
            for (1..(str.len / 2 + 1)) |i| {
                const slice = str[0..i];
                const count = std.mem.count(u8, str, slice);

                const expected = @as(f64, @floatFromInt(str.len)) / @as(f64, @floatFromInt(slice.len));

                if (@as(f64, @floatFromInt(count)) == expected) {
                    sum += num;
                    continue :id_loop;
                }
            }
        }
    }

    return sum;
}
