const std = @import("std");
const zbench = @import("zbench");
const claw_contraption = @import("claw_contraption");

const puzzle_input = @embedFile("puzzle_input");

// Benchmark of part 1
fn task_1(allocator: std.mem.Allocator) void {
    _ = claw_contraption.cost_to_win_all_prizes(
        puzzle_input,
        0,
        allocator,
    ) catch {};
}

// Benchmark of part 2
fn task_2(allocator: std.mem.Allocator) void {
    _ = claw_contraption.cost_to_win_all_prizes(
        puzzle_input,
        10000000000000,
        allocator,
    ) catch {};
}

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    var bench = zbench.Benchmark.init(std.heap.page_allocator, .{});
    defer bench.deinit();

    try bench.add("Day 13 - Task 1", task_1, .{});
    try bench.add("Day 13 - Task 2", task_2, .{});

    try stdout.writeAll("\n");
    try bench.run(stdout);
}
