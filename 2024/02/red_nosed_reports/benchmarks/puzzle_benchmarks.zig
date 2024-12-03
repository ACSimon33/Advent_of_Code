const std = @import("std");
const zbench = @import("zbench");
const red_nosed_reports = @import("red_nosed_reports");

const puzzle_input = @embedFile("puzzle_input");

// Benchmark of part 1
fn task_1(_: std.mem.Allocator) void {
    _ = red_nosed_reports.number_of_safe_reports(puzzle_input) catch {};
}

// Benchmark of part 2
fn task_2(_: std.mem.Allocator) void {
    _ = red_nosed_reports.number_of_partially_safe_reports(puzzle_input) catch {};
}

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    var bench = zbench.Benchmark.init(std.heap.page_allocator, .{});
    defer bench.deinit();

    try bench.add("Red-Nosed Reports - Task 1", task_1, .{});
    try bench.add("Red-Nosed Reports - Task 2", task_2, .{});

    try stdout.writeAll("\n");
    try bench.run(stdout);
}
