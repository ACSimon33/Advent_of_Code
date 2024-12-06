const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // -------------------------- Solution module --------------------------- \\
    const guard_gallivant = b.addModule("guard_gallivant", .{
        .root_source_file = b.path("src/guard_gallivant.zig"),
    });

    // -------------------------- Main executable --------------------------- \\
    const guard_gallivant_exe = b.addExecutable(.{
        .name = "guard_gallivant",
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    const yazap = b.dependency("yazap", .{});
    guard_gallivant_exe.root_module.addImport("yazap", yazap.module("yazap"));
    guard_gallivant_exe.root_module.addImport("guard_gallivant", guard_gallivant);
    b.installArtifact(guard_gallivant_exe);

    const run_cmd = b.addRunArtifact(guard_gallivant_exe);
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the guard_gallivant (day 06) app");
    run_step.dependOn(&run_cmd.step);

    // --------------------------- Example tests ---------------------------- \\
    const guard_gallivant_tests = b.addTest(.{
        .name = "guard_gallivant_tests",
        .root_source_file = b.path("tests/example_tests.zig"),
        .target = target,
        .optimize = optimize,
    });

    guard_gallivant_tests.root_module.addImport("guard_gallivant", guard_gallivant);
    guard_gallivant_tests.root_module.addAnonymousImport("example_input", .{
        .root_source_file = b.path("input/example_input.txt"),
    });
    b.installArtifact(guard_gallivant_tests);

    const test_step = b.step("test", "Run guard_gallivant (day 06) tests");
    test_step.dependOn(&b.addRunArtifact(guard_gallivant_tests).step);

    // ------------------------- Puzzle benchmarks -------------------------- \\
    const guard_gallivant_benchmarks = b.addExecutable(.{
        .name = "guard_gallivant_benchmarks",
        .root_source_file = b.path("benchmarks/puzzle_benchmarks.zig"),
        .target = target,
        .optimize = optimize,
    });

    const zbench = b.dependency("zbench", .{
        .target = target,
        .optimize = optimize,
    });
    guard_gallivant_benchmarks.root_module.addImport("zbench", zbench.module("zbench"));
    guard_gallivant_benchmarks.root_module.addImport("guard_gallivant", guard_gallivant);
    guard_gallivant_benchmarks.root_module.addAnonymousImport("puzzle_input", .{
        .root_source_file = b.path("input/puzzle_input.txt"),
    });
    b.installArtifact(guard_gallivant_benchmarks);

    const benchmark_step = b.step("benchmark", "Run guard_gallivant (day 06) benchmarks");
    benchmark_step.dependOn(&b.addRunArtifact(guard_gallivant_benchmarks).step);
}
