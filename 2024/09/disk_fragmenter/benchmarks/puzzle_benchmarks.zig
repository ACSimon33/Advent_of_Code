const std = @import("std");
const zbench = @import("zbench");
const disk_fragmenter = @import("disk_fragmenter");

const puzzle_input = @embedFile("puzzle_input");

// Benchmark of part 1
fn task_1(_: std.mem.Allocator) void {
    _ = disk_fragmenter.checksum_of_fragmented_disk(puzzle_input) catch {};
}

// Benchmark of part 2
fn task_2(_: std.mem.Allocator) void {
    _ = disk_fragmenter.checksum_of_defragmented_disk(puzzle_input) catch {};
}

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    var bench = zbench.Benchmark.init(std.heap.page_allocator, .{});
    defer bench.deinit();

    try bench.add("Day 09 - Task 1", task_1, .{});
    try bench.add("Day 09 - Task 2", task_2, .{});

    try stdout.writeAll("\n");
    try bench.run(stdout);
}
