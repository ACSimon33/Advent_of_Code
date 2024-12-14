const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // -------------------------- Solution module --------------------------- \\
    const restroom_redoubt = b.addModule("restroom_redoubt", .{
        .root_source_file = b.path("src/restroom_redoubt.zig"),
    });

    // -------------------------- Main executable --------------------------- \\
    const restroom_redoubt_exe = b.addExecutable(.{
        .name = "restroom_redoubt",
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    const yazap = b.dependency("yazap", .{});
    restroom_redoubt_exe.root_module.addImport("yazap", yazap.module("yazap"));
    restroom_redoubt_exe.root_module.addImport("restroom_redoubt", restroom_redoubt);
    b.installArtifact(restroom_redoubt_exe);

    const run_cmd = b.addRunArtifact(restroom_redoubt_exe);
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run Restroom Redoubt (day 14) app");
    run_step.dependOn(&run_cmd.step);

    // --------------------------- Example tests ---------------------------- \\
    const restroom_redoubt_tests = b.addTest(.{
        .name = "restroom_redoubt_tests",
        .root_source_file = b.path("tests/example_tests.zig"),
        .target = target,
        .optimize = optimize,
    });

    restroom_redoubt_tests.root_module.addImport("restroom_redoubt", restroom_redoubt);
    restroom_redoubt_tests.root_module.addAnonymousImport("example_input", .{
        .root_source_file = b.path("input/example_input.txt"),
    });
    b.installArtifact(restroom_redoubt_tests);

    const test_step = b.step("test", "Run Restroom Redoubt (day 14) tests");
    test_step.dependOn(&b.addRunArtifact(restroom_redoubt_tests).step);

    // ------------------------- Puzzle benchmarks -------------------------- \\
    const restroom_redoubt_benchmarks = b.addExecutable(.{
        .name = "restroom_redoubt_benchmarks",
        .root_source_file = b.path("benchmarks/puzzle_benchmarks.zig"),
        .target = target,
        .optimize = optimize,
    });

    const zbench = b.dependency("zbench", .{
        .target = target,
        .optimize = optimize,
    });
    restroom_redoubt_benchmarks.root_module.addImport("zbench", zbench.module("zbench"));
    restroom_redoubt_benchmarks.root_module.addImport("restroom_redoubt", restroom_redoubt);
    restroom_redoubt_benchmarks.root_module.addAnonymousImport("puzzle_input", .{
        .root_source_file = b.path("input/puzzle_input.txt"),
    });
    b.installArtifact(restroom_redoubt_benchmarks);

    const benchmark_step = b.step("benchmark", "Run Restroom Redoubt (day 14) benchmarks");
    benchmark_step.dependOn(&b.addRunArtifact(restroom_redoubt_benchmarks).step);
}
