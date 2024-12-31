const std = @import("std");
const Allocator = std.mem.Allocator;
const ArrayList = std.ArrayList;
const HashMap = std.AutoArrayHashMap;
const string = []const u8;

/// Task 1 -
///
/// Arguments:
///   - `contents`: Input file contents.
///   - `main_allocator`: Base allocator for everything.
///
/// Returns:
///   - Solution for task 1.
pub fn number_of_keys(contents: string, robots: usize, main_allocator: Allocator) !usize {
    var arena = std.heap.ArenaAllocator.init(main_allocator);
    defer arena.deinit();

    const allocator = arena.allocator();
    const codes = try parse(contents, allocator);

    var complexity: usize = 0;
    for (codes.items) |code| {
        const amount_of_keys = try code.count_keys_for_last_robot(robots, allocator);
        // std.debug.print("{}\n", .{amount_of_keys});
        complexity += amount_of_keys * code.value;
    }

    return complexity;
}

// -------------------------------------------------------------------------- \\

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

    fn move_to(self: Key, next: Key) []const Key {
        switch (self) {
            Key.zero => {
                switch (next) {
                    Key.zero => return &[_]Key{Key.A},
                    Key.one => return &[_]Key{ Key.up, Key.left, Key.A },
                    Key.two => return &[_]Key{ Key.up, Key.A },
                    Key.three => return &[_]Key{ Key.up, Key.right, Key.A },
                    Key.four => return &[_]Key{ Key.up, Key.up, Key.left, Key.A },
                    Key.five => return &[_]Key{ Key.up, Key.up, Key.A },
                    Key.six => return &[_]Key{ Key.up, Key.up, Key.right, Key.A },
                    Key.seven => return &[_]Key{ Key.up, Key.up, Key.up, Key.left, Key.A },
                    Key.eight => return &[_]Key{ Key.up, Key.up, Key.up, Key.A },
                    Key.nine => return &[_]Key{ Key.up, Key.up, Key.up, Key.right, Key.A },
                    Key.A => return &[_]Key{ Key.right, Key.A },
                    else => unreachable,
                }
            },
            Key.one => {
                switch (next) {
                    Key.zero => return &[_]Key{ Key.right, Key.down, Key.A },
                    Key.one => return &[_]Key{Key.A},
                    Key.two => return &[_]Key{ Key.right, Key.A },
                    Key.three => return &[_]Key{ Key.right, Key.right, Key.A },
                    Key.four => return &[_]Key{ Key.up, Key.A },
                    Key.five => return &[_]Key{ Key.up, Key.right, Key.A },
                    Key.six => return &[_]Key{ Key.up, Key.right, Key.right, Key.A },
                    Key.seven => return &[_]Key{ Key.up, Key.up, Key.A },
                    Key.eight => return &[_]Key{ Key.up, Key.up, Key.right, Key.A },
                    Key.nine => return &[_]Key{ Key.up, Key.up, Key.right, Key.right, Key.A },
                    Key.A => return &[_]Key{ Key.right, Key.right, Key.down, Key.A },
                    else => unreachable,
                }
            },
            Key.two => {
                switch (next) {
                    Key.zero => return &[_]Key{ Key.down, Key.A },
                    Key.one => return &[_]Key{ Key.left, Key.A },
                    Key.two => return &[_]Key{Key.A},
                    Key.three => return &[_]Key{ Key.right, Key.A },
                    Key.four => return &[_]Key{ Key.left, Key.up, Key.A },
                    Key.five => return &[_]Key{ Key.up, Key.A },
                    Key.six => return &[_]Key{ Key.up, Key.right, Key.A },
                    Key.seven => return &[_]Key{ Key.left, Key.up, Key.up, Key.A },
                    Key.eight => return &[_]Key{ Key.up, Key.up, Key.A },
                    Key.nine => return &[_]Key{ Key.up, Key.up, Key.right, Key.A },
                    Key.A => return &[_]Key{ Key.right, Key.down, Key.A },
                    else => unreachable,
                }
            },
            Key.three => {
                switch (next) {
                    Key.zero => return &[_]Key{ Key.left, Key.down, Key.A },
                    Key.one => return &[_]Key{ Key.left, Key.left, Key.A },
                    Key.two => return &[_]Key{ Key.left, Key.A },
                    Key.three => return &[_]Key{Key.A},
                    Key.four => return &[_]Key{ Key.left, Key.left, Key.up, Key.A },
                    Key.five => return &[_]Key{ Key.left, Key.up, Key.A },
                    Key.six => return &[_]Key{ Key.up, Key.A },
                    Key.seven => return &[_]Key{ Key.left, Key.left, Key.up, Key.up, Key.A },
                    Key.eight => return &[_]Key{ Key.left, Key.up, Key.up, Key.A },
                    Key.nine => return &[_]Key{ Key.up, Key.up, Key.A },
                    Key.A => return &[_]Key{ Key.down, Key.A },
                    else => unreachable,
                }
            },
            Key.four => {
                switch (next) {
                    Key.zero => return &[_]Key{ Key.right, Key.down, Key.down, Key.A },
                    Key.one => return &[_]Key{ Key.down, Key.A },
                    Key.two => return &[_]Key{ Key.down, Key.right, Key.A },
                    Key.three => return &[_]Key{ Key.down, Key.right, Key.right, Key.A },
                    Key.four => return &[_]Key{Key.A},
                    Key.five => return &[_]Key{ Key.right, Key.A },
                    Key.six => return &[_]Key{ Key.right, Key.right, Key.A },
                    Key.seven => return &[_]Key{ Key.up, Key.A },
                    Key.eight => return &[_]Key{ Key.up, Key.right, Key.A },
                    Key.nine => return &[_]Key{ Key.up, Key.right, Key.right, Key.A },
                    Key.A => return &[_]Key{ Key.right, Key.right, Key.down, Key.down, Key.A },
                    else => unreachable,
                }
            },
            Key.five => {
                switch (next) {
                    Key.zero => return &[_]Key{ Key.down, Key.down, Key.A },
                    Key.one => return &[_]Key{ Key.left, Key.down, Key.A },
                    Key.two => return &[_]Key{ Key.down, Key.A },
                    Key.three => return &[_]Key{ Key.down, Key.right, Key.A },
                    Key.four => return &[_]Key{ Key.left, Key.A },
                    Key.five => return &[_]Key{Key.A},
                    Key.six => return &[_]Key{ Key.right, Key.A },
                    Key.seven => return &[_]Key{ Key.left, Key.up, Key.A },
                    Key.eight => return &[_]Key{ Key.up, Key.A },
                    Key.nine => return &[_]Key{ Key.up, Key.right, Key.A },
                    Key.A => return &[_]Key{ Key.right, Key.down, Key.down, Key.A },
                    else => unreachable,
                }
            },
            Key.six => {
                switch (next) {
                    Key.zero => return &[_]Key{ Key.left, Key.down, Key.down, Key.A },
                    Key.one => return &[_]Key{ Key.left, Key.left, Key.down, Key.A },
                    Key.two => return &[_]Key{ Key.left, Key.down, Key.A },
                    Key.three => return &[_]Key{ Key.down, Key.A },
                    Key.four => return &[_]Key{ Key.left, Key.left, Key.A },
                    Key.five => return &[_]Key{ Key.left, Key.A },
                    Key.six => return &[_]Key{Key.A},
                    Key.seven => return &[_]Key{ Key.left, Key.left, Key.up, Key.A },
                    Key.eight => return &[_]Key{ Key.left, Key.up, Key.A },
                    Key.nine => return &[_]Key{ Key.up, Key.A },
                    Key.A => return &[_]Key{ Key.down, Key.down, Key.A },
                    else => unreachable,
                }
            },
            Key.seven => {
                switch (next) {
                    Key.zero => return &[_]Key{ Key.right, Key.down, Key.down, Key.down, Key.A },
                    Key.one => return &[_]Key{ Key.down, Key.down, Key.A },
                    Key.two => return &[_]Key{ Key.down, Key.down, Key.right, Key.A },
                    Key.three => return &[_]Key{ Key.down, Key.down, Key.right, Key.right, Key.A },
                    Key.four => return &[_]Key{ Key.down, Key.A },
                    Key.five => return &[_]Key{ Key.down, Key.right, Key.A },
                    Key.six => return &[_]Key{ Key.down, Key.right, Key.right, Key.A },
                    Key.seven => return &[_]Key{Key.A},
                    Key.eight => return &[_]Key{ Key.right, Key.A },
                    Key.nine => return &[_]Key{ Key.right, Key.right, Key.A },
                    Key.A => return &[_]Key{ Key.right, Key.right, Key.down, Key.down, Key.down, Key.A },
                    else => unreachable,
                }
            },
            Key.eight => {
                switch (next) {
                    Key.zero => return &[_]Key{ Key.down, Key.down, Key.down, Key.A },
                    Key.one => return &[_]Key{ Key.left, Key.down, Key.down, Key.A },
                    Key.two => return &[_]Key{ Key.down, Key.down, Key.A },
                    Key.three => return &[_]Key{ Key.down, Key.down, Key.right, Key.A },
                    Key.four => return &[_]Key{ Key.left, Key.down, Key.A },
                    Key.five => return &[_]Key{ Key.down, Key.A },
                    Key.six => return &[_]Key{ Key.right, Key.down, Key.A },
                    Key.seven => return &[_]Key{ Key.left, Key.A },
                    Key.eight => return &[_]Key{Key.A},
                    Key.nine => return &[_]Key{ Key.right, Key.A },
                    Key.A => return &[_]Key{ Key.right, Key.down, Key.down, Key.down, Key.A },
                    else => unreachable,
                }
            },
            Key.nine => {
                switch (next) {
                    Key.zero => return &[_]Key{ Key.left, Key.down, Key.down, Key.down, Key.A },
                    Key.one => return &[_]Key{ Key.left, Key.left, Key.down, Key.down, Key.A },
                    Key.two => return &[_]Key{ Key.left, Key.down, Key.down, Key.A },
                    Key.three => return &[_]Key{ Key.down, Key.down, Key.A },
                    Key.four => return &[_]Key{ Key.left, Key.left, Key.down, Key.A },
                    Key.five => return &[_]Key{ Key.left, Key.down, Key.A },
                    Key.six => return &[_]Key{ Key.down, Key.A },
                    Key.seven => return &[_]Key{ Key.left, Key.left, Key.A },
                    Key.eight => return &[_]Key{ Key.left, Key.A },
                    Key.nine => return &[_]Key{Key.A},
                    Key.A => return &[_]Key{ Key.down, Key.down, Key.down, Key.A },
                    else => unreachable,
                }
            },
            Key.A => {
                switch (next) {
                    Key.zero => return &[_]Key{ Key.left, Key.A },
                    Key.one => return &[_]Key{ Key.up, Key.left, Key.left, Key.A },
                    Key.two => return &[_]Key{ Key.left, Key.up, Key.A },
                    Key.three => return &[_]Key{ Key.up, Key.A },
                    Key.four => return &[_]Key{ Key.up, Key.up, Key.left, Key.left, Key.A },
                    Key.five => return &[_]Key{ Key.left, Key.up, Key.up, Key.A },
                    Key.six => return &[_]Key{ Key.up, Key.up, Key.A },
                    Key.seven => return &[_]Key{ Key.up, Key.up, Key.up, Key.left, Key.left, Key.A },
                    Key.eight => return &[_]Key{ Key.left, Key.up, Key.up, Key.up, Key.A },
                    Key.nine => return &[_]Key{ Key.up, Key.up, Key.up, Key.A },
                    Key.A => return &[_]Key{Key.A},
                    Key.left => return &[_]Key{ Key.down, Key.left, Key.left, Key.A },
                    Key.right => return &[_]Key{ Key.down, Key.A },
                    Key.up => return &[_]Key{ Key.left, Key.A },
                    Key.down => return &[_]Key{ Key.left, Key.down, Key.A },
                }
            },
            Key.left => {
                switch (next) {
                    Key.left => return &[_]Key{Key.A},
                    Key.right => return &[_]Key{ Key.right, Key.right, Key.A },
                    Key.up => return &[_]Key{ Key.right, Key.up, Key.A },
                    Key.down => return &[_]Key{ Key.right, Key.A },
                    Key.A => return &[_]Key{ Key.right, Key.right, Key.up, Key.A },
                    else => unreachable,
                }
            },
            Key.right => {
                switch (next) {
                    Key.left => return &[_]Key{ Key.left, Key.left, Key.A },
                    Key.right => return &[_]Key{Key.A},
                    Key.up => return &[_]Key{ Key.left, Key.up, Key.A },
                    Key.down => return &[_]Key{ Key.left, Key.A },
                    Key.A => return &[_]Key{ Key.up, Key.A },
                    else => unreachable,
                }
            },
            Key.up => {
                switch (next) {
                    Key.left => return &[_]Key{ Key.down, Key.left, Key.A },
                    Key.right => return &[_]Key{ Key.down, Key.right, Key.A },
                    Key.up => return &[_]Key{Key.A},
                    Key.down => return &[_]Key{ Key.down, Key.A },
                    Key.A => return &[_]Key{ Key.right, Key.A },
                    else => unreachable,
                }
            },
            Key.down => {
                switch (next) {
                    Key.left => return &[_]Key{ Key.left, Key.A },
                    Key.right => return &[_]Key{ Key.right, Key.A },
                    Key.up => return &[_]Key{ Key.up, Key.A },
                    Key.down => return &[_]Key{Key.A},
                    Key.A => return &[_]Key{ Key.up, Key.right, Key.A },
                    else => unreachable,
                }
            },
        }

        unreachable;
    }

    fn print(self: Key) void {
        switch (self) {
            Key.zero => std.debug.print("0", .{}),
            Key.one => std.debug.print("1", .{}),
            Key.two => std.debug.print("2", .{}),
            Key.three => std.debug.print("3", .{}),
            Key.four => std.debug.print("4", .{}),
            Key.five => std.debug.print("5", .{}),
            Key.six => std.debug.print("6", .{}),
            Key.seven => std.debug.print("7", .{}),
            Key.eight => std.debug.print("8", .{}),
            Key.nine => std.debug.print("9", .{}),
            Key.A => std.debug.print("A", .{}),
            Key.left => std.debug.print("<", .{}),
            Key.right => std.debug.print(">", .{}),
            Key.up => std.debug.print("^", .{}),
            Key.down => std.debug.print("v", .{}),
        }
    }
};

