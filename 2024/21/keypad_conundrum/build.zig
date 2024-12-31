const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // -------------------------- Solution module --------------------------- \\
    const keypad_conundrum = b.addModule("keypad_conundrum", .{
        .root_source_file = b.path("src/keypad_conundrum.zig"),
    });

    // -------------------------- Main executable --------------------------- \\
    const keypad_conundrum_exe = b.addExecutable(.{
        .name = "keypad_conundrum",
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    const yazap = b.dependency("yazap", .{});
    keypad_conundrum_exe.root_module.addImport("yazap", yazap.module("yazap"));
    keypad_conundrum_exe.root_module.addImport("keypad_conundrum", keypad_conundrum);
    b.installArtifact(keypad_conundrum_exe);

    const run_cmd = b.addRunArtifact(keypad_conundrum_exe);
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run Keypad Conundrum (day 21) app");
    run_step.dependOn(&run_cmd.step);

    // --------------------------- Example tests ---------------------------- \\
    const keypad_conundrum_tests = b.addTest(.{
        .name = "keypad_conundrum_tests",
        .root_source_file = b.path("tests/example_tests.zig"),
        .target = target,
        .optimize = optimize,
    });

    keypad_conundrum_tests.root_module.addImport("keypad_conundrum", keypad_conundrum);
    keypad_conundrum_tests.root_module.addAnonymousImport("example_input", .{
        .root_source_file = b.path("input/example_input.txt"),
    });
    b.installArtifact(keypad_conundrum_tests);

    const test_step = b.step("test", "Run Keypad Conundrum (day 21) tests");
    test_step.dependOn(&b.addRunArtifact(keypad_conundrum_tests).step);

    // ------------------------- Puzzle benchmarks -------------------------- \\
    const keypad_conundrum_benchmarks = b.addExecutable(.{
        .name = "keypad_conundrum_benchmarks",
        .root_source_file = b.path("benchmarks/puzzle_benchmarks.zig"),
        .target = target,
        .optimize = optimize,
    });

    const zbench = b.dependency("zbench", .{
        .target = target,
        .optimize = optimize,
    });
    keypad_conundrum_benchmarks.root_module.addImport("zbench", zbench.module("zbench"));
    keypad_conundrum_benchmarks.root_module.addImport("keypad_conundrum", keypad_conundrum);
    keypad_conundrum_benchmarks.root_module.addAnonymousImport("puzzle_input", .{
        .root_source_file = b.path("input/puzzle_input.txt"),
    });
    b.installArtifact(keypad_conundrum_benchmarks);

    const benchmark_step = b.step("benchmark", "Run Keypad Conundrum (day 21) benchmarks");
    benchmark_step.dependOn(&b.addRunArtifact(keypad_conundrum_benchmarks).step);
}
