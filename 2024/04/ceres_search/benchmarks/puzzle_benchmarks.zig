const std = @import("std");
const zbench = @import("zbench");
const ceres_search = @import("ceres_search");

const puzzle_input = @embedFile("puzzle_input");

// Benchmark of part 1
fn task_1(allocator: std.mem.Allocator) void {
    _ = ceres_search.xmas_count(puzzle_input, allocator) catch {};
}

// Benchmark of part 2
fn task_2(allocator: std.mem.Allocator) void {
    _ = ceres_search.x_mas_count(puzzle_input, allocator) catch {};
}

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    var bench = zbench.Benchmark.init(std.heap.page_allocator, .{});
    defer bench.deinit();

    try bench.add("Day 04 - Task 1", task_1, .{});
    try bench.add("Day 04 - Task 2", task_2, .{});

    try stdout.writeAll("\n");
    try bench.run(stdout);
}
