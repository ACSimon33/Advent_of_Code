const std = @import("std");
const zbench = @import("zbench");
const reindeer_maze = @import("reindeer_maze");

const puzzle_input = @embedFile("puzzle_input");

// Benchmark of part 1
fn task_1(_: std.mem.Allocator) void {
    _ = reindeer_maze.lowest_maze_score(puzzle_input) catch {};
}

// Benchmark of part 2
fn task_2(_: std.mem.Allocator) void {
    _ = reindeer_maze.amount_of_viewing_positions(puzzle_input) catch {};
}

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    var bench = zbench.Benchmark.init(std.heap.page_allocator, .{});
    defer bench.deinit();

    try bench.add("Day 16 - Task 1", task_1, .{});
    try bench.add("Day 16 - Task 2", task_2, .{});

    try stdout.writeAll("\n");
    try bench.run(stdout);
}
