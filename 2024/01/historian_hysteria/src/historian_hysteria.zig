const std = @import("std");
const Allocator = std.mem.Allocator;
const ArrayList = std.ArrayList;
const string = []const u8;

/// Task 1 - Calculate the distance of the two given lists.
///
/// Arguments:
///   - `contents`: Input file contents.
///   - `main_allocator`: Base allocator for everything.
///
/// Returns:
///   - Distance of the two lists.
pub fn list_distance(contents: string, main_allocator: Allocator) !u32 {
    var arena = std.heap.ArenaAllocator.init(main_allocator);
    defer arena.deinit();

    const allocator = arena.allocator();
    const list1, const list2 = try parse_lists(contents, allocator);

    std.mem.sort(i32, list1.items, {}, std.sort.asc(i32));
    std.mem.sort(i32, list2.items, {}, std.sort.asc(i32));

    var distance: u32 = 0;
    for (list1.items, list2.items) |num1, num2| {
        distance += @abs(num1 - num2);
    }

    return distance;
}

/// Task 2 - Calculate the similarity of the two given lists.
///
/// Arguments:
///   - `contents`: Input file contents.
///   - `main_allocator`: Base allocator for everything.
///
/// Returns:
///   - Similarity of the two lists.
pub fn list_similarity(contents: string, main_allocator: Allocator) !i32 {
    var arena = std.heap.ArenaAllocator.init(main_allocator);
    defer arena.deinit();

    const allocator = arena.allocator();
    const list1, const list2 = try parse_lists(contents, allocator);

    var similarity: i32 = 0;
    for (list1.items) |num| {
        const occurances: i32 = @intCast(std.mem.count(i32, list2.items, &[1]i32{num}));
        similarity += num * occurances;
    }

    return similarity;
}

// -------------------------------------------------------------------------- \\

/// Parse the file contents into two list with integer values.
///
/// Arguments:
///   - `contents`: Input file contents.
///   - `allocator`: Allocator for the containers.
///
/// Returns:
///   - Two array lists with integers.
fn parse_lists(contents: string, allocator: Allocator) !struct { ArrayList(i32), ArrayList(i32) } {
    var list1 = ArrayList(i32).init(allocator);
    var list2 = ArrayList(i32).init(allocator);

    var lines = std.mem.tokenize(u8, contents, "\r\n");
    while (lines.next()) |line| {
        var num_iter = std.mem.tokenize(u8, line, " ");
        if (num_iter.next()) |first| {
            try list1.append(try std.fmt.parseInt(i32, first, 10));
        }
        if (num_iter.next()) |second| {
            try list2.append(try std.fmt.parseInt(i32, second, 10));
        }
    }

    return .{ list1, list2 };
}
