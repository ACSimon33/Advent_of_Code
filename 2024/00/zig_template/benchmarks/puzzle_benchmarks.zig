const std = @import("std");
const zbench = @import("zbench");
const zig_template = @import("zig_template");

const puzzle_input = @embedFile("puzzle_input");

// Benchmark of part 1
fn task_1(_: std.mem.Allocator) void {
    _ = zig_template.solution_1(puzzle_input) catch {};
}

// Benchmark of part 2
fn task_2(_: std.mem.Allocator) void {
    _ = zig_template.solution_2(puzzle_input) catch {};
}

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    var bench = zbench.Benchmark.init(std.heap.page_allocator, .{});
    defer bench.deinit();

    try bench.add("Day 00 - Task 1", task_1, .{});
    try bench.add("Day 00 - Task 2", task_2, .{});

    try stdout.writeAll("\n");
    try bench.run(stdout);
}
