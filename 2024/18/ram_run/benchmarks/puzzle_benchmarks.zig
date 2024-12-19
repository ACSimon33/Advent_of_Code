const std = @import("std");
const zbench = @import("zbench");
const ram_run = @import("ram_run");

const puzzle_input = @embedFile("puzzle_input");

// Benchmark of part 1
fn task_1(allocator: std.mem.Allocator) void {
    _ = ram_run.solution_1(puzzle_input, 1024, allocator) catch {};
}

// Benchmark of part 2
fn task_2(allocator: std.mem.Allocator) void {
    const result = ram_run.solution_2(
        puzzle_input,
        allocator,
    ) catch return;
    allocator.free(result);
}

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    var bench = zbench.Benchmark.init(std.heap.page_allocator, .{});
    defer bench.deinit();

    try bench.add("Day 18 - Task 1", task_1, .{});
    try bench.add("Day 18 - Task 2", task_2, .{});

    try stdout.writeAll("\n");
    try bench.run(stdout);
}
