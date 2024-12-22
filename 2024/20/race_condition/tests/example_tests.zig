const std = @import("std");
const race_condition = @import("race_condition");
const testing = std.testing;

// Test of part 1
test "task_1_shortcut_2" {
    const example_input = @embedFile("example_input");
    try testing.expectEqual(
        44,
        race_condition.solution_1(example_input, 2, std.testing.allocator),
    );
}

test "task_1_shortcut_4" {
    const example_input = @embedFile("example_input");
    try testing.expectEqual(
        30,
        race_condition.solution_1(example_input, 4, std.testing.allocator),
    );
}

test "task_1_shortcut_6" {
    const example_input = @embedFile("example_input");
    try testing.expectEqual(
        16,
        race_condition.solution_1(example_input, 6, std.testing.allocator),
    );
}

test "task_1_shortcut_8" {
    const example_input = @embedFile("example_input");
    try testing.expectEqual(
        14,
        race_condition.solution_1(example_input, 8, std.testing.allocator),
    );
}

test "task_1_shortcut_10" {
    const example_input = @embedFile("example_input");
    try testing.expectEqual(
        10,
        race_condition.solution_1(example_input, 10, std.testing.allocator),
    );
}

test "task_1_shortcut_12" {
    const example_input = @embedFile("example_input");
    try testing.expectEqual(
        8,
        race_condition.solution_1(example_input, 12, std.testing.allocator),
    );
}

test "task_1_shortcut_20" {
    const example_input = @embedFile("example_input");
    try testing.expectEqual(
        5,
        race_condition.solution_1(example_input, 20, std.testing.allocator),
    );
}

test "task_1_shortcut_36" {
    const example_input = @embedFile("example_input");
    try testing.expectEqual(
        4,
        race_condition.solution_1(example_input, 36, std.testing.allocator),
    );
}

test "task_1_shortcut_38" {
    const example_input = @embedFile("example_input");
    try testing.expectEqual(
        3,
        race_condition.solution_1(example_input, 38, std.testing.allocator),
    );
}

test "task_1_shortcut_40" {
    const example_input = @embedFile("example_input");
    try testing.expectEqual(
        2,
        race_condition.solution_1(example_input, 40, std.testing.allocator),
    );
}

test "task_1_shortcut_64" {
    const example_input = @embedFile("example_input");
    try testing.expectEqual(
        1,
        race_condition.solution_1(example_input, 64, std.testing.allocator),
    );
}

test "task_1_shortcut_100" {
    const example_input = @embedFile("example_input");
    try testing.expectEqual(
        0,
        race_condition.solution_1(example_input, 100, std.testing.allocator),
    );
}

// Test of part 2
test "task_2_76" {
    const example_input = @embedFile("example_input");
    try testing.expectEqual(
        3,
        race_condition.solution_2(example_input, 76, std.testing.allocator),
    );
}

test "task_2_100" {
    const example_input = @embedFile("example_input");
    try testing.expectEqual(
        0,
        race_condition.solution_2(example_input, 100, std.testing.allocator),
    );
}
