const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // -------------------------- Solution module --------------------------- \\
    const print_queue = b.addModule("print_queue", .{
        .root_source_file = b.path("src/print_queue.zig"),
    });

    // -------------------------- Main executable --------------------------- \\
    const print_queue_exe = b.addExecutable(.{
        .name = "print_queue",
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    const yazap = b.dependency("yazap", .{});
    print_queue_exe.root_module.addImport("yazap", yazap.module("yazap"));
    print_queue_exe.root_module.addImport("print_queue", print_queue);
    b.installArtifact(print_queue_exe);

    const run_cmd = b.addRunArtifact(print_queue_exe);
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run Print Queue (day 05) app");
    run_step.dependOn(&run_cmd.step);

    // --------------------------- Example tests ---------------------------- \\
    const print_queue_tests = b.addTest(.{
        .name = "print_queue_tests",
        .root_source_file = b.path("tests/example_tests.zig"),
        .target = target,
        .optimize = optimize,
    });

    print_queue_tests.root_module.addImport("print_queue", print_queue);
    print_queue_tests.root_module.addAnonymousImport("example_input", .{
        .root_source_file = b.path("input/example_input.txt"),
    });
    b.installArtifact(print_queue_tests);

    const test_step = b.step("test", "Run Print Queue (day 05) tests");
    test_step.dependOn(&b.addRunArtifact(print_queue_tests).step);

    // ------------------------- Puzzle benchmarks -------------------------- \\
    const print_queue_benchmarks = b.addExecutable(.{
        .name = "print_queue_benchmarks",
        .root_source_file = b.path("benchmarks/puzzle_benchmarks.zig"),
        .target = target,
        .optimize = optimize,
    });

    const zbench = b.dependency("zbench", .{
        .target = target,
        .optimize = optimize,
    });
    print_queue_benchmarks.root_module.addImport("zbench", zbench.module("zbench"));
    print_queue_benchmarks.root_module.addImport("print_queue", print_queue);
    print_queue_benchmarks.root_module.addAnonymousImport("puzzle_input", .{
        .root_source_file = b.path("input/puzzle_input.txt"),
    });
    b.installArtifact(print_queue_benchmarks);

    const benchmark_step = b.step("benchmark", "Run Print Queue (day 05) benchmarks");
    benchmark_step.dependOn(&b.addRunArtifact(print_queue_benchmarks).step);
}
