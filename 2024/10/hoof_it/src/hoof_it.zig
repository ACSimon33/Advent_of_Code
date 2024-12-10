const std = @import("std");
const Allocator = std.mem.Allocator;
const ArrayList = std.ArrayList;
const HashMap = std.AutoArrayHashMap;
const string = []const u8;
const assert = std.debug.assert;

/// Task 1 - Calculate the sum of all trailhead scores. A trailhead score is the
///          amount of summits (9) that are reachable from a trailhead (0) via
///          a constant increasing path (exactly 9 steps).
///
/// Arguments:
///   - `contents`: Input file contents.
///
/// Returns:
///   - Sum of trailhead scores.
pub fn sum_of_trailhead_scores(contents: string) !usize {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const allocator = arena.allocator();
    const map = try parse_hiking_map(contents, allocator);

    const trailheads = try map.get_trailheads(allocator);
    var trailhead_score: usize = 0;
    for (trailheads.items) |head| {
        map.reset_values();
        map.value_ptr(head).* = 1;
        map.traverse_trails();

        for (0..map.y_size) |y| {
            for (0..map.x_size) |x| {
                const pos = Position{ .x = x, .y = y };
                if (map.z_ptr(pos).* == 9) {
                    trailhead_score += @intFromBool(map.value_ptr(pos).* > 0);
                }
            }
        }
    }

    return trailhead_score;
}

/// Task 1 - Calculate the sum of all trailhead rating. A trailhead rating is
///          the amount of trails to any summit (9) from a trailhead (0) via a
///          constant increasing path (exactly 9 steps).
///
/// Arguments:
///   - `contents`: Input file contents.
///
/// Returns:
///   - Sum of trailhead ratings.
pub fn sum_of_trailhead_ratings(contents: string) !usize {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const allocator = arena.allocator();
    const map = try parse_hiking_map(contents, allocator);

    const trailheads = try map.get_trailheads(allocator);
    map.reset_values();
    for (trailheads.items) |head| {
        map.value_ptr(head).* = 1;
    }

    map.traverse_trails();

    var trailhead_rating: usize = 0;
    for (0..map.y_size) |y| {
        for (0..map.x_size) |x| {
            const pos = Position{ .x = x, .y = y };
            if (map.z_ptr(pos).* == 9) {
                trailhead_rating += map.value_ptr(pos).*;
            }
        }
    }

    return trailhead_rating;
}

// -------------------------------------------------------------------------- \\

/// A position on a 2D map.
const Position = struct { x: usize, y: usize };

/// Cardinal direction.
const Direction = enum(u2) { north, east, south, west };

