const std = @import("std");
const Allocator = std.mem.Allocator;
const ArrayList = std.ArrayList;
const HashMap = std.AutoArrayHashMap;
const string = []const u8;

/// Task 1 - Simulate the robot's movements and calculate the sum of GPS numbers
///          of all boxes.
///
/// Arguments:
///   - `contents`: Input file contents.
///   - `main_allocator`: Base allocator for everything.
///
/// Returns:
///   - Sum of GPS numbers.
pub fn simulate_robot(contents: string, main_allocator: Allocator) !usize {
    var arena = std.heap.ArenaAllocator.init(main_allocator);
    defer arena.deinit();

    const allocator = arena.allocator();
    var warehouse = try parse_warehouse(contents, allocator);

    while (try warehouse.move_robot()) {}
    return warehouse.gps_of_boxes();
}

/// Task 1 - Simulate the robot's movements in the second expanded warehouse and
///          calculate the sum of GPS numbers of all boxes.
///
/// Arguments:
///   - `contents`: Input file contents.
///   - `main_allocator`: Base allocator for everything.
///
/// Returns:
///   - Sum of GPS numbers in the expanded warehouse.
pub fn simulate_robot_in_expanded_warehouse(contents: string, main_allocator: Allocator) !usize {
    var arena = std.heap.ArenaAllocator.init(main_allocator);
    defer arena.deinit();

    const allocator = arena.allocator();
    var warehouse = try parse_warehouse(contents, allocator);
    try warehouse.expand_warehouse();

    while (try warehouse.move_robot()) {}
    return warehouse.gps_of_boxes();
}

// -------------------------------------------------------------------------- \\

/// Tile type in the warehouse.
const Tile = enum { robot, wall, space, box, box_left, box_right };

/// Cardinal direction.
const Direction = enum(u2) { north, east, south, west };

/// A robot with a known position and a list of moves that the robot attempts.
const Robot = struct {
    position: usize,
    moves: ArrayList(Direction),
    move_idx: usize,

    /// Initialize the robot.
    ///
    /// Arguments:
    ///   - `allocator`: An allocator for the tiles.
    ///
    /// Returns:
    ///   - A robot with an undefined position and an empty list of moves.
    fn init(allocator: Allocator) !Robot {
        return Robot{
            .position = undefined,
            .moves = ArrayList(Direction).init(allocator),
            .move_idx = 0,
        };
    }

    /// Return the next direction in the list of moves.
    ///
    /// Arguments:
    ///   - `self`: The robot object
    ///
    /// Returns:
    ///   - The next direction in the list of moves.
    ///   - `null` if there are no moves left.
    fn next_move(self: *Robot) ?Direction {
        var dir: ?Direction = null;
        if (self.move_idx < self.moves.items.len) {
            dir = self.moves.items[self.move_idx];
            self.move_idx += 1;
        }
        return dir;
    }
};

