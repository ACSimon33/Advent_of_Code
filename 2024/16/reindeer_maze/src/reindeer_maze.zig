const std = @import("std");
const Allocator = std.mem.Allocator;
const ArrayList = std.ArrayList;
const PriorityQueue = std.PriorityQueue;
const HashMap = std.AutoArrayHashMap;
const Order = std.math.Order;
const string = []const u8;

// Dijkstra module
const dijkstra = @import("./dijkstra.zig");

/// Task 1 - Run dijkstra to find the shortest path in the maze.
///
/// Arguments:
///   - `contents`: Input file contents.
///   - `main_allocator`: Base allocator for everything.
///
/// Returns:
///   - Cost of the shortest path.
pub fn lowest_maze_score(contents: string, main_allocator: Allocator) !u32 {
    var arena = std.heap.ArenaAllocator.init(main_allocator);
    defer arena.deinit();

    const allocator = arena.allocator();
    const maze = try parse_maze(contents, allocator);

    const nodes = try dijkstra.dijkstra(
        u32,
        maze.adjacency_matrix,
        maze.start,
        maze.end,
        true,
        allocator,
    );

    return nodes.items[maze.end].distance;
}

/// Task 2 - Run dijkstra on all nodes to find all shortest paths. Count the
///          number of tiles that are part of any shortest path.
///
/// Arguments:
///   - `contents`: Input file contents.
///   - `main_allocator`: Base allocator for everything.
///
/// Returns:
///   - Number of tiles that are part of any shortest path.
pub fn amount_of_viewing_positions(contents: string, main_allocator: Allocator) !usize {
    var arena = std.heap.ArenaAllocator.init(main_allocator);
    defer arena.deinit();

    const allocator = arena.allocator();
    const maze = try parse_maze(contents, allocator);

    const nodes = try dijkstra.dijkstra(
        u32,
        maze.adjacency_matrix,
        maze.start,
        maze.end,
        true,
        allocator,
    );

    const nodes_on_path = try dijkstra.get_path_nodes(
        u32,
        nodes,
        maze.end,
        allocator,
    );

    var best_positions = HashMap(usize, void).init(allocator);
    for (nodes_on_path.keys()) |idx| {
        try best_positions.put(maze.path_positions.items[idx], {});
    }

    return best_positions.count();
}

// -------------------------------------------------------------------------- \\

/// Tile type in the maze.
const Tile = enum { wall, space, start, end };

