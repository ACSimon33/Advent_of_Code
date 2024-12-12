const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // -------------------------- Solution module --------------------------- \\
    const garden_groups = b.addModule("garden_groups", .{
        .root_source_file = b.path("src/garden_groups.zig"),
    });

    // -------------------------- Main executable --------------------------- \\
    const garden_groups_exe = b.addExecutable(.{
        .name = "garden_groups",
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    const yazap = b.dependency("yazap", .{});
    garden_groups_exe.root_module.addImport("yazap", yazap.module("yazap"));
    garden_groups_exe.root_module.addImport("garden_groups", garden_groups);
    b.installArtifact(garden_groups_exe);

    const run_cmd = b.addRunArtifact(garden_groups_exe);
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run Garden Groups (day 12) app");
    run_step.dependOn(&run_cmd.step);

    // --------------------------- Example tests ---------------------------- \\
    const garden_groups_tests = b.addTest(.{
        .name = "garden_groups_tests",
        .root_source_file = b.path("tests/example_tests.zig"),
        .target = target,
        .optimize = optimize,
    });

    garden_groups_tests.root_module.addImport("garden_groups", garden_groups);
    inline for (1..6) |i| {
        const num_str = std.fmt.comptimePrint("{!}", .{i});
        garden_groups_tests.root_module.addAnonymousImport(
            "example_input_" ++ num_str,
            .{
                .root_source_file = b.path("input/example_input_" ++ num_str ++ ".txt"),
            },
        );
    }
    b.installArtifact(garden_groups_tests);

    const test_step = b.step("test", "Run Garden Groups (day 12) tests");
    test_step.dependOn(&b.addRunArtifact(garden_groups_tests).step);

    // ------------------------- Puzzle benchmarks -------------------------- \\
    const garden_groups_benchmarks = b.addExecutable(.{
        .name = "garden_groups_benchmarks",
        .root_source_file = b.path("benchmarks/puzzle_benchmarks.zig"),
        .target = target,
        .optimize = optimize,
    });

    const zbench = b.dependency("zbench", .{
        .target = target,
        .optimize = optimize,
    });
    garden_groups_benchmarks.root_module.addImport("zbench", zbench.module("zbench"));
    garden_groups_benchmarks.root_module.addImport("garden_groups", garden_groups);
    garden_groups_benchmarks.root_module.addAnonymousImport("puzzle_input", .{
        .root_source_file = b.path("input/puzzle_input.txt"),
    });
    b.installArtifact(garden_groups_benchmarks);

    const benchmark_step = b.step("benchmark", "Run Garden Groups (day 12) benchmarks");
    benchmark_step.dependOn(&b.addRunArtifact(garden_groups_benchmarks).step);
}
