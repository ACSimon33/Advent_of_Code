const std = @import("std");
const zbench = @import("zbench");
const zig_template = @import("zig_template");

const puzzle_input = @embedFile("puzzle_input");

// Benchmark of part 1
fn task_1(_: std.mem.Allocator) void {
    _ = try zig_template.solution_1(puzzle_input);
}

// Benchmark of part 2
fn task_2(_: std.mem.Allocator) void {
    _ = try zig_template.solution_2(puzzle_input);
}

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    var bench = zbench.Benchmark.init(std.heap.page_allocator, .{});
    defer bench.deinit();

    try bench.add("Task 1 - Zig Template", task_1, .{});
    try bench.add("Task 2 - Zig Template", task_2, .{});

    try stdout.writeAll("\n");
    try bench.run(stdout);
}
