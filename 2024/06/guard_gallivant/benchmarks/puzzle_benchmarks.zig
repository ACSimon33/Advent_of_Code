const std = @import("std");
const zbench = @import("zbench");
const guard_gallivant = @import("guard_gallivant");

const puzzle_input = @embedFile("puzzle_input");

// Benchmark of part 1
fn task_1(allocator: std.mem.Allocator) void {
    _ = guard_gallivant.visited_positions(puzzle_input, allocator) catch {};
}

// Benchmark of part 2
fn task_2(allocator: std.mem.Allocator) void {
    _ = guard_gallivant.closed_loops(puzzle_input, allocator) catch {};
}

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    var bench = zbench.Benchmark.init(std.heap.page_allocator, .{});
    defer bench.deinit();

    try bench.add("Day 06 - Task 1", task_1, .{});
    try bench.add("Day 06 - Task 2", task_2, .{});

    try stdout.writeAll("\n");
    try bench.run(stdout);
}
