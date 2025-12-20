const std = @import("std");
const testing = std.testing;

// #region Reading Files

pub fn readFileToBuffer(allocator: std.mem.Allocator, path: []const u8) ![]u8 {
    // .safety = true
    // std.Io.File.OpenError
    const file = try std.fs.cwd().openFile(path, .{ .mode = .read_only });
    defer file.close();

    const stat = try file.stat();
    const buff = try file.readToEndAlloc(allocator, stat.size);
    return buff;
}

pub fn readFile(input_path: []const u8) !u8 {
    var gpa = std.heap.GeneralPurposeAllocator(.{ .thread_safe = true }){};
    defer if (gpa.deinit() == .leak) {
        std.log.err("memory leak", .{});
    };

    const allocator = gpa.allocator();
    const buff = try readFileToBuffer(allocator, input_path);
    defer allocator.free(buff);

    return buff;
}

// #endregion

// #region Handling Requests

pub fn fetchAdventInput(day: *const [1:0]u8) !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    const allocator = gpa.allocator();

    var client = std.http.Client{ .allocator = allocator };
    defer client.deinit();

    const uri = try std.Uri.parse("https://adventofcode.com/2025/day/" ++ day ++ "/input");

    var req = try client.request(.GET, uri, .{});
    defer req.deinit();

    try req.sendBodiless();

    var redirect_buffer: [1024]u8 = undefined;
    var response = try req.receiveHead(&redirect_buffer);

    var headers = response.head.iterateHeaders();
    while (headers.next()) |header| {
        std.debug.print("{s}: {s}\n", .{ header.name, header.value });
    }

    std.debug.print("---\n", .{});

    // try std.testing.expectEqual(response.head.status, .ok);
    const body = try response.reader(&.{}).allocRemaining(allocator, .unlimited);
    defer allocator.free(body);

    std.debug.print("{s}", .{body});

    // return body;
}

// pub fn fetchAdventInput(day: *const [2:0]u8) ![]u8 {
//     const page_allocator = std.heap.PageAllocator();

//     var arena = std.heap.ArenaAllocator.init(page_allocator);
//     defer _ = arena.deinit();

//     const allocator = arena.allocator();

//     var client = std.http.Client{ .allocator = allocator };
//     defer client.deinit();

//     const uri = "https://adventofcode.com/2025/day/" ++ day ++ "/input";

//     const response_body = std.ArrayList(u8).initCapacity(gpa: Allocator, num: usize);

//     const res = try client.fetch(.{
//         .method = .GET,
//         .location = .{ .url = uri },
//         // .extra_headers
//         // .payload
//         .response_writer = response_body.writer(self: *Aligned(u8), gpa: Allocator)
//         // .response_storage = .{ .dynamic = &response_body },
//     });

//     return response_body;
// }

// const Method = enum { GET };

// const RequestOptions = struct {
//     url: []const u8,
//     method: Method,
// };

// fn fetch(options: RequestOptions) !u8 {
//     const uri = try std.Uri.parse(options.url);
// }

// var req = try client.open(.GET, uri, .{ .server_header_buffer = &buf });

// fn fetch(url: []u8, method: std.http.Method) ![]u8 {
//     const uri = try std.Uri.parse(url);
//     var req = client.request(method, uri);

//     var client = std.http.Client{ .allocator = gpa.allocator() };
//     defer client.deinit();

//     client.request(method: Method, uri: Uri, options: RequestOptions);
//     client.connect(host: []const u8, port: u16, protocol: Protocol);
//     client.connectProxied(proxy: *Proxy, proxied_host: []const u8, proxied_port: u16);

//     var headers: [4096]u8 = undefined;
// }

// #endregion

// #region Sorting

fn quickSort(arr: []const u8) []const u8 {
    if (arr.len > 2) {
        var left: []u8 = &.{};
        var right: []u8 = &.{};

        // pick a pivot
        const pivot = arr[arr.len - 1];

        for (arr, 0..) |el, j| {
            // if pivot
            if (el < pivot) {
                left = left ++ .{el};
            } else if (el > pivot) {
                right = right ++ .{el};
            } else if (arr.len - 1 != j) {
                left = left ++ .{el};
            }
        }

        return quickSort(left) ++ .{pivot} ++ quickSort(right);
    }
}

// #endregion
