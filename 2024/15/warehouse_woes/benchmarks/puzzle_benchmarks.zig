const std = @import("std");
const zbench = @import("zbench");
const warehouse_woes = @import("warehouse_woes");

const puzzle_input = @embedFile("puzzle_input");

// Benchmark of part 1
fn task_1(allocator: std.mem.Allocator) void {
    _ = warehouse_woes.simulate_robot(puzzle_input, allocator) catch {};
}

// Benchmark of part 2
fn task_2(allocator: std.mem.Allocator) void {
    _ = warehouse_woes.simulate_robot_in_expanded_warehouse(puzzle_input, allocator) catch {};
}

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    var bench = zbench.Benchmark.init(std.heap.page_allocator, .{});
    defer bench.deinit();

    try bench.add("Day 15 - Task 1", task_1, .{});
    try bench.add("Day 15 - Task 2", task_2, .{});

    try stdout.writeAll("\n");
    try bench.run(stdout);
}
