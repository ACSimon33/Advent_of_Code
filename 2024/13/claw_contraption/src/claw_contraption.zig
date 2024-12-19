const std = @import("std");
const Allocator = std.mem.Allocator;
const ArrayList = std.ArrayList;
const string = []const u8;
const assert = std.debug.assert;

/// Task 1 - Calculate the sum of the costs to win all possible prices.
///
/// For each claw machine solve the 2x2 linear system:
///     [ Ax Bx ]   [ na ]   [ price_x ]
///     [ Ay By ] * [ nb ] = [ price_y ]
///
/// Only consider integer solutions! The cost is `3 * na + nb`.
///
/// Arguments:
///   - `contents`: Input file contents.
///   - `main_allocator`: Base allocator for everything.
///   - `offset`: An offset for the price coordinates.
///
/// Returns:
///   - Cost to win all possible prices.
pub fn cost_to_win_all_prizes(contents: string, offset: i64, main_allocator: Allocator) !i64 {
    var arena = std.heap.ArenaAllocator.init(main_allocator);
    defer arena.deinit();

    const allocator = arena.allocator();
    const machines = try parse(contents, allocator);

    var cost: i64 = 0;
    for (machines.items) |claw| {
        const determinant = claw.a[0] * claw.b[1] - claw.a[1] * claw.b[0];
        const n_a = claw.b[1] * (claw.price[0] + offset) - claw.b[0] * (claw.price[1] + offset);

        if (@rem(n_a, determinant) != 0) {
            continue;
        }

        const n_b = -claw.a[1] * (claw.price[0] + offset) + claw.a[0] * (claw.price[1] + offset);
        if (@rem(n_b, determinant) != 0) {
            continue;
        }

        cost += 3 * @divExact(n_a, determinant) + @divExact(n_b, determinant);
    }

    return cost;
}

// -------------------------------------------------------------------------- \\

/// ClawMachine with parameters for button A and B and the location of the price.
const ClawMachine = struct {
    a: [2]i64,
    b: [2]i64,
    price: [2]i64,
};

/// Parse the file contents into a list of claw machines.
///
/// Arguments:
///   - `contents`: Input file contents.
///   - `allocator`: Allocator for the containers.
///
/// Returns:
///   - Array list of claw machine objects.
fn parse(contents: string, allocator: Allocator) !ArrayList(ClawMachine) {
    var machines = ArrayList(ClawMachine).init(allocator);

    var lines = std.mem.tokenize(u8, contents, "\r\n");
    var idx: usize = 0;
    while (lines.next()) |line| : (idx += 1) {
        switch (idx % 3) {
            0 => {
                try machines.append(ClawMachine{
                    .a = undefined,
                    .b = undefined,
                    .price = undefined,
                });

                var coords = std.mem.split(u8, line, ", ");
                const a_x = parse_int(coords.next().?, "Button A: X+".len);
                const a_y = parse_int(coords.next().?, "Y+".len);
                machines.items[machines.items.len - 1].a = @Vector(2, i64){ a_x, a_y };
            },
            1 => {
                var coords = std.mem.split(u8, line, ", ");
                const b_x = parse_int(coords.next().?, "Button B: X+".len);
                const b_y = parse_int(coords.next().?, "Y+".len);
                machines.items[machines.items.len - 1].b = @Vector(2, i64){ b_x, b_y };
            },
            2 => {
                var coords = std.mem.split(u8, line, ", ");
                const p_x = parse_int(coords.next().?, "Prize: X=".len);
                const p_y = parse_int(coords.next().?, "Y=".len);
                machines.items[machines.items.len - 1].price = @Vector(2, i64){ p_x, p_y };
            },
            else => {
                assert(false);
            },
        }
    }

    return machines;
}

/// Parse a single positive integer of unknown length from the given position.
///
/// Arguments:
///   - `line`: The input string.
///   - `index`: The start index of the integer.
///
/// Returns:
///   - The integer.
fn parse_int(line: string, index: usize) i64 {
    var num: i64 = 0;
    var i = index;
    while (i < line.len) {
        const digit = std.fmt.parseInt(i64, &[1]u8{line[i]}, 10) catch {
            break;
        };
        num *= 10;
        num += digit;
        i += 1;
    }
    return num;
}
