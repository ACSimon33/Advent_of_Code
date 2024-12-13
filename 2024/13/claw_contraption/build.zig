const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // -------------------------- Solution module --------------------------- \\
    const claw_contraption = b.addModule("claw_contraption", .{
        .root_source_file = b.path("src/claw_contraption.zig"),
    });

    // -------------------------- Main executable --------------------------- \\
    const claw_contraption_exe = b.addExecutable(.{
        .name = "claw_contraption",
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    const yazap = b.dependency("yazap", .{});
    claw_contraption_exe.root_module.addImport("yazap", yazap.module("yazap"));
    claw_contraption_exe.root_module.addImport("claw_contraption", claw_contraption);
    b.installArtifact(claw_contraption_exe);

    const run_cmd = b.addRunArtifact(claw_contraption_exe);
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run Claw Contraption (day 13) app");
    run_step.dependOn(&run_cmd.step);

    // --------------------------- Example tests ---------------------------- \\
    const claw_contraption_tests = b.addTest(.{
        .name = "claw_contraption_tests",
        .root_source_file = b.path("tests/example_tests.zig"),
        .target = target,
        .optimize = optimize,
    });

    claw_contraption_tests.root_module.addImport("claw_contraption", claw_contraption);
    claw_contraption_tests.root_module.addAnonymousImport("example_input", .{
        .root_source_file = b.path("input/example_input.txt"),
    });
    b.installArtifact(claw_contraption_tests);

    const test_step = b.step("test", "Run Claw Contraption (day 13) tests");
    test_step.dependOn(&b.addRunArtifact(claw_contraption_tests).step);

    // ------------------------- Puzzle benchmarks -------------------------- \\
    const claw_contraption_benchmarks = b.addExecutable(.{
        .name = "claw_contraption_benchmarks",
        .root_source_file = b.path("benchmarks/puzzle_benchmarks.zig"),
        .target = target,
        .optimize = optimize,
    });

    const zbench = b.dependency("zbench", .{
        .target = target,
        .optimize = optimize,
    });
    claw_contraption_benchmarks.root_module.addImport("zbench", zbench.module("zbench"));
    claw_contraption_benchmarks.root_module.addImport("claw_contraption", claw_contraption);
    claw_contraption_benchmarks.root_module.addAnonymousImport("puzzle_input", .{
        .root_source_file = b.path("input/puzzle_input.txt"),
    });
    b.installArtifact(claw_contraption_benchmarks);

    const benchmark_step = b.step("benchmark", "Run Claw Contraption (day 13) benchmarks");
    benchmark_step.dependOn(&b.addRunArtifact(claw_contraption_benchmarks).step);
}
