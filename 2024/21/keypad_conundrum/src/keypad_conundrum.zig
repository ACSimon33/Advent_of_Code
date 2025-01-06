const std = @import("std");
const Allocator = std.mem.Allocator;
const ArrayList = std.ArrayList;
const HashMap = std.AutoArrayHashMap;
const string = []const u8;

/// Task 1 & 2 - Calculate the amount of keystrokes we need to enter that the
///              last robot enters the given codes in the numerical keypad.
///              Multiply that number by the numeric value of the code to get
///              the complexities of the codes.
///
/// Arguments:
///   - `contents`: Input file contents.
///   - `robots`: Amount of robots in the chain.
///   - `main_allocator`: Base allocator for everything.
///
/// Returns:
///   - Sum of code complexities.
pub fn code_complexities(contents: string, robots: usize, main_allocator: Allocator) !usize {
    var arena = std.heap.ArenaAllocator.init(main_allocator);
    defer arena.deinit();

    const allocator = arena.allocator();
    const codes = try parse(contents, allocator);

    var complexity: usize = 0;
    for (codes.items) |code| {
        const amount_of_keys = try code.count_keys_for_last_robot(robots, allocator);
        complexity += amount_of_keys * code.value;
    }

    return complexity;
}

// -------------------------------------------------------------------------- \\

/// A key on the keypads with their position in 2D space (x,y).
const Key = enum {
    zero,
    one,
    two,
    three,
    four,
    five,
    six,
    seven,
    eight,
    nine,
    A,
    left,
    right,
    up,
    down,
    gap,

    const position = [16][2]isize{
        [2]isize{ 1, 3 },
        [2]isize{ 0, 2 },
        [2]isize{ 1, 2 },
        [2]isize{ 2, 2 },
        [2]isize{ 0, 1 },
        [2]isize{ 1, 1 },
        [2]isize{ 2, 1 },
        [2]isize{ 0, 0 },
        [2]isize{ 1, 0 },
        [2]isize{ 2, 0 },
        [2]isize{ 2, 3 },
        [2]isize{ 0, 4 },
        [2]isize{ 2, 4 },
        [2]isize{ 1, 3 },
        [2]isize{ 1, 4 },
        [2]isize{ 0, 3 },
    };

    /// Return the x position of the key.
    ///
    /// Arguments:
    ///   - `self`: The key.
    ///
    /// Returns:
    ///   - The x position.
    fn x(self: Key) isize {
        return Key.position[@intFromEnum(self)][0];
    }
    /// Return the y position of the key.
    ///
    /// Arguments:
    ///   - `self`: The key.
    ///
    /// Returns:
    ///   - The y position.
    fn y(self: Key) isize {
        return Key.position[@intFromEnum(self)][1];
    }

    /// Return the moves necessary to move from one key to another.
    ///
    /// Arguments:
    ///   - `self`: The current key.
    ///   - `next`: The next key.
    ///
    /// Returns:
    ///   - Array of moves (keys on the directional keypad).
    fn move_to(self: Key, next: Key) []const ?Key {
        const Cache = struct {
            var moves: [16 * 16][6]?Key = undefined;
        };

        const idx: usize = @as(usize, @intFromEnum(self)) * 16 + @as(usize, @intFromEnum(next));
        if (Cache.moves[idx][0] == undefined) {
            get_moves(self, next, &Cache.moves[idx]);
        }
        return &Cache.moves[idx];
    }
};

/// Append the necessary horizontal moves to the move array.
///
/// Arguments:
///   - `from`: The starting position.
///   - `to`: The end position.
///   - `moves`: Container to store the moves (maximal 6).
///   - `idx`: The current index in the move array.
fn append_horizontal_moves(from: Key, to: Key, moves: *[6]?Key, idx: *usize) void {
    const n = to.x() - from.x();
    if (n > 0) {
        for (0..@intCast(n)) |i| {
            moves[idx.* + i] = Key.right;
        }
    } else if (n < 0) {
        for (0..@intCast(-n)) |i| {
            moves[idx.* + i] = Key.left;
        }
    }
    idx.* += @abs(n);
}

/// Append the necessary vertical moves to the move array.
///
/// Arguments:
///   - `from`: The starting position.
///   - `to`: The end position.
///   - `moves`: Container to store the moves (maximal 6).
///   - `idx`: The current index in the move array.
fn append_vertical_moves(from: Key, to: Key, moves: *[6]?Key, idx: *usize) void {
    const n = to.y() - from.y();
    if (n > 0) {
        for (0..@intCast(n)) |i| {
            moves[idx.* + i] = Key.down;
        }
    } else if (n < 0) {
        for (0..@intCast(-n)) |i| {
            moves[idx.* + i] = Key.up;
        }
    }
    idx.* += @abs(n);
}