/// 2D map with heights (z) and additional values for all positions.
const HikingMap = struct {
    z: ArrayList(u8),
    values: ArrayList(u32),
    x_size: usize,
    y_size: usize,

    /// Initialize hiking map.
    ///
    /// Arguments:
    ///   - `x_size`: The size of the map in x direction.
    ///   - `y_size`: The size of the map in y direction.
    ///   - `allocator`: An allocator for the heights and values.
    ///
    /// Returns:
    ///   - The 2D hiking map.
    fn init(x_size: usize, y_size: usize, allocator: Allocator) !HikingMap {
        var z = ArrayList(u8).init(allocator);
        try z.resize(x_size * y_size);

        var values = ArrayList(u32).init(allocator);
        try values.resize(x_size * y_size);

        return HikingMap{
            .z = z,
            .values = values,
            .x_size = x_size,
            .y_size = y_size,
        };
    }

    /// Reset the values of all tiles to 0.
    ///
    /// Arguments:
    ///   - `self`: The hiking map object.
    fn reset_values(self: HikingMap) void {
        @memset(self.values.allocatedSlice(), 0);
    }

    /// Traverse the map starting at the trail heads. At each step move to
    /// neighbouring tiles which are exactly one unit higher. The 'move' will
    /// increment the neighbour tile values by the values of the current tiles.
    ///
    /// Arguments:
    ///   - `self`: The hiking map object.
    fn traverse_trails(self: HikingMap) void {
        for (0..9) |z| {
            for (0..self.y_size) |y| {
                for (0..self.x_size) |x| {
                    const pos = Position{ .x = x, .y = y };
                    if (self.z_ptr(pos).* == z) {
                        for (self.get_ascending_neighbours(pos)) |optional_neighbour| {
                            if (optional_neighbour) |neigbour| {
                                self.value_ptr(neigbour).* += self.value_ptr(pos).*;
                            }
                        }
                    }
                }
            }
        }
    }

    /// Return a pointer to the height of a tile at a given position.
    ///
    /// Arguments:
    ///   - `self`: The hiking map object.
    ///   - `pos`: The position of the tile.
    ///
    /// Returns:
    ///   - Pointer to the tile's height (z).
    fn z_ptr(self: HikingMap, pos: Position) *u8 {
        assert(pos.x < self.x_size);
        assert(pos.y < self.y_size);

        return &self.z.items[pos.y * self.x_size + pos.x];
    }

    /// Return a pointer to the value of a tile at a given position.
    ///
    /// Arguments:
    ///   - `self`: The hiking map object.
    ///   - `pos`: The position of the tile.
    ///
    /// Returns:
    ///   - Pointer to the tile's value.
    fn value_ptr(self: HikingMap, pos: Position) *u32 {
        assert(pos.x < self.x_size);
        assert(pos.y < self.y_size);

        return &self.values.items[pos.y * self.x_size + pos.x];
    }

    /// Return all neighbours that have a height exactly one unit higher than
    /// tile at a given position.
    ///
    /// Arguments:
    ///   - `self`: The hiking map object.
    ///   - `pos`: The position of the tile.
    ///
    /// Returns:
    ///   - Array with optional neighbouring positions. The neighbour positions
    ///     that don't have a height exactly one unit higher are `null`.
    fn get_ascending_neighbours(self: HikingMap, pos: Position) [4]?Position {
        var neighbours: [4]?Position = .{ null, null, null, null };
        for (0..4) |i| {
            const dir: Direction = @enumFromInt(i);
            const neighbour = self.move(dir, pos) catch {
                continue;
            };
            if (self.z_ptr(pos).* + 1 == self.z_ptr(neighbour).*) {
                neighbours[i] = neighbour;
            }
        }
        return neighbours;
    }

    /// Make a move from a given position into a given direction.
    ///
    /// Arguments:
    ///   - `self`: The hiking map object.
    ///   - `dir`: The moving direction.
    ///   - `pos`: The position of the tile.
    ///
    /// Returns:
    ///   - The new position after the move.
    ///   - `error.OutOfBounds` if the move would leave the map.
    fn move(self: HikingMap, dir: Direction, pos: Position) !Position {
        return switch (dir) {
            Direction.north => blk: {
                if (pos.y == 0) {
                    return error.OutOfBounds;
                }
                break :blk Position{ .x = pos.x, .y = pos.y - 1 };
            },
            Direction.east => blk: {
                if (pos.x >= self.x_size - 1) {
                    return error.OutOfBounds;
                }
                break :blk Position{ .x = pos.x + 1, .y = pos.y };
            },
            Direction.south => blk: {
                if (pos.y >= self.y_size - 1) {
                    return error.OutOfBounds;
                }
                break :blk Position{ .x = pos.x, .y = pos.y + 1 };
            },
            Direction.west => blk: {
                if (pos.x == 0) {
                    return error.OutOfBounds;
                }
                break :blk Position{ .x = pos.x - 1, .y = pos.y };
            },
        };
    }

    /// Return a list of all trailheads (height 0).
    ///
    /// Arguments:
    ///   - `self`: The hiking map object.
    ///   - `allocator`: Allocator for the array list.
    ///
    /// Returns:
    ///   - List of all trailheads.
    ///   - `error.OutOfMemory` if the allocation of the list fails.
    fn get_trailheads(self: HikingMap, allocator: Allocator) !ArrayList(Position) {
        var trailheads = ArrayList(Position).init(allocator);
        for (0..self.y_size) |y| {
            for (0..self.x_size) |x| {
                if (self.z.items[y * self.x_size + x] == 0) {
                    try trailheads.append(Position{ .x = x, .y = y });
                }
            }
        }
        return trailheads;
    }
};

/// Parse the file contents into a 2D hiking map.
///
/// Arguments:
///   - `contents`: Input file contents.
///   - `allocator`: Allocator for the containers.
///
/// Returns:
///   - The 2D hiking map.
fn parse_hiking_map(contents: string, allocator: Allocator) !HikingMap {
    var lines = std.mem.tokenize(u8, contents, "\r\n");
    const y_size: usize = @intCast(std.mem.count(u8, contents, &[1]u8{'\n'}) + 1);
    const x_size: usize = lines.peek().?.len;
    const map = try HikingMap.init(x_size, y_size, allocator);

    var tile_idx: usize = 0;
    while (lines.next()) |line| {
        for (line) |tile| {
            map.z.items[tile_idx] = std.fmt.parseInt(u8, &[1]u8{tile}, 10) catch 100;
            tile_idx += 1;
        }
    }

    return map;
}
