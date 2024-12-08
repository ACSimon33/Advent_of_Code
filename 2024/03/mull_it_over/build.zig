const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // -------------------------- Solution module --------------------------- \\
    const mull_it_over = b.addModule("mull_it_over", .{
        .root_source_file = b.path("src/mull_it_over.zig"),
    });

    // -------------------------- Main executable --------------------------- \\
    const mull_it_over_exe = b.addExecutable(.{
        .name = "mull_it_over",
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    const yazap = b.dependency("yazap", .{});
    mull_it_over_exe.root_module.addImport("yazap", yazap.module("yazap"));
    mull_it_over_exe.root_module.addImport("mull_it_over", mull_it_over);
    b.installArtifact(mull_it_over_exe);

    const run_cmd = b.addRunArtifact(mull_it_over_exe);
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the mull_it_over (day 03) app");
    run_step.dependOn(&run_cmd.step);

    // --------------------------- Example tests ---------------------------- \\
    const mull_it_over_tests = b.addTest(.{
        .name = "mull_it_over_tests",
        .root_source_file = b.path("tests/example_tests.zig"),
        .target = target,
        .optimize = optimize,
    });

    mull_it_over_tests.root_module.addImport("mull_it_over", mull_it_over);
    mull_it_over_tests.root_module.addAnonymousImport("example_input_1", .{
        .root_source_file = b.path("input/example_input_1.txt"),
    });
    mull_it_over_tests.root_module.addAnonymousImport("example_input_2", .{
        .root_source_file = b.path("input/example_input_2.txt"),
    });
    b.installArtifact(mull_it_over_tests);

    const test_step = b.step("test", "Run mull_it_over (day 03) tests");
    test_step.dependOn(&b.addRunArtifact(mull_it_over_tests).step);

    // ------------------------- Puzzle benchmarks -------------------------- \\
    const mull_it_over_benchmarks = b.addExecutable(.{
        .name = "mull_it_over_benchmarks",
        .root_source_file = b.path("benchmarks/puzzle_benchmarks.zig"),
        .target = target,
        .optimize = optimize,
    });

    const zbench = b.dependency("zbench", .{
        .target = target,
        .optimize = optimize,
    });
    mull_it_over_benchmarks.root_module.addImport("zbench", zbench.module("zbench"));
    mull_it_over_benchmarks.root_module.addImport("mull_it_over", mull_it_over);
    mull_it_over_benchmarks.root_module.addAnonymousImport("puzzle_input", .{
        .root_source_file = b.path("input/puzzle_input.txt"),
    });
    b.installArtifact(mull_it_over_benchmarks);

    const benchmark_step = b.step("benchmark", "Run mull_it_over (day 03) benchmarks");
    benchmark_step.dependOn(&b.addRunArtifact(mull_it_over_benchmarks).step);
}
