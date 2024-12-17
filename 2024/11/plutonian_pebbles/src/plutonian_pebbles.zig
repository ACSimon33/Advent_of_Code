const std = @import("std");
const Allocator = std.mem.Allocator;
const HashMap = std.AutoArrayHashMap;
const string = []const u8;

/// Task 1 & 2 - Simulate the given amount of blinks and return the amount of
///              stones after all blinks. Use two sets of stones which are
///              swapped after each blink to reduce the amount of reallocations
///              of the used Hashmaps.
///
/// Arguments:
///   - `contents`: Input file contents.
///   - `main_allocator`: Base allocator for everything.
///   - `blinks`: Amount of blinks.
///
/// Returns:
///   - The amount of stones after all blinks.
pub fn amount_of_stones(contents: string, blinks: usize, main_allocator: Allocator) !u64 {
    var arena = std.heap.ArenaAllocator.init(main_allocator);
    defer arena.deinit();

    const allocator = arena.allocator();
    var stones = try parse(contents, allocator);
    var new_stones = HashMap(u64, u64).init(allocator);

    for (0..blinks) |_| {
        try blink(stones, &new_stones);
        std.mem.swap(HashMap(u64, u64), &stones, &new_stones);
    }

    var stones_count: u64 = 0;
    for (stones.values()) |amount| {
        stones_count += amount;
    }

    return stones_count;
}

// -------------------------------------------------------------------------- \\

/// Simulate 'one blink'. For each unique stone number apply the rules and
/// increment the amounts of the new stones.
///
/// Arguments:
///   - `stones`: Current set of stone numbers and amounts.
///   - `new_stones`: The new stones after the blink.
fn blink(stones: HashMap(u64, u64), new_stones: *HashMap(u64, u64)) !void {
    new_stones.clearRetainingCapacity();
    for (stones.keys()) |stone| {
        const amount = stones.getPtr(stone).?.*;
        if (stone == 0) {
            try increment_amount(new_stones, 1, amount);
            continue;
        }
        const digits = std.math.log10(stone) + 1;
        if (digits % 2 == 0) {
            const power_of_10 = try std.math.powi(u64, 10, digits / 2);
            const right_stone = stone % power_of_10;
            const left_stone = (stone - right_stone) / power_of_10;

            try increment_amount(new_stones, right_stone, amount);
            try increment_amount(new_stones, left_stone, amount);
        } else {
            try increment_amount(new_stones, stone * 2024, amount);
        }
    }
}

/// Parse the file contents into a initial map of stones with their number
/// mapped to the amount of the same stone.
///
/// Arguments:
///   - `contents`: Input file contents.
///   - `main_allocator`: Base allocator for everything.
///   - `allocator`: Allocator for the containers.
///
/// Returns:
///   - Map of stone numbers to stone amounts.
fn parse(contents: string, allocator: Allocator) !HashMap(u64, u64) {
    var stones = HashMap(u64, u64).init(allocator);

    var numbers = std.mem.tokenize(u8, contents, " ");
    while (numbers.next()) |num| {
        try increment_amount(&stones, try std.fmt.parseInt(u64, num, 10), 1);
    }

    return stones;
}

/// Increment the amount of a given stone in the map by the given amount. Create
/// a new entry if the stone didn't exist before.
///
/// Arguments:
///   - `contents`: Input file contents.
///   - `main_allocator`: Base allocator for everything.
///   - `allocator`: Allocator for the containers.
///
/// Returns:
///   - Map of stone numbers to stone amounts.
fn increment_amount(stones: *HashMap(u64, u64), stone: u64, increment: u64) !void {
    const entry = try stones.*.getOrPutValue(stone, increment);
    if (entry.found_existing) {
        entry.value_ptr.* += increment;
    }
}
