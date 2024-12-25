const std = @import("std");
const Allocator = std.mem.Allocator;
const ArrayList = std.ArrayList;
const string = []const u8;

/// Task 1 - Calculate the number of possible key lock combinations.
///
/// Arguments:
///   - `contents`: Input file contents.
///   - `main_allocator`: Base allocator for everything.
///
/// Returns:
///   - Number of unique key and lock combinations.
pub fn key_lock_combinations(contents: string, main_allocator: Allocator) !usize {
    var arena = std.heap.ArenaAllocator.init(main_allocator);
    defer arena.deinit();

    const allocator = arena.allocator();
    const keys, const locks = try parse_keys_and_locks(contents, allocator);

    var key_lock_pairs: usize = keys.items.len * locks.items.len;
    for (keys.items) |key| {
        for (locks.items) |lock| {
            for (0..5) |i| {
                if (key[i] + lock[i] > 5) {
                    key_lock_pairs -= 1;
                    break;
                }
            }
        }
    }

    return key_lock_pairs;
}

// -------------------------------------------------------------------------- \\

/// Parse the file contents into lists of keys and locks. Keys and locks consist
/// of five values representing key heights and lock pin depths.
///
/// Arguments:
///   - `contents`: Input file contents.
///   - `allocator`: Allocator for the containers.
///
/// Returns:
///   - Array lists of keys and locks
fn parse_keys_and_locks(contents: string, allocator: Allocator) !struct { ArrayList([5]u4), ArrayList([5]u4) } {
    var keys = ArrayList([5]u4).init(allocator);
    var locks = ArrayList([5]u4).init(allocator);

    var lines = std.mem.tokenize(u8, contents, "\n\r");
    while (lines.next()) |_| {
        var key_or_lock = [5]u4{ 0, 0, 0, 0, 0 };
        for (0..5) |_| {
            const part = lines.next().?;
            for (0..5) |i| {
                if (part[i] == '#') {
                    key_or_lock[i] += 1;
                }
            }
        }

        // Use last line schema to differentiate between key and lock
        const id = lines.next().?[0];
        if (id == '#') {
            try keys.append(key_or_lock);
        } else {
            try locks.append(key_or_lock);
        }
    }

    return .{ keys, locks };
}
