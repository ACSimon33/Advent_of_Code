const std = @import("std");
const zbench = @import("zbench");
const restroom_redoubt = @import("restroom_redoubt");

const puzzle_input = @embedFile("puzzle_input");

// Benchmark of part 1
fn task_1(allocator: std.mem.Allocator) void {
    _ = restroom_redoubt.security_factor(
        puzzle_input,
        100,
        101,
        103,
        allocator,
    ) catch {};
}

// Benchmark of part 2
fn task_2(allocator: std.mem.Allocator) void {
    _ = restroom_redoubt.time_until_christmas_tree(
        puzzle_input,
        101,
        103,
        false,
        allocator,
    ) catch {};
}

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    var bench = zbench.Benchmark.init(std.heap.page_allocator, .{});
    defer bench.deinit();

    try bench.add("Day 14 - Task 1", task_1, .{});
    try bench.add("Day 14 - Task 2", task_2, .{});

    try stdout.writeAll("\n");
    try bench.run(stdout);
}
