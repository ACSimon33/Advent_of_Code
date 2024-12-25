const std = @import("std");
const zbench = @import("zbench");
const code_chronicle = @import("code_chronicle");

const puzzle_input = @embedFile("puzzle_input");

// Benchmark of part 1
fn task_1(allocator: std.mem.Allocator) void {
    _ = code_chronicle.key_lock_combinations(puzzle_input, allocator) catch {};
}

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    var bench = zbench.Benchmark.init(std.heap.page_allocator, .{});
    defer bench.deinit();

    try bench.add("Day 25 - Task 1", task_1, .{});

    try stdout.writeAll("\n");
    try bench.run(stdout);
}
