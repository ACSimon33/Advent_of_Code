const std = @import("std");
const zbench = @import("zbench");
const bridge_repair = @import("bridge_repair");

const puzzle_input = @embedFile("puzzle_input");

// Benchmark of part 1
fn task_1(allocator: std.mem.Allocator) void {
    _ = bridge_repair.total_calibration_result(puzzle_input, allocator) catch {};
}

// Benchmark of part 2
fn task_2(allocator: std.mem.Allocator) void {
    _ = bridge_repair.total_calibration_result_with_concatenation(puzzle_input, allocator) catch {};
}

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    var bench = zbench.Benchmark.init(std.heap.page_allocator, .{});
    defer bench.deinit();

    try bench.add("Day 07 - Task 1", task_1, .{});
    try bench.add("Day 07 - Task 2", task_2, .{});

    try stdout.writeAll("\n");
    try bench.run(stdout);
}
