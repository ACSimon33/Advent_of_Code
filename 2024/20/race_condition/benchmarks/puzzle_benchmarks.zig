const std = @import("std");
const zbench = @import("zbench");
const race_condition = @import("race_condition");

const puzzle_input = @embedFile("puzzle_input");

// Benchmark of part 1
fn task_1(allocator: std.mem.Allocator) void {
    _ = race_condition.solution_1(puzzle_input, 100, allocator) catch {};
}

// Benchmark of part 2
fn task_2(allocator: std.mem.Allocator) void {
    _ = race_condition.solution_2(puzzle_input, 100, allocator) catch {};
}

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    var bench = zbench.Benchmark.init(std.heap.page_allocator, .{});
    defer bench.deinit();

    try bench.add("Day 20 - Task 1", task_1, .{});
    try bench.add("Day 20 - Task 2", task_2, .{});

    try stdout.writeAll("\n");
    try bench.run(stdout);
}