/// Maze represented as two graphs (horizontal and vertical nodes) which are
/// interconnected at crossings.
const Maze = struct {
    path_positions: ArrayList(usize),
    size: usize,
    adjacency_matrix: ArrayList(?u32),
    nodes: usize,
    start: usize,
    end: usize,

    /// Initialize Maze.
    ///
    /// Arguments:
    ///   - `tiles`: The tiles, encoding walls and paths.
    ///   - `allocator`: An allocator for the tiles.
    ///
    /// Returns:
    ///   - The maze, represented as a graph.
    fn init(tiles: ArrayList(Tile), allocator: Allocator) !Maze {
        var horizontal_nodes = HashMap(usize, usize).init(allocator);
        defer horizontal_nodes.deinit();
        var vertical_nodes = HashMap(usize, usize).init(allocator);
        defer vertical_nodes.deinit();

        // Parse nodes into horizontal nodes and vertical nodes
        const size = std.math.sqrt(tiles.items.len);
        var node_count: usize = 0;
        var start: usize = undefined;
        var end: usize = undefined;
        var path_positions = ArrayList(usize).init(allocator);
        for (tiles.items, 0..) |tile, pos| {
            if (tile == Tile.space) {
                // Parse horizontal nodes
                if (tiles.items[pos + 1] == Tile.space or tiles.items[pos - 1] == Tile.space) {
                    try horizontal_nodes.put(pos, node_count);
                    try path_positions.append(pos);
                    node_count += 1;
                }

                // Parse vertical nodes
                if (tiles.items[pos + size] == Tile.space or tiles.items[pos - size] == Tile.space) {
                    try vertical_nodes.put(pos, node_count);
                    try path_positions.append(pos);
                    node_count += 1;
                }
            }

            // Parse start node
            if (tile == Tile.start) {
                start = node_count;
                try path_positions.append(pos);
                node_count += 1;
            }

            // Parse end node
            if (tile == Tile.end) {
                end = node_count;
                try horizontal_nodes.put(pos, node_count);
                try vertical_nodes.put(pos, node_count);
                try path_positions.append(pos);
                node_count += 1;
            }
        }

        // Connect horizontal and vertical nodes with their neighbours with a
        // costs of 1 and interconnect them at intersections with a cost of 1000
        var adjacency_matrix = ArrayList(?u32).init(allocator);
        try adjacency_matrix.appendNTimes(null, node_count * node_count);
        for (tiles.items, 0..) |tile, pos| {
            if (tile == Tile.space) {
                // Connect horizontal nodes
                if (horizontal_nodes.get(pos)) |node1| {
                    if (horizontal_nodes.get(pos + 1)) |node2| {
                        adjacency_matrix.items[node1 * node_count + node2] = 1;
                        adjacency_matrix.items[node2 * node_count + node1] = 1;
                    }
                }

                // Connect vertical nodes
                if (vertical_nodes.get(pos)) |node1| {
                    if (vertical_nodes.get(pos + size)) |node2| {
                        adjacency_matrix.items[node1 * node_count + node2] = 1;
                        adjacency_matrix.items[node2 * node_count + node1] = 1;
                    }
                }

                // Interconnect horizontal and vertical nodes
                if (horizontal_nodes.get(pos)) |node_h| {
                    if (vertical_nodes.get(pos)) |node_v| {
                        adjacency_matrix.items[node_h * node_count + node_v] = 1000;
                        adjacency_matrix.items[node_v * node_count + node_h] = 1000;
                    }
                }
            }

            // Start facing east
            if (tile == Tile.start) {
                if (horizontal_nodes.get(pos + 1)) |to| {
                    adjacency_matrix.items[start * node_count + to] = 1;
                }
                if (horizontal_nodes.get(pos - 1)) |to| {
                    adjacency_matrix.items[start * node_count + to] = 2001;
                }
                if (vertical_nodes.get(pos + size)) |to| {
                    adjacency_matrix.items[start * node_count + to] = 1001;
                }
                if (vertical_nodes.get(pos - size)) |to| {
                    adjacency_matrix.items[start * node_count + to] = 1001;
                }
            }

            // Allow to move into the end node from any side.
            if (tile == Tile.end) {
                if (horizontal_nodes.get(pos + 1)) |from| {
                    adjacency_matrix.items[from * node_count + end] = 1;
                }
                if (horizontal_nodes.get(pos - 1)) |from| {
                    adjacency_matrix.items[from * node_count + end] = 1;
                }
                if (vertical_nodes.get(pos + size)) |from| {
                    adjacency_matrix.items[from * node_count + end] = 1;
                }
                if (vertical_nodes.get(pos - size)) |from| {
                    adjacency_matrix.items[from * node_count + end] = 1;
                }
            }
        }

        return Maze{
            .path_positions = path_positions,
            .size = size,
            .adjacency_matrix = adjacency_matrix,
            .nodes = node_count,
            .start = start,
            .end = end,
        };
    }
};

/// Parse the file contents into a maze object
///
/// Arguments:
///   - `contents`: Input file contents.
///   - `main_allocator`: Base allocator for everything.
///   - `allocator`: Allocator for the containers.
///
/// Returns:
///   - The maze object.
fn parse_maze(contents: string, allocator: Allocator) !Maze {
    var tiles = ArrayList(Tile).init(allocator);
    var lines = std.mem.tokenize(u8, contents, "\r\n");
    while (lines.next()) |line| {
        for (line) |tile| {
            try tiles.append(switch (tile) {
                '#' => Tile.wall,
                '.' => Tile.space,
                'S' => Tile.start,
                'E' => Tile.end,
                else => {
                    return error.UnknownTile;
                },
            });
        }
    }

    return try Maze.init(tiles, allocator);
}
