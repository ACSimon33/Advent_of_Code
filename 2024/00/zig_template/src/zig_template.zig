const std = @import("std");
const Allocator = std.mem.Allocator;
const ArrayList = std.ArrayList;
const string = []const u8;

/// Task 1 -
///
/// Arguments:
///   - `contents`: Input file contents.
///   - `main_allocator`: Base allocator for everything.
///
/// Returns:
///   - Solution for task 1.
pub fn solution_1(contents: string, main_allocator: Allocator) !i32 {
    var arena = std.heap.ArenaAllocator.init(main_allocator);
    defer arena.deinit();

    const allocator = arena.allocator();
    _ = try parse(contents, allocator);

    return 0;
}

/// Task 2 -
///
/// Arguments:
///   - `contents`: Input file contents.
///   - `main_allocator`: Base allocator for everything.
///
/// Returns:
///   - Solution for task 2.
pub fn solution_2(contents: string, main_allocator: Allocator) !i32 {
    var arena = std.heap.ArenaAllocator.init(main_allocator);
    defer arena.deinit();

    const allocator = arena.allocator();
    _ = try parse(contents, allocator);

    return 1;
}

// -------------------------------------------------------------------------- \\

/// Parse the file contents into a list of reports.
///
/// Arguments:
///   - `contents`: Input file contents.
///   - `main_allocator`: Base allocator for everything.
///   - `allocator`: Allocator for the containers.
///
/// Returns:
///   - Array list of report objects.
fn parse(contents: string, allocator: Allocator) !void {
    _ = contents;
    _ = allocator;

    return;
}
