const std = @import("std");
const Allocator = std.mem.Allocator;
const ArrayList = std.ArrayList;
const HashMap = std.AutoArrayHashMap;
const string = []const u8;

/// Task 1 - Evolve all secret numbers until the given time is reached and
///          calculate the sum of all secret number.
///
/// Arguments:
///   - `contents`: Input file contents.
///   - `time`: Number of time steps to simulate.
///   - `main_allocator`: Base allocator for everything.
///
/// Returns:
///   - Sum of all secret numbers.
pub fn sum_of_secret_numbers(contents: string, time: usize, main_allocator: Allocator) !u64 {
    var arena = std.heap.ArenaAllocator.init(main_allocator);
    defer arena.deinit();

    const allocator = arena.allocator();
    const secret_numbers = try parse(contents, allocator);

    for (0..time) |_| {
        for (secret_numbers.items) |*secret_number| {
            secret_number.* = evolve_secret_number(secret_number.*);
        }
    }

    var sum: u64 = 0;
    for (secret_numbers.items) |secret_number| {
        sum += secret_number;
    }

    return sum;
}

/// Task 2 - Calculate the amount of bananas the monkeys can purchase. Evolve
///          all secret numbers to the given time and keep track of the
///          differences in banana prices (ones digit of secret number). Keep
///          track of all sub sequences of length 4 that occur the first time
///          and add up the amount of bananas the monkey would buy if that
///          sub sequence is used as a buy trigger.
///
/// Arguments:
///   - `contents`: Input file contents.
///   - `time`: Number of time steps to simulate.
///   - `main_allocator`: Base allocator for everything.
///
/// Returns:
///   - Maximum amount of banaas the monkeys can purchase.
pub fn max_bananas(contents: string, time: usize, main_allocator: Allocator) !u64 {
    var arena = std.heap.ArenaAllocator.init(main_allocator);
    defer arena.deinit();

    const allocator = arena.allocator();
    const secret_numbers = try parse(contents, allocator);

    var secret_sequence = try allocator.alloc(u64, time);
    var diff_sequence = try allocator.alloc(i32, time);

    var sub_sequences = HashMap(i32, u64).init(allocator);
    var sub_sequence_occurances = HashMap(i32, void).init(allocator);
    for (secret_numbers.items) |secret_number| {
        // Record banana prices and differences for a single buyer
        var current_number = secret_number;
        for (0..time) |i| {
            const next = evolve_secret_number(current_number);
            diff_sequence[i] = @as(i32, @intCast(next % 10)) - @as(i32, @intCast(current_number % 10));
            current_number = next;
            secret_sequence[i] = current_number % 10;
        }

        // Search for sub sequences of length 4 and increment banana amounts
        sub_sequence_occurances.clearRetainingCapacity();
        for (0..time - 3) |i| {
            var hashed_sub_sequence = diff_sequence[i];
            hashed_sub_sequence += (diff_sequence[i + 1] << 8);
            hashed_sub_sequence += (diff_sequence[i + 2] << 16);
            hashed_sub_sequence += (diff_sequence[i + 3] << 24);
            if (!sub_sequence_occurances.contains(hashed_sub_sequence)) {
                const entry = try sub_sequences.getOrPutValue(hashed_sub_sequence, 0);
                entry.value_ptr.* += secret_sequence[i + 3];
                try sub_sequence_occurances.put(hashed_sub_sequence, {});
            }
        }
    }

    var bananas: u64 = 0;
    for (sub_sequences.values()) |b| {
        bananas = @max(bananas, b);
    }

    return bananas;
}

// -------------------------------------------------------------------------- \\

/// Evolve the secret numebr according to the rules.
///
/// Arguments:
///   - `secret_number`: The current secret number.
///
/// Returns:
///   - The next secret numbers.
fn evolve_secret_number(secret_number: u64) u64 {
    var next = secret_number;
    next ^= (next << 6);
    next %= (1 << 24);
    next ^= (next >> 5);
    next %= (1 << 24);
    next ^= (next << 11);
    next %= (1 << 24);
    return next;
}

/// Parse the file contents into a list of initial secret numbers.
///
/// Arguments:
///   - `contents`: Input file contents.
///   - `allocator`: Allocator for the containers.
///
/// Returns:
///   - Array list of secret numbers.
fn parse(contents: string, allocator: Allocator) !ArrayList(u64) {
    var secret_numbers = ArrayList(u64).init(allocator);

    var lines = std.mem.tokenize(u8, contents, "\r\n");
    while (lines.next()) |line| {
        try secret_numbers.append(try std.fmt.parseInt(u64, line, 10));
    }

    return secret_numbers;
}
