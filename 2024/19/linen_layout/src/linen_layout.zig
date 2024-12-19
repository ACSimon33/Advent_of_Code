const std = @import("std");
const Allocator = std.mem.Allocator;
const ArrayList = std.ArrayList;
const string = []const u8;

/// Task 1 - Count how many of the designs can be matched with the provided
///          towels.
///
/// Arguments:
///   - `contents`: Input file contents.
///   - `main_allocator`: Base allocator for everything.
///
/// Returns:
///   - Number of possible designs.
pub fn possible_designs(contents: string, main_allocator: Allocator) !u64 {
    var arena = std.heap.ArenaAllocator.init(main_allocator);
    defer arena.deinit();

    const allocator = arena.allocator();
    const towels, const designs = try parse(contents, allocator);

    var possible: u64 = 0;
    for (designs.items) |design| {
        possible += @intFromBool(match_design(design, towels, 0));
    }

    return possible;
}

/// Task 1 - Calculate the number of possible towel combinations to create the
///          designs.
///
/// Arguments:
///   - `contents`: Input file contents.
///   - `main_allocator`: Base allocator for everything.
///
/// Returns:
///   - Number of towel combinations to create all designs
pub fn towel_combinations(contents: string, main_allocator: Allocator) !u64 {
    var arena = std.heap.ArenaAllocator.init(main_allocator);
    defer arena.deinit();

    const allocator = arena.allocator();
    const towels, const designs = try parse(contents, allocator);

    var combinations: u64 = 0;
    var cache = ArrayList(?u64).init(allocator);
    for (designs.items) |design| {
        try cache.resize(design.len);
        @memset(cache.items, null);
        combinations += count_design_matches(design, towels, 0, cache);
    }

    return combinations;
}

// -------------------------------------------------------------------------- \\

/// Try to match the design with any combination of towels from the given index.
///
/// Arguments:
///   - `design`: The design to match.
///   - `towels`: List of available towels.
///   - `index`: The current index in the design string.
///
/// Returns:
///   - True if the design can be matched from the given index onwoards.
fn match_design(design: string, towels: ArrayList(string), index: usize) bool {
    if (index == design.len) {
        return true;
    }

    for (towels.items) |towel| {
        if (std.mem.startsWith(u8, design[index..], towel)) {
            if (match_design(design, towels, index + towel.len)) {
                return true;
            }
        }
    }

    return false;
}

/// Count the number of distinct towel combinations that can be used to create
/// the given design from the given index onwoards.
///
/// Arguments:
///   - `design`: The design to match.
///   - `towels`: List of available towels.
///   - `index`: The current index in the design string.
///   - `cache`: Cached results for all possible indices.
///
/// Returns:
///   - Number of ways the design can be matched from the given index onwoards.
fn count_design_matches(
    design: string,
    towels: ArrayList(string),
    index: usize,
    cache: ArrayList(?u64),
) u64 {
    if (index == design.len) {
        return 1;
    }
    if (cache.items[index]) |cached_result| {
        return cached_result;
    }

    var combinations: u64 = 0;
    for (towels.items) |towel| {
        if (std.mem.startsWith(u8, design[index..], towel)) {
            combinations += count_design_matches(design, towels, index + towel.len, cache);
        }
    }
    cache.items[index] = combinations;

    return combinations;
}

/// Parse the file contents into a list of towels and a list of designs.
///
/// Arguments:
///   - `contents`: Input file contents.
///   - `allocator`: Allocator for the containers.
///
/// Returns:
///   - Array lists of towel strings and design strings.
fn parse(contents: string, allocator: Allocator) !struct { ArrayList(string), ArrayList(string) } {
    var towels = ArrayList(string).init(allocator);
    var designs = ArrayList(string).init(allocator);

    var lines = std.mem.tokenize(u8, contents, "\n\r");
    var towel_iter = std.mem.split(u8, lines.next().?, ", ");
    while (towel_iter.next()) |towel| {
        try towels.append(towel);
    }

    while (lines.next()) |design| {
        try designs.append(design);
    }

    return .{ towels, designs };
}