/// A warehouse with a certain size and boxes, walls and a single robot.
const Warehouse = struct {
    tiles: ArrayList(Tile),
    robot: Robot,
    width: usize,
    height: usize,

    /// Initialize warehouse.
    ///
    /// Arguments:
    ///   - `allocator`: An allocator for the tiles.
    ///
    /// Returns:
    ///   - A warehouse of unknown size.
    fn init(allocator: Allocator) !Warehouse {
        return Warehouse{
            .tiles = ArrayList(Tile).init(allocator),
            .robot = try Robot.init(allocator),
            .width = undefined,
            .height = undefined,
        };
    }

    /// Expand the warehouse, i.e. double its width.
    ///
    /// Arguments:
    ///   - `self`: The warehouse object
    fn expand_warehouse(self: *Warehouse) !void {
        const old_len = self.width * self.height;
        try self.tiles.resize(2 * old_len);

        for (0..old_len) |i| {
            const idx = old_len - (i + 1);
            self.tiles.items[2 * idx] = switch (self.tiles.items[idx]) {
                Tile.robot => Tile.robot,
                Tile.wall => Tile.wall,
                Tile.space => Tile.space,
                Tile.box => Tile.box_left,
                Tile.box_left, Tile.box_right => {
                    return error.ExpandedWarehouseTwice;
                },
            };
            self.tiles.items[2 * idx + 1] = switch (self.tiles.items[idx]) {
                Tile.robot => Tile.space,
                Tile.wall => Tile.wall,
                Tile.space => Tile.space,
                Tile.box => Tile.box_right,
                Tile.box_left, Tile.box_right => {
                    return error.ExpandedWarehouseTwice;
                },
            };
        }

        // Update warehouse width and robot position
        const robot_x = self.robot.position % self.width;
        const robot_y = self.robot.position / self.width;
        self.width *= 2;
        self.robot.position = robot_y * self.width + 2 * robot_x;
    }

    /// Calculate the sum of the gps numbers of all boxes.
    ///
    /// Arguments:
    ///   - `self`: The warehouse object
    ///
    /// Returns:
    ///   - GPS number sum.
    fn gps_of_boxes(self: Warehouse) usize {
        var gps: usize = 0;
        for (self.tiles.items, 0..) |tile, pos| {
            if (tile == Tile.box or tile == Tile.box_left) {
                const x = pos % self.width;
                const y = pos / self.width;
                gps += 100 * y + x;
            }
        }
        return gps;
    }

    /// Move the robot into the next direction. Additionally move all boxes in
    /// its path. If the robot or any box would move into a wall, nothing moves.
    ///
    /// Arguments:
    ///   - `self`: The warehouse object
    ///
    /// Returns:
    ///   - True if there was a next move available.
    fn move_robot(self: *Warehouse) !bool {
        if (self.robot.next_move()) |dir| {
            var tiles_to_move = HashMap(usize, void).init(std.heap.page_allocator);
            defer tiles_to_move.deinit();

            // If the move is possible, move the robot and everything in its path
            if (try self.move_everything(self.robot.position, dir, &tiles_to_move)) {
                self.robot.position = self.move(self.robot.position, dir).?;
                for (tiles_to_move.keys()) |pos| {
                    const new_pos = self.move(pos, dir).?;
                    self.tiles.items[new_pos] = self.tiles.items[pos];
                    self.tiles.items[pos] = Tile.space;
                }
            }
            return true;
        }
        return false;
    }

    /// Recursively assemble a set of tiles that have to move if the tile at
    /// the given position has to move. Additionally check if the move is
    /// possible, i.e. if no box moves into a wall.
    ///
    /// Arguments:
    ///   - `self`: The warehouse object
    ///   - `pos`: The current position.
    ///   - `dir`: The direction to move in.
    ///   - `tiles_to_move`: The set tiles that have to move.
    ///
    /// Returns:
    ///   - True if the move is possible.
    fn move_everything(
        self: Warehouse,
        pos: usize,
        dir: Direction,
        tiles_to_move: *HashMap(usize, void),
    ) !bool {
        const new_pos = self.move(pos, dir).?;
        const can_move: bool = switch (self.tiles.items[new_pos]) {
            Tile.box, Tile.robot => try self.move_everything(
                new_pos,
                dir,
                tiles_to_move,
            ),
            Tile.wall => false,
            Tile.space => true,
            Tile.box_left => blk: {
                var box_movable = try self.move_everything(
                    new_pos,
                    dir,
                    tiles_to_move,
                );
                if (dir == Direction.north or dir == Direction.south) {
                    box_movable = box_movable and try self.move_everything(
                        new_pos + 1,
                        dir,
                        tiles_to_move,
                    );
                }
                break :blk box_movable;
            },
            Tile.box_right => blk: {
                var box_movable = try self.move_everything(
                    new_pos,
                    dir,
                    tiles_to_move,
                );
                if (dir == Direction.north or dir == Direction.south) {
                    box_movable = box_movable and try self.move_everything(
                        new_pos - 1,
                        dir,
                        tiles_to_move,
                    );
                }
                break :blk box_movable;
            },
        };

        try tiles_to_move.put(pos, {});
        return can_move;
    }

    /// Move a given position into a given direction.
    ///
    /// Arguments:
    ///   - `self`: The warehouse object
    ///   - `pos`: The current position.
    ///   - `dir`: The direction to move in.
    ///
    /// Returns:
    ///   - The new position after the move.
    fn move(self: Warehouse, pos: usize, dir: Direction) ?usize {
        const x = pos % self.width;
        const y = pos / self.width;
        return switch (dir) {
            Direction.north => blk: {
                if (y == 0) {
                    break :blk null;
                }
                break :blk (pos - self.width);
            },
            Direction.east => blk: {
                if (x >= self.width - 1) {
                    break :blk null;
                }
                break :blk (pos + 1);
            },
            Direction.south => blk: {
                if (y >= self.height - 1) {
                    break :blk null;
                }
                break :blk (pos + self.width);
            },
            Direction.west => blk: {
                if (x == 0) {
                    break :blk null;
                }
                break :blk (pos - 1);
            },
        };
    }

    /// Print the current state of the warehouse.
    ///
    /// Arguments:
    ///   - `self`: The warehouse object
    fn print(self: Warehouse) void {
        for (0..self.height) |y| {
            for (0..self.width) |x| {
                switch (self.tiles.items[y * self.width + x]) {
                    Tile.box => std.debug.print("O", .{}),
                    Tile.wall => std.debug.print("#", .{}),
                    Tile.space => std.debug.print(".", .{}),
                    Tile.robot => std.debug.print("@", .{}),
                    Tile.box_left => std.debug.print("[", .{}),
                    Tile.box_right => std.debug.print("]", .{}),
                }
            }
            std.debug.print("\n", .{});
        }
        std.debug.print("\n", .{});
    }
};

/// Parse the file contents into a warehouse object.
///
/// Arguments:
///   - `contents`: Input file contents.
///   - `allocator`: Allocator for the containers.
///
/// Returns:
///   - The warehouse objects.
fn parse_warehouse(contents: string, allocator: Allocator) !Warehouse {
    var warehouse = try Warehouse.init(allocator);

    var lines = std.mem.tokenize(u8, contents, "\r\n");
    warehouse.width = lines.peek().?.len;

    var height: usize = 0;
    while (lines.next()) |line| {
        if (line[0] == '#') {
            for (line, 0..) |tile, x| {
                switch (tile) {
                    '#' => try warehouse.tiles.append(Tile.wall),
                    '.' => try warehouse.tiles.append(Tile.space),
                    'O' => try warehouse.tiles.append(Tile.box),
                    '@' => {
                        try warehouse.tiles.append(Tile.robot);
                        warehouse.robot.position = height * warehouse.width + x;
                    },
                    else => {
                        return error.UnknownTile;
                    },
                }
            }
            height += 1;
        } else {
            for (line) |tile| {
                switch (tile) {
                    '<' => try warehouse.robot.moves.append(Direction.west),
                    '^' => try warehouse.robot.moves.append(Direction.north),
                    '>' => try warehouse.robot.moves.append(Direction.east),
                    'v' => try warehouse.robot.moves.append(Direction.south),
                    else => {
                        return error.UnknownMove;
                    },
                }
            }
        }
    }

    warehouse.height = height;
    return warehouse;
}
