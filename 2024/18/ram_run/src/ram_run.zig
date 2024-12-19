const std = @import("std");
const Allocator = std.mem.Allocator;
const ArrayList = std.ArrayList;
const string = []const u8;

// Dijkstra module
const dijkstra = @import("./dijkstra.zig");

/// Task 1 -
///
/// Arguments:
///   - `contents`: Input file contents.
///   - `main_allocator`: Base allocator for everything.
///
/// Returns:
///   - Solution for task 1.
pub fn solution_1(contents: string, bytes: usize, main_allocator: Allocator) !u32 {
    var arena = std.heap.ArenaAllocator.init(main_allocator);
    defer arena.deinit();

    const allocator = arena.allocator();
    const ram = try parse(contents, allocator);
    const end = ram.width * ram.height - 1;

    const nodes = try dijkstra.dijkstra(
        u32,
        try ram.create_adjacency_matrix(bytes, allocator),
        0,
        end,
        true,
        allocator,
    );

    return nodes.items[end].distance;
}

/// Task 2 -
///
/// Arguments:
///   - `contents`: Input file contents.
///   - `main_allocator`: Base allocator for everything.
///
/// Returns:
///   - Solution for task 2.
pub fn solution_2(contents: string, main_allocator: Allocator) !string {
    var arena = std.heap.ArenaAllocator.init(main_allocator);
    defer arena.deinit();

    const allocator = arena.allocator();
    const ram = try parse(contents, allocator);
    const end = ram.width * ram.height - 1;

    var upper_bound = ram.falling_bytes.items.len - 1;
    var lower_bound: usize = 0;
    while (lower_bound + 1 < upper_bound) {
        const bytes = lower_bound + (upper_bound - lower_bound) / 2;
        const nodes = try dijkstra.dijkstra(
            u32,
            try ram.create_adjacency_matrix(bytes, allocator),
            0,
            end,
            true,
            allocator,
        );
        if (nodes.items[end].distance < std.math.maxInt(u32)) {
            lower_bound = bytes;
        } else {
            upper_bound = bytes;
        }
    }

    const x_str_size = std.math.log10(@max(ram.falling_bytes.items[lower_bound].x, 1)) + 1;
    const y_str_size = std.math.log10(@max(ram.falling_bytes.items[lower_bound].y, 1)) + 1;
    const str_size = 1 + x_str_size + y_str_size;
    var out_str = try main_allocator.alloc(u8, str_size);
    _ = try std.fmt.bufPrint(out_str[0..], "{!}", .{ram.falling_bytes.items[lower_bound].x});
    _ = try std.fmt.bufPrint(out_str[x_str_size..], ",", .{});
    _ = try std.fmt.bufPrint(out_str[x_str_size + 1 ..], "{!}", .{ram.falling_bytes.items[lower_bound].y});

    return out_str;
}

// -------------------------------------------------------------------------- \\

const Position = struct { x: usize, y: usize };

const RAM = struct {
    falling_bytes: ArrayList(Position),
    width: usize,
    height: usize,

    fn init(allocator: Allocator) RAM {
        return RAM{
            .falling_bytes = ArrayList(Position).init(allocator),
            .width = undefined,
            .height = undefined,
        };
    }

    fn create_adjacency_matrix(self: RAM, bytes: usize, allocator: Allocator) !ArrayList(?u32) {
        const nodes = self.width * self.height;
        var matrix = try self.create_safe_adjacency_matrix(allocator);

        for (0..@min(bytes, self.falling_bytes.items.len)) |idx| {
            const x1 = self.falling_bytes.items[idx].x;
            const y1 = self.falling_bytes.items[idx].y;
            const from = y1 * self.width + x1;

            for (0..nodes) |to| {
                if (self.is_neighbour_cell(from, to)) {
                    matrix.items[from * nodes + to] = null;
                    matrix.items[to * nodes + from] = null;
                }
            }
        }

        return matrix;
    }

    fn create_safe_adjacency_matrix(self: RAM, allocator: Allocator) !ArrayList(?u32) {
        const nodes = self.width * self.height;
        var matrix = ArrayList(?u32).init(allocator);
        try matrix.appendNTimes(null, nodes * nodes);

        for (0..nodes) |from| {
            for (0..nodes) |to| {
                if (self.is_neighbour_cell(from, to)) {
                    matrix.items[from * nodes + to] = 1;
                }
            }
        }

        return matrix;
    }

    fn is_neighbour_cell(self: RAM, node1: usize, node2: usize) bool {
        const x1 = node1 % self.width;
        const y1 = node1 / self.width;
        const x2 = node2 % self.width;
        const y2 = node2 / self.width;
        return (y1 == y2 and (x1 == x2 + 1 or x1 + 1 == x2)) or (x1 == x2 and (y1 == y2 + 1 or y1 + 1 == y2));
    }

    fn print(self: RAM, bytes: usize) void {
        for (0..self.height) |y| {
            for (0..self.width) |x| {
                var free = true;
                for (0..@min(bytes, self.falling_bytes.items.len)) |idx| {
                    if (x == self.falling_bytes.items[idx].x and y == self.falling_bytes.items[idx].y) {
                        free = false;
                        break;
                    }
                }
                if (free) {
                    std.debug.print(".", .{});
                } else {
                    std.debug.print("#", .{});
                }
            }
            std.debug.print("\n", .{});
        }
    }
};

/// Parse the file contents into a list of reports.
///
/// Arguments:
///   - `contents`: Input file contents.
///   - `main_allocator`: Base allocator for everything.
///   - `allocator`: Allocator for the containers.
///
/// Returns:
///   - Array list of report objects.
fn parse(contents: string, allocator: Allocator) !RAM {
    var ram = RAM.init(allocator);

    var lines = std.mem.tokenize(u8, contents, "\r\n");
    while (lines.next()) |line| {
        var coordinates = std.mem.split(u8, line, ",");
        try ram.falling_bytes.append(Position{
            .x = try std.fmt.parseInt(usize, coordinates.next().?, 10),
            .y = try std.fmt.parseInt(usize, coordinates.next().?, 10),
        });
    }

    var width: usize = 0;
    var height: usize = 0;
    for (ram.falling_bytes.items) |byte| {
        if (byte.x >= width) {
            width = byte.x + 1;
        }
        if (byte.y >= height) {
            height = byte.y + 1;
        }
    }
    ram.width = width;
    ram.height = height;

    return ram;
}
