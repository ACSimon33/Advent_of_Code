const std = @import("std");
const reindeer_maze = @import("reindeer_maze");
const testing = std.testing;

// Test of part 1
test "task_1_input_1" {
    const example_input = @embedFile("example_input_1");
    try testing.expectEqual(
        7036,
        reindeer_maze.lowest_maze_score(example_input),
    );
}

test "task_1_input_2" {
    const example_input = @embedFile("example_input_2");
    try testing.expectEqual(
        11048,
        reindeer_maze.lowest_maze_score(example_input),
    );
}

// Test of part 2
test "task_2_input_1" {
    const example_input = @embedFile("example_input_1");
    try testing.expectEqual(
        45,
        reindeer_maze.amount_of_viewing_positions(example_input),
    );
}

test "task_2_input_2" {
    const example_input = @embedFile("example_input_2");
    try testing.expectEqual(
        64,
        reindeer_maze.amount_of_viewing_positions(example_input),
    );
}
