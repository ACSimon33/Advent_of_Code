const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // -------------------------- Solution module --------------------------- \\
    const red_nosed_reports = b.addModule("red_nosed_reports", .{
        .root_source_file = b.path("src/red_nosed_reports.zig"),
    });

    // -------------------------- Main executable --------------------------- \\
    const exe = b.addExecutable(.{
        .name = "red_nosed_reports",
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    const yazap = b.dependency("yazap", .{});
    exe.root_module.addImport("yazap", yazap.module("yazap"));
    exe.root_module.addImport("red_nosed_reports", red_nosed_reports);
    b.installArtifact(exe);

    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);

    // --------------------------- Example tests ---------------------------- \\
    const example_tests = b.addTest(.{
        .root_source_file = b.path("tests/example_tests.zig"),
        .target = target,
        .optimize = optimize,
    });

    example_tests.root_module.addImport("red_nosed_reports", red_nosed_reports);
    example_tests.root_module.addAnonymousImport("example_input", .{
        .root_source_file = b.path("input/example_input.txt"),
    });

    const run_example_tests = b.addRunArtifact(example_tests);
    const test_step = b.step("test", "Run example tests");
    test_step.dependOn(&run_example_tests.step);

    // ------------------------- Puzzle benchmarks -------------------------- \\
    const puzzle_benchmarks = b.addExecutable(.{
        .name = "red_nosed_reports_benchmark",
        .root_source_file = b.path("benchmarks/puzzle_benchmarks.zig"),
        .target = target,
        .optimize = optimize,
    });

    const zbench = b.dependency("zbench", .{
        .target = target,
        .optimize = optimize,
    });
    puzzle_benchmarks.root_module.addImport("zbench", zbench.module("zbench"));
    puzzle_benchmarks.root_module.addImport("red_nosed_reports", red_nosed_reports);
    puzzle_benchmarks.root_module.addAnonymousImport("puzzle_input", .{
        .root_source_file = b.path("input/puzzle_input.txt"),
    });

    const run_puzzle_benchmarks = b.addRunArtifact(puzzle_benchmarks);
    const benchmark_step = b.step("benchmark", "Run puzzle benchmarks");
    benchmark_step.dependOn(&run_puzzle_benchmarks.step);
}
