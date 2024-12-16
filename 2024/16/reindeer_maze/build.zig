const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // -------------------------- Solution module --------------------------- \\
    const reindeer_maze = b.addModule("reindeer_maze", .{
        .root_source_file = b.path("src/reindeer_maze.zig"),
    });

    // -------------------------- Main executable --------------------------- \\
    const reindeer_maze_exe = b.addExecutable(.{
        .name = "reindeer_maze",
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    const yazap = b.dependency("yazap", .{});
    reindeer_maze_exe.root_module.addImport("yazap", yazap.module("yazap"));
    reindeer_maze_exe.root_module.addImport("reindeer_maze", reindeer_maze);
    b.installArtifact(reindeer_maze_exe);

    const run_cmd = b.addRunArtifact(reindeer_maze_exe);
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run Reindeer Maze (day 16) app");
    run_step.dependOn(&run_cmd.step);

    // --------------------------- Example tests ---------------------------- \\
    const reindeer_maze_tests = b.addTest(.{
        .name = "reindeer_maze_tests",
        .root_source_file = b.path("tests/example_tests.zig"),
        .target = target,
        .optimize = optimize,
    });

    reindeer_maze_tests.root_module.addImport("reindeer_maze", reindeer_maze);
    inline for (1..3) |i| {
        const num_str = std.fmt.comptimePrint("{!}", .{i});
        reindeer_maze_tests.root_module.addAnonymousImport(
            "example_input_" ++ num_str,
            .{
                .root_source_file = b.path("input/example_input_" ++ num_str ++ ".txt"),
            },
        );
    }
    b.installArtifact(reindeer_maze_tests);

    const test_step = b.step("test", "Run Reindeer Maze (day 16) tests");
    test_step.dependOn(&b.addRunArtifact(reindeer_maze_tests).step);

    // ------------------------- Puzzle benchmarks -------------------------- \\
    const reindeer_maze_benchmarks = b.addExecutable(.{
        .name = "reindeer_maze_benchmarks",
        .root_source_file = b.path("benchmarks/puzzle_benchmarks.zig"),
        .target = target,
        .optimize = optimize,
    });

    const zbench = b.dependency("zbench", .{
        .target = target,
        .optimize = optimize,
    });
    reindeer_maze_benchmarks.root_module.addImport("zbench", zbench.module("zbench"));
    reindeer_maze_benchmarks.root_module.addImport("reindeer_maze", reindeer_maze);
    reindeer_maze_benchmarks.root_module.addAnonymousImport("puzzle_input", .{
        .root_source_file = b.path("input/puzzle_input.txt"),
    });
    b.installArtifact(reindeer_maze_benchmarks);

    const benchmark_step = b.step("benchmark", "Run Reindeer Maze (day 16) benchmarks");
    benchmark_step.dependOn(&b.addRunArtifact(reindeer_maze_benchmarks).step);
}
