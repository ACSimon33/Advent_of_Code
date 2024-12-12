const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // -------------------------- Solution module --------------------------- \\
    const plutonian_pebbles = b.addModule("plutonian_pebbles", .{
        .root_source_file = b.path("src/plutonian_pebbles.zig"),
    });

    // -------------------------- Main executable --------------------------- \\
    const plutonian_pebbles_exe = b.addExecutable(.{
        .name = "plutonian_pebbles",
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    const yazap = b.dependency("yazap", .{});
    plutonian_pebbles_exe.root_module.addImport("yazap", yazap.module("yazap"));
    plutonian_pebbles_exe.root_module.addImport("plutonian_pebbles", plutonian_pebbles);
    b.installArtifact(plutonian_pebbles_exe);

    const run_cmd = b.addRunArtifact(plutonian_pebbles_exe);
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the Plutonian Pebbles (day 11) app");
    run_step.dependOn(&run_cmd.step);

    // --------------------------- Example tests ---------------------------- \\
    const plutonian_pebbles_tests = b.addTest(.{
        .name = "plutonian_pebbles_tests",
        .root_source_file = b.path("tests/example_tests.zig"),
        .target = target,
        .optimize = optimize,
    });

    plutonian_pebbles_tests.root_module.addImport("plutonian_pebbles", plutonian_pebbles);
    plutonian_pebbles_tests.root_module.addAnonymousImport("example_input", .{
        .root_source_file = b.path("input/example_input.txt"),
    });
    b.installArtifact(plutonian_pebbles_tests);

    const test_step = b.step("test", "Run Plutonian Pebbles (day 11) tests");
    test_step.dependOn(&b.addRunArtifact(plutonian_pebbles_tests).step);

    // ------------------------- Puzzle benchmarks -------------------------- \\
    const plutonian_pebbles_benchmarks = b.addExecutable(.{
        .name = "plutonian_pebbles_benchmarks",
        .root_source_file = b.path("benchmarks/puzzle_benchmarks.zig"),
        .target = target,
        .optimize = optimize,
    });

    const zbench = b.dependency("zbench", .{
        .target = target,
        .optimize = optimize,
    });
    plutonian_pebbles_benchmarks.root_module.addImport("zbench", zbench.module("zbench"));
    plutonian_pebbles_benchmarks.root_module.addImport("plutonian_pebbles", plutonian_pebbles);
    plutonian_pebbles_benchmarks.root_module.addAnonymousImport("puzzle_input", .{
        .root_source_file = b.path("input/puzzle_input.txt"),
    });
    b.installArtifact(plutonian_pebbles_benchmarks);

    const benchmark_step = b.step("benchmark", "Run Plutonian Pebbles (day 11) benchmarks");
    benchmark_step.dependOn(&b.addRunArtifact(plutonian_pebbles_benchmarks).step);
}