const Code = struct {
    keys: ArrayList(Key),
    value: usize,

    fn count_keys_for_last_robot(self: Code, robots: usize, allocator: Allocator) !usize {
        var cache = HashMap(KeyHash, usize).init(allocator);
        defer cache.deinit();
        return try count_keys(self.keys.items, robots, &cache);
    }

    fn print(self: Code) void {
        for (self.keys.items) |key| {
            key.print();
        }
        std.debug.print("\n", .{});
    }
};

const KeyHash = struct {
    current_key: Key,
    next_key: Key,
    robots: usize,
};

fn count_keys(keys: []const Key, robots: usize, cache: *HashMap(KeyHash, usize)) !usize {
    if (robots == 0) {
        return keys.len;
    }

    // std.debug.print("{any}\n\n", .{cache.values()});

    var amount_of_keys: usize = 0;
    var current_key = Key.A;
    for (keys) |next_key| {
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

    return amount_of_keys;
}

/// Parse the file contents into a list of reports.
///
/// Arguments:
///   - `contents`: Input file contents.
///   - `allocator`: Allocator for the containers.
///
/// Returns:
///   - Array list of report objects.
fn parse(contents: string, allocator: Allocator) !ArrayList(Code) {
    var codes = ArrayList(Code).init(allocator);

    var lines = std.mem.tokenize(u8, contents, "\r\n");
    while (lines.next()) |line| {
        var keys = ArrayList(Key).init(allocator);
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
