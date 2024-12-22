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
pub fn solution_1(contents: string, min_shortcut: usize, main_allocator: Allocator) !u32 {
    var arena = std.heap.ArenaAllocator.init(main_allocator);
    defer arena.deinit();

    const allocator = arena.allocator();
    const racetrack = try parse(contents, allocator);

    var shortcuts: u32 = 0;
    for (racetrack.track.items, 0..) |position_1, distance1| {
        const x = position_1 % racetrack.width;
        const y = position_1 / racetrack.width;

        if (x > 1 and racetrack.grid.items[position_1 - 1] == null) {
            if (racetrack.grid.items[position_1 - 2]) |distance2| {
                if (distance2 > distance1 + min_shortcut + 1) {
                    shortcuts += 1;
                }
            }
        }

        if (x < racetrack.width - 2 and racetrack.grid.items[position_1 + 1] == null) {
            if (racetrack.grid.items[position_1 + 2]) |distance2| {
                if (distance2 > distance1 + min_shortcut + 1) {
                    shortcuts += 1;
                }
            }
        }

        if (y > 1 and racetrack.grid.items[position_1 - racetrack.width] == null) {
            if (racetrack.grid.items[position_1 - 2 * racetrack.width]) |distance2| {
                if (distance2 > distance1 + min_shortcut + 1) {
                    shortcuts += 1;
                }
            }
        }

        if (y < racetrack.height - 2 and racetrack.grid.items[position_1 + racetrack.width] == null) {
            if (racetrack.grid.items[position_1 + 2 * racetrack.width]) |distance2| {
                if (distance2 > distance1 + min_shortcut + 1) {
                    shortcuts += 1;
                }
            }
        }
    }

    return shortcuts;
}

/// Task 2 -
///
/// Arguments:
///   - `contents`: Input file contents.
///   - `main_allocator`: Base allocator for everything.
///
/// Returns:
///   - Solution for task 2.
pub fn solution_2(contents: string, min_shortcut: usize, main_allocator: Allocator) !usize {
    var arena = std.heap.ArenaAllocator.init(main_allocator);
    defer arena.deinit();

    const allocator = arena.allocator();
    const racetrack = try parse(contents, allocator);

    var shortcuts: u32 = 0;
    for (racetrack.track.items, 0..) |position_1, distance1| {
        const x = position_1 % racetrack.width;
        const y = position_1 / racetrack.width;

        for (0..21) |cheat_x| {
            if (x >= cheat_x) {
                const position_2 = position_1 - cheat_x;
                if (racetrack.grid.items[position_2]) |distance2| {
                    if (distance2 > distance1 + min_shortcut + cheat_x - 1) {
                        shortcuts += 1;
                    }
                }
                for (1..(21 - cheat_x)) |cheat_y| {
                    if (y >= cheat_y) {
                        const position_3 = position_2 - cheat_y * racetrack.width;
                        if (racetrack.grid.items[position_3]) |distance2| {
                            if (distance2 > distance1 + min_shortcut + cheat_x + cheat_y - 1) {
                                shortcuts += 1;
                            }
                        }
                    }

                    if (y + cheat_y <= racetrack.height - 1) {
                        const position_3 = position_2 + cheat_y * racetrack.width;
                        if (racetrack.grid.items[position_3]) |distance2| {
                            if (distance2 > distance1 + min_shortcut + cheat_x + cheat_y - 1) {
                                shortcuts += 1;
                            }
                        }
                    }
                }
            }
            if (cheat_x == 0) {
                continue;
            }

            if (x + cheat_x <= racetrack.width - 1) {
                const position_2 = position_1 + cheat_x;
                if (racetrack.grid.items[position_2]) |distance2| {
                    if (distance2 > distance1 + min_shortcut + cheat_x - 1) {
                        shortcuts += 1;
                    }
                }

                for (1..(21 - cheat_x)) |cheat_y| {
                    if (y >= cheat_y) {
                        const position_3 = position_2 - cheat_y * racetrack.width;
                        if (racetrack.grid.items[position_3]) |distance2| {
                            if (distance2 > distance1 + min_shortcut + cheat_x + cheat_y - 1) {
                                shortcuts += 1;
                            }
                        }
                    }

                    if (y + cheat_y <= racetrack.height - 1) {
                        const position_3 = position_2 + cheat_y * racetrack.width;
                        if (racetrack.grid.items[position_3]) |distance2| {
                            if (distance2 > distance1 + min_shortcut + cheat_x + cheat_y - 1) {
                                shortcuts += 1;
                            }
                        }
                    }
                }
            }
        }
    }

    return shortcuts;
}

