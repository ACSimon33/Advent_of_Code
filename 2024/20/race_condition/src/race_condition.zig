const std = @import("std");
const Allocator = std.mem.Allocator;
const ArrayList = std.ArrayList;
const string = []const u8;

/// Task 1 & 2 - Calculate the amount of possible shortcuts that are possible
///              with the given shortcut range and are larger than the given
///              shortcut length.
///
/// Arguments:
///   - `contents`: Input file contents.
///   - `shortcut_range`: Range for that collision detection is disabled.
///   - `min_shortcut`: Minimal shortcut length.
///   - `main_allocator`: Base allocator for everything.
///
/// Returns:
///   - Amount of possible shortcuts.
pub fn amount_of_shortcuts(
    contents: string,
    shortcut_range: usize,
    min_shortcut: usize,
    main_allocator: Allocator,
) !u32 {
    var arena = std.heap.ArenaAllocator.init(main_allocator);
    defer arena.deinit();

    const allocator = arena.allocator();
    const racetrack = try parse(contents, allocator);
    return racetrack.count_shortcuts(shortcut_range, min_shortcut);
}

// -------------------------------------------------------------------------- \\

const Racetrack = struct {
    track: ArrayList(usize),
    grid: ArrayList(?usize),
    width: usize,
    height: usize,

    /// Initialize a racetrack object with a grid with the given size.
    ///
    /// Arguments:
    ///   - `width`: Width of the grid.
    ///   - `height`: Height of the grid.
    ///   - `allocator`: Allocator for the containers.
    ///
    /// Returns:
    ///   - Racetrack object.
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

    /// Count the amount of shortcuts that are possible with the given shortcut
    /// range and a are larger than the minimal shortcut length.
    ///
    /// Arguments:
    ///   - `self`: The racetrack object.
    ///   - `shortcut_range`: Range for that collision detection is disabled.
    ///   - `min_shortcut`: Minimal shortcut length.
    ///
    /// Returns:
    ///   - Amount of possible shortcuts.
    fn count_shortcuts(self: Racetrack, shortcut_range: usize, min_shortcut: usize) u32 {
        var shortcuts: u32 = 0;
        for (self.track.items, 0..) |position_1, distance1| {
            const x = position_1 % self.width;
            const y = position_1 / self.width;

            for (0..shortcut_range + 1) |cheat_x| {
                if (x >= cheat_x) {
                    const position_2 = position_1 - cheat_x;
                    if (self.grid.items[position_2]) |distance2| {
                        if (distance2 > distance1 + min_shortcut + cheat_x - 1) {
                            shortcuts += 1;
                        }
                    }
                    for (1..(shortcut_range + 1 - cheat_x)) |cheat_y| {
                        if (y >= cheat_y) {
                            const position_3 = position_2 - cheat_y * self.width;
                            if (self.grid.items[position_3]) |distance2| {
                                if (distance2 > distance1 + min_shortcut + cheat_x + cheat_y - 1) {
                                    shortcuts += 1;
                                }
                            }
                        }

                        if (y + cheat_y <= self.height - 1) {
                            const position_3 = position_2 + cheat_y * self.width;
                            if (self.grid.items[position_3]) |distance2| {
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

                if (x + cheat_x <= self.width - 1) {
                    const position_2 = position_1 + cheat_x;
                    if (self.grid.items[position_2]) |distance2| {
                        if (distance2 > distance1 + min_shortcut + cheat_x - 1) {
                            shortcuts += 1;
                        }
                    }

                    for (1..(shortcut_range + 1 - cheat_x)) |cheat_y| {
                        if (y >= cheat_y) {
                            const position_3 = position_2 - cheat_y * self.width;
                            if (self.grid.items[position_3]) |distance2| {
                                if (distance2 > distance1 + min_shortcut + cheat_x + cheat_y - 1) {
                                    shortcuts += 1;
                                }
                            }
                        }

                        if (y + cheat_y <= self.height - 1) {
                            const position_3 = position_2 + cheat_y * self.width;
                            if (self.grid.items[position_3]) |distance2| {
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
};

/// Parse the file contents into a racetrack object.
///
/// Arguments:
///   - `contents`: Input file contents.
///   - `allocator`: Allocator for the containers.
///
/// Returns:
///   - Racetrack object.
fn parse(contents: string, allocator: Allocator) !Racetrack {
    var lines = std.mem.tokenize(u8, contents, "\r\n");
    const height: usize = @intCast(std.mem.count(u8, contents, &[1]u8{'\n'}) + 1);
    const width: usize = lines.peek().?.len;
    var racetrack = try Racetrack.init(width, height, allocator);

    // Parse grid (wall = null, path = 0)
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

    // Find the path from start to end
    try racetrack.track.append(start);
    var position = start;
    while (position != end) {
        const x = position % width;
        const y = position / width;

        var new_pos: usize = undefined;
        if (x > 0) {
            if (racetrack.grid.items[position - 1]) |next| {
                if (next == 0 and position - 1 != start) {
                    new_pos = position - 1;
                }
            }
        }
        if (x < width - 1) {
            if (racetrack.grid.items[position + 1]) |next| {
                if (next == 0 and position + 1 != start) {
                    new_pos = position + 1;
                }
            }
        }
        if (y > 0) {
            if (racetrack.grid.items[position - width]) |next| {
                if (next == 0 and position - width != start) {
                    new_pos = position - width;
                }
            }
        }
        if (y < height - 1) {
            if (racetrack.grid.items[position + width]) |next| {
                if (next == 0 and position + width != start) {
                    new_pos = position + width;
                }
            }
        }

        racetrack.grid.items[new_pos] = racetrack.track.items.len;
        try racetrack.track.append(new_pos);
        position = new_pos;
    }

    return racetrack;
}
