const std = @import("std");
const Allocator = std.mem.Allocator;
const ArrayList = std.ArrayList;
const HashMap = std.AutoArrayHashMap;
const string = []const u8;

/// Task 1 - Calculate the number of outer antinodes.
///
/// Arguments:
///   - `contents`: Input file contents.
///   - `main_allocator`: Base allocator for everything.
///
/// Returns:
///   - Number of outer antinodes.
pub fn number_of_outer_antinodes(contents: string, main_allocator: Allocator) !usize {
    var arena = std.heap.ArenaAllocator.init(main_allocator);
    defer arena.deinit();

    const allocator = arena.allocator();
    const city = try parse(contents, allocator);
    return try city.number_of_outer_antinodes();
}

/// Task 1 - Calculate the number of all antinodes.
///
/// Arguments:
///   - `contents`: Input file contents.
///   - `main_allocator`: Base allocator for everything.
///
/// Returns:
///   - Number of all antinodes.
pub fn number_of_all_antinodes(contents: string, main_allocator: Allocator) !usize {
    var arena = std.heap.ArenaAllocator.init(main_allocator);
    defer arena.deinit();

    const allocator = arena.allocator();
    const city = try parse(contents, allocator);
    return try city.number_of_all_antinodes();
}

// -------------------------------------------------------------------------- \\

/// 2D position.
const Position = struct {
    x: isize,
    y: isize,

    /// Check wether the position is inside the city.
    ///
    /// Arguments:
    ///   - `self`: The position.
    ///   - `width`: Width of the city.
    ///   - `height`: Height of the city.
    ///
    /// Returns:
    ///   - True if the position is inside the city.
    fn is_valid(self: Position, width: usize, height: usize) bool {
        return self.x >= 0 and self.x < width and self.y >= 0 and self.y < height;
    }
};

/// An antenna array with a list of antennas with the same frequency.
const AntennaArray = struct {
    locations: ArrayList(Position),

    /// Create a set of positions which are outer antinodes for the array.
    ///
    /// Arguments:
    ///   - `self`: The antenna array.
    ///   - `allocator`: Allocator for the container.
    ///   - `width`: Width of the city.
    ///   - `height`: Height of the city.
    ///
    /// Returns:
    ///   - Set of outer antinode positions.
    fn get_outer_antinodes(
        self: AntennaArray,
        allocator: Allocator,
        width: usize,
        height: usize,
    ) !HashMap(Position, void) {
        var antinodes = HashMap(Position, void).init(allocator);

        const antennas = self.locations.items.len;
        for (0..antennas) |i| {
            for (i + 1..antennas) |j| {
                const delta_x = self.locations.items[j].x - self.locations.items[i].x;
                const delta_y = self.locations.items[j].y - self.locations.items[i].y;

                var pos = Position{
                    .x = self.locations.items[i].x - delta_x,
                    .y = self.locations.items[i].y - delta_y,
                };
                if (pos.is_valid(width, height)) {
                    try antinodes.put(pos, {});
                }
                pos = Position{
                    .x = self.locations.items[j].x + delta_x,
                    .y = self.locations.items[j].y + delta_y,
                };
                if (pos.is_valid(width, height)) {
                    try antinodes.put(pos, {});
                }
            }
        }

        return antinodes;
    }

    /// Create a set of all positions which are antinodes for the array.
    ///
    /// Arguments:
    ///   - `self`: The antenna array.
    ///   - `allocator`: Allocator for the container.
    ///   - `width`: Width of the city.
    ///   - `height`: Height of the city.
    ///
    /// Returns:
    ///   - Set of all antinode positions.
    fn get_all_antinodes(
        self: AntennaArray,
        allocator: Allocator,
        width: usize,
        height: usize,
    ) !HashMap(Position, void) {
        var antinodes = HashMap(Position, void).init(allocator);

        const antennas = self.locations.items.len;
        for (0..antennas) |i| {
            for (i + 1..antennas) |j| {
                var delta_x: isize = self.locations.items[j].x - self.locations.items[i].x;
                var delta_y: isize = self.locations.items[j].y - self.locations.items[i].y;

                if (delta_x != 0 and delta_y != 0) {
                    const gcd: isize = @intCast(std.math.gcd(@abs(delta_x), @abs(delta_y)));
                    delta_x = @divExact(delta_x, gcd);
                    delta_y = @divExact(delta_y, gcd);
                }

                var pos = self.locations.items[i];
                while (pos.is_valid(width, height)) : ({
                    pos.x += delta_x;
                    pos.y += delta_y;
                }) {
                    try antinodes.put(pos, {});
                }

                pos = self.locations.items[i];
                while (pos.is_valid(width, height)) : ({
                    pos.x -= delta_x;
                    pos.y -= delta_y;
                }) {
                    try antinodes.put(pos, {});
                }
            }
        }

        return antinodes;
    }
};

