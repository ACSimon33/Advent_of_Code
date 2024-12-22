const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // -------------------------- Solution module --------------------------- \\
    const race_condition = b.addModule("race_condition", .{
        .root_source_file = b.path("src/race_condition.zig"),
    });

    // -------------------------- Main executable --------------------------- \\
    const race_condition_exe = b.addExecutable(.{
        .name = "race_condition",
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    const yazap = b.dependency("yazap", .{});
    race_condition_exe.root_module.addImport("yazap", yazap.module("yazap"));
    race_condition_exe.root_module.addImport("race_condition", race_condition);
    b.installArtifact(race_condition_exe);

    const run_cmd = b.addRunArtifact(race_condition_exe);
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run Race Condition (day 20) app");
    run_step.dependOn(&run_cmd.step);

    // --------------------------- Example tests ---------------------------- \\
    const race_condition_tests = b.addTest(.{
        .name = "race_condition_tests",
        .root_source_file = b.path("tests/example_tests.zig"),
        .target = target,
        .optimize = optimize,
    });

    race_condition_tests.root_module.addImport("race_condition", race_condition);
    race_condition_tests.root_module.addAnonymousImport("example_input", .{
        .root_source_file = b.path("input/example_input.txt"),
    });
    b.installArtifact(race_condition_tests);

    const test_step = b.step("test", "Run Race Condition (day 20) tests");
    test_step.dependOn(&b.addRunArtifact(race_condition_tests).step);

    // ------------------------- Puzzle benchmarks -------------------------- \\
    const race_condition_benchmarks = b.addExecutable(.{
        .name = "race_condition_benchmarks",
        .root_source_file = b.path("benchmarks/puzzle_benchmarks.zig"),
        .target = target,
        .optimize = optimize,
    });

    const zbench = b.dependency("zbench", .{
        .target = target,
        .optimize = optimize,
    });
    race_condition_benchmarks.root_module.addImport("zbench", zbench.module("zbench"));
    race_condition_benchmarks.root_module.addImport("race_condition", race_condition);
    race_condition_benchmarks.root_module.addAnonymousImport("puzzle_input", .{
        .root_source_file = b.path("input/puzzle_input.txt"),
    });
    b.installArtifact(race_condition_benchmarks);

    const benchmark_step = b.step("benchmark", "Run Race Condition (day 20) benchmarks");
    benchmark_step.dependOn(&b.addRunArtifact(race_condition_benchmarks).step);
}