/// Get the necessary moves to move from a given key to another one.
///
/// To get from one key to another we want to move in straight lines (maximal
/// one turn) to reduce the amount of necessary keys further up in the robot
/// chain. That means we are doing one set of horizontal moves and one set of
/// vertical moves. Due to the layout of the keypads we can find the following
/// rules:
///     - if we would move accross the gap in the keypad in one of the orderings,
///       do the other one.
///     - do movements to the left first
///     - do vertical movements second
///     - do movements to the right last
///
/// Arguments:
///   - `from`: The starting position.
///   - `to`: The end position.
///   - `moves`: Container to store the moves (maximal 6).
fn get_moves(from: Key, to: Key, moves: *[6]?Key) void {
    const n_x = to.x() - from.x();
    var idx: usize = 0;
    if ((n_x < 0 and !(to.x() == Key.gap.x() and from.y() == Key.gap.y())) or
        (to.y() == Key.gap.y() and from.x() == Key.gap.x()))
    {
        append_horizontal_moves(from, to, moves, &idx);
        append_vertical_moves(from, to, moves, &idx);
    } else {
        append_vertical_moves(from, to, moves, &idx);
        append_horizontal_moves(from, to, moves, &idx);
    }
    moves[idx] = Key.A;
    for ((idx + 1)..6) |i| {
        moves[i] = null;
    }
}

/// Hash used in memoization cache.
const KeyHash = struct {
    current_key: Key,
    next_key: Key,
    robots: usize,
};

/// Code containing the numeric keys and the numeric value
const Code = struct {
    keys: ArrayList(?Key),
    value: usize,

    /// Count the key presses that are necessary by the last robot to enter the
    /// codes's keys.
    ///
    /// Arguments:
    ///   - `self`: Input file contents.
    ///   - `allocator`: Allocator for the containers.
    ///
    /// Returns:
    ///   - Array list of codes (keys and numeric value).
    fn count_keys_for_last_robot(self: Code, robots: usize, allocator: Allocator) !usize {
        var cache = HashMap(KeyHash, usize).init(allocator);
        defer cache.deinit();
        return try count_keys(self.keys.items, robots, &cache);
    }
};

/// Count the keystrokes that are necessary given a list of keys and the amount
/// of robots in the chain. Use memoization to reduce the amount of redundant
/// work.
///
/// Arguments:
///   - `keys`: The list of keys we want to enter.
///   - `robots`: Amount of robots in the chain.
///   - `cache`: Cache of key amounts for memoization.
///
/// Returns:
///   - Amount of keystrokes.
fn count_keys(keys: []const ?Key, robots: usize, cache: *HashMap(KeyHash, usize)) !usize {
    if (robots == 0) {
        if (std.mem.indexOfScalar(?Key, keys, null)) |len| {
            return len;
        }
        return keys.len;
    }

    var amount_of_keys: usize = 0;
    var current_key = Key.A;
    for (keys) |next_key_maybe| {
        if (next_key_maybe) |next_key| {
            const hash = KeyHash{
                .current_key = current_key,
                .next_key = next_key,
                .robots = robots,
            };

            var amount: usize = undefined;
            if (cache.get(hash)) |value| {
                amount = value;
            } else {
                amount = try count_keys(
                    current_key.move_to(next_key),
                    robots - 1,
                    cache,
                );
                try cache.put(hash, amount);
            }

            amount_of_keys += amount;
            current_key = next_key;
        }
    }

    return amount_of_keys;
}

/// Parse the file contents into a list of codes.
///
/// Arguments:
///   - `contents`: Input file contents.
///   - `allocator`: Allocator for the containers.
///
/// Returns:
///   - Array list of codes (keys and numeric value).
fn parse(contents: string, allocator: Allocator) !ArrayList(Code) {
    var codes = ArrayList(Code).init(allocator);

    var lines = std.mem.tokenize(u8, contents, "\r\n");
    while (lines.next()) |line| {
        var keys = ArrayList(?Key).init(allocator);
        var value: usize = 0;

        for (line) |key| {
            const digit = std.fmt.charToDigit(key, 10) catch {
                try keys.append(Key.A);
                continue;
            };

            value *= 10;
            value += digit;

            try keys.append(@enumFromInt(digit));
        }
        try codes.append(Code{ .keys = keys, .value = value });
    }

    return codes;
}