/// The city with a map of antenna arrays.
const City = struct {
    allocator: Allocator,
    antennas: HashMap(u8, AntennaArray),
    width: usize,
    height: usize,

    /// Initialize the city.
    ///
    /// Arguments:
    ///   - `allocator`: Allocator for the containers.
    ///   - `width`: Width of the city.
    ///   - `height`: Height of the city.
    ///
    /// Returns:
    ///   - The city object.
    fn init(allocator: Allocator, width: usize, height: usize) City {
        return City{
            .allocator = allocator,
            .antennas = HashMap(u8, AntennaArray).init(allocator),
            .width = width,
            .height = height,
        };
    }

    /// Count the number of unique antinodes, produced by all antenna arrays.
    /// Only the two outer antinodes are counted.
    ///
    /// Arguments:
    ///   - `self`: The city object.
    ///
    /// Returns:
    ///   - Number of outer antinodes.
    fn number_of_outer_antinodes(self: City) !usize {
        var antinodes = HashMap(Position, void).init(self.allocator);
        defer antinodes.deinit();

        for (self.antennas.values()) |array| {
            var array_antinodes = try array.get_outer_antinodes(self.allocator, self.width, self.height);
            defer array_antinodes.deinit();

            for (array_antinodes.keys()) |antinode| {
                try antinodes.put(antinode, {});
            }
        }

        return antinodes.count();
    }

    /// Count the number of unique antinodes, produced by all antenna arrays.
    /// All antinodes are counted.
    ///
    /// Arguments:
    ///   - `self`: The city object.
    ///
    /// Returns:
    ///   - Number of all antinodes.
    fn number_of_all_antinodes(self: City) !usize {
        var antinodes = HashMap(Position, void).init(self.allocator);
        defer antinodes.deinit();

        for (self.antennas.values()) |array| {
            var array_antinodes = try array.get_all_antinodes(self.allocator, self.width, self.height);
            defer array_antinodes.deinit();

            for (array_antinodes.keys()) |antinode| {
                try antinodes.put(antinode, {});
            }
        }

        return antinodes.count();
    }
};

/// Parse the file contents into a city object (a map of all antenna arrays).
///
/// Arguments:
///   - `contents`: Input file contents.
///   - `allocator`: Allocator for the containers.
///
/// Returns:
///   - The city object.
fn parse(contents: string, allocator: Allocator) !City {
    var lines = std.mem.tokenize(u8, contents, "\r\n");
    const width: usize = lines.peek().?.len;
    const height: usize = @intCast(std.mem.count(u8, contents, &[1]u8{'\n'}) + 1);
    var city = City.init(allocator, width, height);

    var y: isize = 0;
    while (lines.next()) |line| : (y += 1) {
        for (line, 0..) |tile, x| {
            if (tile != '.') {
                const entry = try city.antennas.getOrPutValue(tile, AntennaArray{
                    .locations = ArrayList(Position).init(allocator),
                });
                try entry.value_ptr.locations.append(Position{ .x = @intCast(x), .y = y });
            }
        }
    }

    return city;
}
