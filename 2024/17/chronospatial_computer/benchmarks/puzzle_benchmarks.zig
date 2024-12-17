const std = @import("std");
const zbench = @import("zbench");
const chronospatial_computer = @import("chronospatial_computer");

const puzzle_input = @embedFile("puzzle_input");

// Benchmark of part 1
fn task_1(allocator: std.mem.Allocator) void {
    _ = chronospatial_computer.simulate_program(puzzle_input, allocator) catch {};
}

// Benchmark of part 2
fn task_2(allocator: std.mem.Allocator) void {
    _ = chronospatial_computer.debug_program(puzzle_input, allocator) catch {};
}

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    var bench = zbench.Benchmark.init(std.heap.page_allocator, .{});
    defer bench.deinit();

    try bench.add("Day 17 - Task 1", task_1, .{});
    try bench.add("Day 17 - Task 2", task_2, .{});

    try stdout.writeAll("\n");
    try bench.run(stdout);
}
