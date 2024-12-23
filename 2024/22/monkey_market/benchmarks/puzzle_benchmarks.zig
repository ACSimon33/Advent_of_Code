const std = @import("std");
const zbench = @import("zbench");
const monkey_market = @import("monkey_market");

const puzzle_input = @embedFile("puzzle_input");

// Benchmark of part 1
fn task_1(allocator: std.mem.Allocator) void {
    _ = monkey_market.sum_of_secret_numbers(puzzle_input, 2000, allocator) catch {};
}

// Benchmark of part 2
fn task_2(allocator: std.mem.Allocator) void {
    _ = monkey_market.max_bananas(puzzle_input, 2000, allocator) catch {};
}

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    var bench = zbench.Benchmark.init(std.heap.page_allocator, .{});
    defer bench.deinit();

    try bench.add("Day 22 - Task 1", task_1, .{});
    try bench.add("Day 22 - Task 2", task_2, .{});

    try stdout.writeAll("\n");
    try bench.run(stdout);
}
