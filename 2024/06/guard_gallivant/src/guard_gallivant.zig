const std = @import("std");
const HashMap = std.AutoArrayHashMap;
const Allocator = std.mem.Allocator;

/// Task 1
pub fn solution_1(contents: []const u8) !usize {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const allocator = arena.allocator();
    const setup = try parse_map(contents, allocator);
    const map = setup[0];
    var guard = setup[1];

    var visited = HashMap(Position, void).init(allocator);
    while (is_guard_inside(map, guard)) : (guard = move(map, guard)) {
        try visited.put(guard.pos, {});
    }

    return visited.count();
}

/// Task 2
pub fn solution_2(contents: []const u8) !usize {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const allocator = arena.allocator();
    const setup = try parse_map(contents, allocator);
    var map = setup[0];
    var guard = setup[1];

    var visited = HashMap(Guard, void).init(allocator);
    while (is_guard_inside(map, guard)) : (guard = move(map, guard)) {
        try visited.put(guard, {});
    }

    var tried_obstacle = HashMap(Position, void).init(allocator);
    try tried_obstacle.put(visited.keys()[0].pos, {});
    var loop_count: usize = 0;
    for (0..visited.count()) |i| {
        if (tried_obstacle.contains(visited.keys()[i].pos)) {
            continue;
        }

        try map.obstacles.put(visited.keys()[i].pos, {});

        guard = visited.keys()[i - 1];
        var states = HashMap(Guard, void).init(
            std.heap.page_allocator,
        );
        defer states.deinit();

        while (is_guard_inside(map, guard)) : (guard = move(map, guard)) {
            if (states.contains(guard)) {
                loop_count += 1;
                break;
            }
            try states.put(guard, {});
        }

        _ = map.obstacles.pop();
        try tried_obstacle.put(visited.keys()[i].pos, {});
    }

    return loop_count;
}

const Position = struct { x: i32, y: i32 };

const Direction = enum(u3) {
    north,
    east,
    south,
    west,

    pub fn turn_right(self: Direction) Direction {
        return @enumFromInt((@intFromEnum(self) + 1) % 4);
    }
};

const GuardMap = struct {
    obstacles: HashMap(Position, void),
    size: Position,
};

const Guard = struct {
    dir: Direction,
    pos: Position,
};

pub fn move(map: GuardMap, guard: Guard) Guard {
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

pub fn is_guard_inside(map: GuardMap, guard: Guard) bool {
    return (guard.pos.x < map.size.x and guard.pos.x >= 0 and guard.pos.y < map.size.y and guard.pos.y >= 0);
}

/// Parse the file contents into a list of reports.
///
/// Arguments:
///   - `contents`: Input file contents.
///   - `allocator`: Allocator for the containers.
///
/// Returns:
///   - Array list of report objects.
fn parse_map(contents: []const u8, allocator: Allocator) !struct { GuardMap, Guard } {
    var obstacles = HashMap(Position, void).init(allocator);
    var dir: ?Direction = null;
    var pos: ?Position = null;
    var size: ?Position = null;

    var lines = std.mem.splitAny(u8, contents, "\n\r");
    var y: i32 = 0;
    while (lines.next()) |line| : (y += 1) {
        if (line.len == 0) {
            continue;
        }

        for (line, 0..) |c, x| {
            try switch (c) {
                '#' => obstacles.put(Position{ .x = @intCast(x), .y = y }, {}),
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
        GuardMap{
            .obstacles = obstacles,
            .size = size.?,
        },
        Guard{
            .dir = dir.?,
            .pos = pos.?,
        },
    };
}
