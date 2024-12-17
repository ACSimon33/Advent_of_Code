const std = @import("std");
const disk_fragmenter = @import("disk_fragmenter");
const testing = std.testing;

// Test of part 1
test "task_1" {
    const example_input = @embedFile("example_input");
    try testing.expectEqual(
        1928,
        disk_fragmenter.checksum_of_fragmented_disk(example_input, std.testing.allocator),
    );
}

// Test of part 2
test "task_2" {
    const example_input = @embedFile("example_input");
    try testing.expectEqual(
        2858,
        disk_fragmenter.checksum_of_defragmented_disk(example_input, std.testing.allocator),
    );
}
