const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // -------------------------- Solution module --------------------------- \\
    const code_chronicle = b.addModule("code_chronicle", .{
        .root_source_file = b.path("src/code_chronicle.zig"),
    });

    // -------------------------- Main executable --------------------------- \\
    const code_chronicle_exe = b.addExecutable(.{
        .name = "code_chronicle",
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    const yazap = b.dependency("yazap", .{});
    code_chronicle_exe.root_module.addImport("yazap", yazap.module("yazap"));
    code_chronicle_exe.root_module.addImport("code_chronicle", code_chronicle);
    b.installArtifact(code_chronicle_exe);

    const run_cmd = b.addRunArtifact(code_chronicle_exe);
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run Code Chronicle (day 25) app");
    run_step.dependOn(&run_cmd.step);

    // --------------------------- Example tests ---------------------------- \\
    const code_chronicle_tests = b.addTest(.{
        .name = "code_chronicle_tests",
        .root_source_file = b.path("tests/example_tests.zig"),
        .target = target,
        .optimize = optimize,
    });

    code_chronicle_tests.root_module.addImport("code_chronicle", code_chronicle);
    code_chronicle_tests.root_module.addAnonymousImport("example_input", .{
        .root_source_file = b.path("input/example_input.txt"),
    });
    b.installArtifact(code_chronicle_tests);

    const test_step = b.step("test", "Run Code Chronicle (day 25) tests");
    test_step.dependOn(&b.addRunArtifact(code_chronicle_tests).step);

    // ------------------------- Puzzle benchmarks -------------------------- \\
    const code_chronicle_benchmarks = b.addExecutable(.{
        .name = "code_chronicle_benchmarks",
        .root_source_file = b.path("benchmarks/puzzle_benchmarks.zig"),
        .target = target,
        .optimize = optimize,
    });

    const zbench = b.dependency("zbench", .{
        .target = target,
        .optimize = optimize,
    });
    code_chronicle_benchmarks.root_module.addImport("zbench", zbench.module("zbench"));
    code_chronicle_benchmarks.root_module.addImport("code_chronicle", code_chronicle);
    code_chronicle_benchmarks.root_module.addAnonymousImport("puzzle_input", .{
        .root_source_file = b.path("input/puzzle_input.txt"),
    });
    b.installArtifact(code_chronicle_benchmarks);

    const benchmark_step = b.step("benchmark", "Run Code Chronicle (day 25) benchmarks");
    benchmark_step.dependOn(&b.addRunArtifact(code_chronicle_benchmarks).step);
}