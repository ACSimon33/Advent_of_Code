const std = @import("std");
const historian_hysteria = @import("historian_hysteria");
const testing = std.testing;

// Test of part 1
test "task_1" {
    const example_input = @embedFile("example_input");
    try testing.expectEqual(
        11,
        historian_hysteria.list_distance(example_input, std.testing.allocator),
    );
}

// Test of part 2
test "task_2" {
    const example_input = @embedFile("example_input");
    try testing.expectEqual(
        31,
        historian_hysteria.list_similarity(example_input, std.testing.allocator),
    );
}
