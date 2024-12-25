const std = @import("std");
const code_chronicle = @import("code_chronicle");
const testing = std.testing;

// Test of part 1
test "task_1" {
    const example_input = @embedFile("example_input");
    try testing.expectEqual(
        3,
        code_chronicle.key_lock_combinations(example_input, std.testing.allocator),
    );
}
