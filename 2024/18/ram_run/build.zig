const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // -------------------------- Solution module --------------------------- \\
    const ram_run = b.addModule("ram_run", .{
        .root_source_file = b.path("src/ram_run.zig"),
    });

    // -------------------------- Main executable --------------------------- \\
    const ram_run_exe = b.addExecutable(.{
        .name = "ram_run",
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    const yazap = b.dependency("yazap", .{});
    ram_run_exe.root_module.addImport("yazap", yazap.module("yazap"));
    ram_run_exe.root_module.addImport("ram_run", ram_run);
    b.installArtifact(ram_run_exe);

    const run_cmd = b.addRunArtifact(ram_run_exe);
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run RAM Run (day 18) app");
    run_step.dependOn(&run_cmd.step);

    // --------------------------- Example tests ---------------------------- \\
    const ram_run_tests = b.addTest(.{
        .name = "ram_run_tests",
        .root_source_file = b.path("tests/example_tests.zig"),
        .target = target,
        .optimize = optimize,
    });

    ram_run_tests.root_module.addImport("ram_run", ram_run);
    ram_run_tests.root_module.addAnonymousImport("example_input", .{
        .root_source_file = b.path("input/example_input.txt"),
    });
    b.installArtifact(ram_run_tests);

    const test_step = b.step("test", "Run RAM Run (day 18) tests");
    test_step.dependOn(&b.addRunArtifact(ram_run_tests).step);

    // ------------------------- Puzzle benchmarks -------------------------- \\
    const ram_run_benchmarks = b.addExecutable(.{
        .name = "ram_run_benchmarks",
        .root_source_file = b.path("benchmarks/puzzle_benchmarks.zig"),
        .target = target,
        .optimize = optimize,
    });

    const zbench = b.dependency("zbench", .{
        .target = target,
        .optimize = optimize,
    });
    ram_run_benchmarks.root_module.addImport("zbench", zbench.module("zbench"));
    ram_run_benchmarks.root_module.addImport("ram_run", ram_run);
    ram_run_benchmarks.root_module.addAnonymousImport("puzzle_input", .{
        .root_source_file = b.path("input/puzzle_input.txt"),
    });
    b.installArtifact(ram_run_benchmarks);

    const benchmark_step = b.step("benchmark", "Run RAM Run (day 18) benchmarks");
    benchmark_step.dependOn(&b.addRunArtifact(ram_run_benchmarks).step);
}
