const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // -------------------------- Solution module --------------------------- \\
    const historian_hysteria = b.addModule("historian_hysteria", .{
        .root_source_file = b.path("src/historian_hysteria.zig"),
    });

    // -------------------------- Main executable --------------------------- \\
    const historian_hysteria_exe = b.addExecutable(.{
        .name = "historian_hysteria",
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    const yazap = b.dependency("yazap", .{});
    historian_hysteria_exe.root_module.addImport("yazap", yazap.module("yazap"));
    historian_hysteria_exe.root_module.addImport("historian_hysteria", historian_hysteria);
    b.installArtifact(historian_hysteria_exe);

    const run_cmd = b.addRunArtifact(historian_hysteria_exe);
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run Historian Hysteria (day 01) app");
    run_step.dependOn(&run_cmd.step);

    // --------------------------- Example tests ---------------------------- \\
    const historian_hysteria_tests = b.addTest(.{
        .name = "historian_hysteria_tests",
        .root_source_file = b.path("tests/example_tests.zig"),
        .target = target,
        .optimize = optimize,
    });

    historian_hysteria_tests.root_module.addImport("historian_hysteria", historian_hysteria);
    historian_hysteria_tests.root_module.addAnonymousImport("example_input", .{
        .root_source_file = b.path("input/example_input.txt"),
    });
    b.installArtifact(historian_hysteria_tests);

    const test_step = b.step("test", "Run Historian Hysteria (day 01) tests");
    test_step.dependOn(&b.addRunArtifact(historian_hysteria_tests).step);

    // ------------------------- Puzzle benchmarks -------------------------- \\
    const historian_hysteria_benchmarks = b.addExecutable(.{
        .name = "historian_hysteria_benchmarks",
        .root_source_file = b.path("benchmarks/puzzle_benchmarks.zig"),
        .target = target,
        .optimize = optimize,
    });

    const zbench = b.dependency("zbench", .{
        .target = target,
        .optimize = optimize,
    });
    historian_hysteria_benchmarks.root_module.addImport("zbench", zbench.module("zbench"));
    historian_hysteria_benchmarks.root_module.addImport("historian_hysteria", historian_hysteria);
    historian_hysteria_benchmarks.root_module.addAnonymousImport("puzzle_input", .{
        .root_source_file = b.path("input/puzzle_input.txt"),
    });
    b.installArtifact(historian_hysteria_benchmarks);

    const benchmark_step = b.step("benchmark", "Run Historian Hysteria (day 01) benchmarks");
    benchmark_step.dependOn(&b.addRunArtifact(historian_hysteria_benchmarks).step);
}
