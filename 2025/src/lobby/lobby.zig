const std = @import("std");

// Part I
pub fn highestOrderedPair(input: []u8) !u16 {
    var lines = std.mem.splitSequence(u8, input, "\n");

    var joltage: u16 = 0;
    while (lines.next()) |line| {
        var slice: [2]u8 = .{ 0, 0 };

        for (line, 0..) |c, i| {
            if (0 == i) {
                slice[0] = c;
            } else if (line.len - 1 == i) {
                if (c > slice[1]) {
                    slice[1] = c;
                }
            } else {
                if (c > slice[0]) {
                    slice[0] = c;
                    slice[1] = 0;
                } else if (c > slice[1]) {
                    slice[1] = c;
                }
            }
        }

        joltage += try std.fmt.parseInt(u16, &slice, 10);
    }

    return joltage;
}

// Part II
const slice_length: usize = 12;

// pub fn highestOrderedPairB(input: []u8) !u80 {
//     var lines = std.mem.splitSequence(u8, input, "\n");

//     var joltage: u80 = 0;
//     while (lines.next()) |line| {
//         var slice: [slice_length]u8 = .{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };

//         var flag: usize = 0;

//         for (0..line.len) |i| {
//             const rem = line.len - i;
//             flag = if (rem < slice_length) (slice_length - rem) else 0;

//             for (flag..slice_length) |j| {
//                 if (line[i] > slice[j]) {
//                     slice[j] = line[i];
//                     break;
//                 }
//             }
//         }

//         std.debug.print("{s}\n", .{slice});
//         joltage += try std.fmt.parseInt(u80, &slice, 10);
//     }

//     return joltage;
// }

// pub fn highestOrderedPairC(input: []u8) !u80 {
//     var lines = std.mem.splitSequence(u8, input, "\n");

//     var joltage: u80 = 0;
//     while (lines.next()) |line| {
//         var slice: [slice_length]u8 = .{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };

//         var flag: usize = 0;
//         for (0..line.len) |i| {
//             const rem = line.len - i;

//             flag = if (rem <= slice_length) (slice_length - rem) else 0;
//             for (flag..slice_length) |j| {
//                 if (line[i] > slice[j]) {
//                     @memcpy(slice[j..], line[i + 1 .. i + slice[j..].len  1]);
//                     // slice[j] = line[i];
//                     break;
//                 }
//             }
//         }

//         std.debug.print("{s}\n", .{slice});
//         joltage += try std.fmt.parseInt(u80, &slice, 10);
//     }

//     return joltage;
// }

// 987654321111
// 811111111119
// 434234234278
// 888911112111

pub fn highestOrderedPairD(input: []u8) !u80 {
    var lines = std.mem.splitSequence(u8, input, "\n");

    var joltage: u80 = 0;
    while (lines.next()) |line| {
        var slice: [slice_length]u8 = .{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };
        const gap = line.len - slice_length;

        for (line, 0..) |c, i| {
            const start = if (i < gap) 0 else i - gap;
            const end = @min(i + 1, slice_length);
            for (start..end) |j| {
                if (c > slice[j]) {
                    slice[j] = c;
                    @memset(slice[j + 1 ..], 0);
                    break;
                }
            }
        }

        std.debug.print("{s}\n", .{slice});
        joltage += try std.fmt.parseInt(u80, &slice, 10);
    }

    return joltage;
}

// 6483266694748235893324353634344523834567333718239477213324541343624714732212276727733744455653544463

// 999777777777

// 993324353634344523834567333718239477213324541343624714732212276727733744455653544463
