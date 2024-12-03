const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // -------------------------- Solution module --------------------------- \\
    const red_nosed_reports = b.addModule("red_nosed_reports", .{
        .root_source_file = b.path("src/red_nosed_reports.zig"),
    });

    // -------------------------- Main executable --------------------------- \\
    const red_nosed_reports_exe = b.addExecutable(.{
        .name = "red_nosed_reports",
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    const yazap = b.dependency("yazap", .{});
    red_nosed_reports_exe.root_module.addImport("yazap", yazap.module("yazap"));
    red_nosed_reports_exe.root_module.addImport("red_nosed_reports", red_nosed_reports);
    b.installArtifact(red_nosed_reports_exe);

    const run_cmd = b.addRunArtifact(red_nosed_reports_exe);
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the red_nosed_reports (day 02) app");
    run_step.dependOn(&run_cmd.step);

    // --------------------------- Example tests ---------------------------- \\
    const red_nosed_reports_tests = b.addTest(.{
        .name = "red_nosed_reports_tests",
        .root_source_file = b.path("tests/example_tests.zig"),
        .target = target,
        .optimize = optimize,
    });

    red_nosed_reports_tests.root_module.addImport("red_nosed_reports", red_nosed_reports);
    red_nosed_reports_tests.root_module.addAnonymousImport("example_input", .{
        .root_source_file = b.path("input/example_input.txt"),
    });
    b.installArtifact(red_nosed_reports_tests);

    const test_step = b.step("test", "Run red_nosed_reports (day 02) tests");
    test_step.dependOn(&b.addRunArtifact(red_nosed_reports_tests).step);

    // ------------------------- Puzzle benchmarks -------------------------- \\
    const red_nosed_reports_benchmarks = b.addExecutable(.{
        .name = "red_nosed_reports_benchmarks",
        .root_source_file = b.path("benchmarks/puzzle_benchmarks.zig"),
        .target = target,
        .optimize = optimize,
    });

    const zbench = b.dependency("zbench", .{
        .target = target,
        .optimize = optimize,
    });
    red_nosed_reports_benchmarks.root_module.addImport("zbench", zbench.module("zbench"));
    red_nosed_reports_benchmarks.root_module.addImport("red_nosed_reports", red_nosed_reports);
    red_nosed_reports_benchmarks.root_module.addAnonymousImport("puzzle_input", .{
        .root_source_file = b.path("input/puzzle_input.txt"),
    });
    b.installArtifact(red_nosed_reports_benchmarks);

    const benchmark_step = b.step("benchmark", "Run red_nosed_reports (day 02) benchmarks");
    benchmark_step.dependOn(&b.addRunArtifact(red_nosed_reports_benchmarks).step);
}
