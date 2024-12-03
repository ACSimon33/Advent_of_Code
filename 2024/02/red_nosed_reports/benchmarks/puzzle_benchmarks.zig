const std = @import("std");
const zbench = @import("zbench");
const red_nosed_reports = @import("red_nosed_reports");

const puzzle_input = @embedFile("puzzle_input");

// Benchmark of part 1
fn task_1(_: std.mem.Allocator) void {
    _ = try red_nosed_reports.solution_1(puzzle_input);
}

// Benchmark of part 2
fn task_2(_: std.mem.Allocator) void {
    _ = try red_nosed_reports.solution_2(puzzle_input);
}

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    var bench = zbench.Benchmark.init(std.heap.page_allocator, .{});
    defer bench.deinit();

    try bench.add("Task 1 - red_nosed Reports", task_1, .{});
    try bench.add("Task 2 - red_nosed Reports", task_2, .{});

    try stdout.writeAll("\n");
    try bench.run(stdout);
}