// -------------------------------------------------------------------------- \\

const Racetrack = struct {
    track: ArrayList(usize),
    grid: ArrayList(?usize),
    width: usize,
    height: usize,

    fn init(width: usize, height: usize, allocator: Allocator) !Racetrack {
        var grid = ArrayList(?usize).init(allocator);
        try grid.resize(width * height);

        return Racetrack{
            .track = ArrayList(usize).init(allocator),
            .grid = grid,
            .width = width,
            .height = height,
        };
    }
};

/// Parse the file contents into a list of reports.
///
/// Arguments:
///   - `contents`: Input file contents.
///   - `allocator`: Allocator for the containers.
///
/// Returns:
///   - Array list of report objects.
fn parse(contents: string, allocator: Allocator) !Racetrack {
    var lines = std.mem.tokenize(u8, contents, "\r\n");
    const height: usize = @intCast(std.mem.count(u8, contents, &[1]u8{'\n'}) + 1);
    const width: usize = lines.peek().?.len;
    var racetrack = try Racetrack.init(width, height, allocator);

    var start: usize = undefined;
    var end: usize = undefined;
    var idx: usize = 0;
    while (lines.next()) |tiles| {
        for (tiles) |tile| {
            racetrack.grid.items[idx] = switch (tile) {
                '.', 'E', 'S' => 0,
                '#' => null,
                else => return error.UnknownTile,
            };
            if (tile == 'S') {
                start = idx;
            }
            if (tile == 'E') {
                end = idx;
            }
            idx += 1;
        }
    }

    try racetrack.track.append(start);
    var position = start;
    while (position != end) {
        const x = position % width;
        const y = position / width;

        var new_pos: usize = undefined;
        if (x > 0) {
            // std.debug.print("Left: {any}\n", .{racetrack.grid.items[position - 1]});
            if (racetrack.grid.items[position - 1]) |next| {
                if (next == 0 and position - 1 != start) {
                    new_pos = position - 1;
                    // std.debug.print("Left: {} {}\n", .{ position, new_pos });
                }
            }
        }
        if (x < width - 1) {
            // std.debug.print("Right: {any}\n", .{racetrack.grid.items[position + 1]});
            if (racetrack.grid.items[position + 1]) |next| {
                if (next == 0 and position + 1 != start) {
                    new_pos = position + 1;
                    // std.debug.print("Right: {} {}\n", .{ position, new_pos });
                }
            }
        }
        if (y > 0) {
            // std.debug.print("Up: {any}\n", .{racetrack.grid.items[position - width]});
            if (racetrack.grid.items[position - width]) |next| {
                if (next == 0 and position - width != start) {
                    new_pos = position - width;
                    // std.debug.print("Up: {} {}\n", .{ position, new_pos });
                }
            }
        }
        if (y < height - 1) {
            // std.debug.print("Down: {any}\n", .{racetrack.grid.items[position + width]});
            if (racetrack.grid.items[position + width]) |next| {
                if (next == 0 and position + width != start) {
                    new_pos = position + width;
                    // std.debug.print("Down: {} {}\n", .{ position, new_pos });
                }
            }
        }

        racetrack.grid.items[new_pos] = racetrack.track.items.len;
        try racetrack.track.append(new_pos);
        position = new_pos;
    }

    return racetrack;
}
