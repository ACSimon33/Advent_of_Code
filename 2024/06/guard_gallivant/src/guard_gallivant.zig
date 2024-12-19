const std = @import("std");
const HashMap = std.AutoArrayHashMap;
const Allocator = std.mem.Allocator;
const string = []const u8;

/// Task 1 - Calculate the amount of distinct positions that the guard visits
///          by simulating the guard until they leave the map.
///
/// Arguments:
///   - `contents`: Input file contents.
///   - `main_allocator`: Base allocator for everything.
///
/// Returns:
///   - Amount of distinct positions.
pub fn visited_positions(contents: string, main_allocator: Allocator) !usize {
    var arena = std.heap.ArenaAllocator.init(main_allocator);
    defer arena.deinit();

    const allocator = arena.allocator();
    const map, var guard = try parse_map(contents, allocator);

    // Move the guard until it is outside the map and record all positions
    var visited = HashMap(Position, void).init(allocator);
    while (is_guard_inside(map, guard)) : (guard = move(map, guard)) {
        try visited.put(guard.pos, {});
    }

    return visited.count();
}

/// Task 2 - Calculate the amount of closed guard roots we can create by
///          placing one extra obstacle on the map.
///
/// Arguments:
///   - `contents`: Input file contents.
///   - `main_allocator`: Base allocator for everything.
///
/// Returns:
///   - Amount of closed loops.
pub fn closed_loops(contents: string, main_allocator: Allocator) !usize {
    var arena = std.heap.ArenaAllocator.init(main_allocator);
    defer arena.deinit();

    const allocator = arena.allocator();
    var map, var guard = try parse_map(contents, allocator);

    // Move the guard until it is outside the map and record all states
    var visited = HashMap(Guard, void).init(allocator);
    while (is_guard_inside(map, guard)) : (guard = move(map, guard)) {
        try visited.put(guard, {});
    }

    var new_obstacles = HashMap(Position, void).init(allocator);
    try new_obstacles.put(visited.keys()[0].pos, {});
    var loop_count: usize = 0;

    // Put an obstacle into each unique position in the guards path and check
    // wether the guard runs in a loop or exits the map
    for (0..visited.count()) |i| {
        if (new_obstacles.contains(visited.keys()[i].pos)) {
            continue;
        }
        try map.obstacles.put(visited.keys()[i].pos, {});

        // Let the guard start right in front of the new obstacle to save time
        guard = visited.keys()[i - 1];

        var states = HashMap(Guard, void).init(allocator);
        while (is_guard_inside(map, guard)) : (guard = move(map, guard)) {
            if (states.contains(guard)) {
                loop_count += 1;
                break;
            }
            try states.put(guard, {});
        }

        _ = map.obstacles.pop();
        try new_obstacles.put(visited.keys()[i].pos, {});
    }

    return loop_count;
}

// -------------------------------------------------------------------------- \\

/// 2D position on the map
const Position = struct { x: i32, y: i32 };

/// Cardinal direction
const Direction = enum(u3) {
    north,
    east,
    south,
    west,

    /// Make a 90 degree turn and calculate the new cardinal direction.
    ///
    /// Arguments:
    ///   - `self`: The current direction.
    ///
    /// Returns:
    ///   - The new direction after turning to the right.
    fn turn_right(self: Direction) Direction {
        return @enumFromInt((@intFromEnum(self) + 1) % 4);
    }
};

/// Map which holds (hashed) information about all obstacles.
const ObstacleMap = struct {
    obstacles: HashMap(Position, void),
    size: Position,
};

/// Guard state which encodes their current position and the direction.
const Guard = struct {
    dir: Direction,
    pos: Position,
};

/// Move the guard one step in its current direction. If the direction is
/// blocked by an obstacle, turn right and try again.
///
/// Arguments:
///   - `map`: The obstacle map.
///   - `guard`: The current state of the guard.
///
/// Returns:
///   - The new state of the guard after moving.
fn move(map: ObstacleMap, guard: Guard) Guard {
    var newPos = guard.pos;
    switch (guard.dir) {
        .north => {
            newPos.y -= 1;
        },
        .east => {
            newPos.x += 1;
        },
        .south => {
            newPos.y += 1;
        },
        .west => {
            newPos.x -= 1;
        },
    }

    if (map.obstacles.contains(newPos)) {
        return move(map, Guard{
            .dir = guard.dir.turn_right(),
            .pos = guard.pos,
        });
    }

    return Guard{
        .dir = guard.dir,
        .pos = newPos,
    };
}

/// Check whether the guard position is inside the map.
///
/// Arguments:
///   - `map`: The obstacle map.
///   - `guard`: The current state of the guard.
///
/// Returns:
///   - Wether the guard is inside the map.
fn is_guard_inside(map: ObstacleMap, guard: Guard) bool {
    return (guard.pos.x < map.size.x and guard.pos.x >= 0 and guard.pos.y < map.size.y and guard.pos.y >= 0);
}

/// Parse the file contents into a map of obstacles and the current guard state.
///
/// Arguments:
///   - `contents`: Input file contents.
///   - `allocator`: Allocator for the containers.
///
/// Returns:
///   - Obstacle map and guard state.
fn parse_map(contents: string, allocator: Allocator) !struct { ObstacleMap, Guard } {
    var obstacles = HashMap(Position, void).init(allocator);
    var dir: ?Direction = null;
    var pos: ?Position = null;
    var size: ?Position = null;

    var lines = std.mem.tokenize(
        u8,
        contents,
        "\n\r",
    );
    var y: i32 = 0;
    while (lines.next()) |line| : (y += 1) {
        for (line, 0..) |c, x| {
            try switch (c) {
                '#' => obstacles.put(
                    Position{ .x = @intCast(x), .y = y },
                    {},
                ),
                '^' => {
                    dir = Direction.north;
                    pos = Position{ .x = @intCast(x), .y = y };
                },
                '>' => {
                    dir = Direction.east;
                    pos = Position{ .x = @intCast(x), .y = y };
                },
                'v' => {
                    dir = Direction.south;
                    pos = Position{ .x = @intCast(x), .y = y };
                },
                '<' => {
                    dir = Direction.west;
                    pos = Position{ .x = @intCast(x), .y = y };
                },
                else => {},
            };
        }
        if (size == null) {
            size = Position{ .x = @intCast(line.len), .y = undefined };
        }
    }

    size.?.y = y;

    return .{
        ObstacleMap{
            .obstacles = obstacles,
            .size = size.?,
        },
        Guard{
            .dir = dir.?,
            .pos = pos.?,
        },
    };
}
