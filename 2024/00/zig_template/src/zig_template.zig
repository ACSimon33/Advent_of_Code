const std = @import("std");
const Allocator = std.mem.Allocator;
const string = []const u8;

/// Task 1 -
///
/// Arguments:
///   - `contents`: Input file contents.
///
/// Returns:
///   - Solution for task 1.
pub fn solution_1(contents: string) !i32 {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const allocator = arena.allocator();
    _ = try parse(contents, allocator);

    return 0;
}

/// Task 2 -
///
/// Arguments:
///   - `contents`: Input file contents.
///
/// Returns:
///   - Solution for task 2.
pub fn solution_2(contents: string) !i32 {
    const lines = std.mem.split(u8, contents, "\n");
    _ = lines;

    return 1;
}

// -------------------------------------------------------------------------- \\

/// Parse the file contents into a list of reports.
///
/// Arguments:
///   - `contents`: Input file contents.
///   - `allocator`: Allocator for the containers.
///
/// Returns:
///   - Array list of report objects.
fn parse(contents: string, allocator: Allocator) !void {
    _ = contents;
    _ = allocator;

    return;
}
