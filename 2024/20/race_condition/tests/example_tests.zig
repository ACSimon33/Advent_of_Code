const std = @import("std");
const race_condition = @import("race_condition");
const testing = std.testing;

// Test of part 1
test "task_1_shortcut_2" {
    const example_input = @embedFile("example_input");
    try testing.expectEqual(
        44,
        race_condition.amount_of_shortcuts(example_input, 2, 2, std.testing.allocator),
    );
}

test "task_1_shortcut_4" {
    const example_input = @embedFile("example_input");
    try testing.expectEqual(
        30,
        race_condition.amount_of_shortcuts(example_input, 2, 4, std.testing.allocator),
    );
}

test "task_1_shortcut_6" {
    const example_input = @embedFile("example_input");
    try testing.expectEqual(
        16,
        race_condition.amount_of_shortcuts(example_input, 2, 6, std.testing.allocator),
    );
}

test "task_1_shortcut_8" {
    const example_input = @embedFile("example_input");
    try testing.expectEqual(
        14,
        race_condition.amount_of_shortcuts(example_input, 2, 8, std.testing.allocator),
    );
}

test "task_1_shortcut_10" {
    const example_input = @embedFile("example_input");
    try testing.expectEqual(
        10,
        race_condition.amount_of_shortcuts(example_input, 2, 10, std.testing.allocator),
    );
}

test "task_1_shortcut_12" {
    const example_input = @embedFile("example_input");
    try testing.expectEqual(
        8,
        race_condition.amount_of_shortcuts(example_input, 2, 12, std.testing.allocator),
    );
}

test "task_1_shortcut_20" {
    const example_input = @embedFile("example_input");
    try testing.expectEqual(
        5,
        race_condition.amount_of_shortcuts(example_input, 2, 20, std.testing.allocator),
    );
}

test "task_1_shortcut_36" {
    const example_input = @embedFile("example_input");
    try testing.expectEqual(
        4,
        race_condition.amount_of_shortcuts(example_input, 2, 36, std.testing.allocator),
    );
}

test "task_1_shortcut_38" {
    const example_input = @embedFile("example_input");
    try testing.expectEqual(
        3,
        race_condition.amount_of_shortcuts(example_input, 2, 38, std.testing.allocator),
    );
}

test "task_1_shortcut_40" {
    const example_input = @embedFile("example_input");
    try testing.expectEqual(
        2,
        race_condition.amount_of_shortcuts(example_input, 2, 40, std.testing.allocator),
    );
}

test "task_1_shortcut_64" {
    const example_input = @embedFile("example_input");
    try testing.expectEqual(
        1,
        race_condition.amount_of_shortcuts(example_input, 2, 64, std.testing.allocator),
    );
}

test "task_1_shortcut_100" {
    const example_input = @embedFile("example_input");
    try testing.expectEqual(
        0,
        race_condition.amount_of_shortcuts(example_input, 2, 100, std.testing.allocator),
    );
}

// Test of part 2
test "task_2_76" {
    const example_input = @embedFile("example_input");
    try testing.expectEqual(
        3,
        race_condition.amount_of_shortcuts(example_input, 20, 76, std.testing.allocator),
    );
}

test "task_2_100" {
    const example_input = @embedFile("example_input");
    try testing.expectEqual(
        0,
        race_condition.amount_of_shortcuts(example_input, 20, 100, std.testing.allocator),
    );
}
