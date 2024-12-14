const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // -------------------------- Solution module --------------------------- \\
    const bridge_repair = b.addModule("bridge_repair", .{
        .root_source_file = b.path("src/bridge_repair.zig"),
    });

    // -------------------------- Main executable --------------------------- \\
    const bridge_repair_exe = b.addExecutable(.{
        .name = "bridge_repair",
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    const yazap = b.dependency("yazap", .{});
    bridge_repair_exe.root_module.addImport("yazap", yazap.module("yazap"));
    bridge_repair_exe.root_module.addImport("bridge_repair", bridge_repair);
    b.installArtifact(bridge_repair_exe);

    const run_cmd = b.addRunArtifact(bridge_repair_exe);
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run Bridge Repair (day 07) app");
    run_step.dependOn(&run_cmd.step);

    // --------------------------- Example tests ---------------------------- \\
    const bridge_repair_tests = b.addTest(.{
        .name = "bridge_repair_tests",
        .root_source_file = b.path("tests/example_tests.zig"),
        .target = target,
        .optimize = optimize,
    });

    bridge_repair_tests.root_module.addImport("bridge_repair", bridge_repair);
    bridge_repair_tests.root_module.addAnonymousImport("example_input", .{
        .root_source_file = b.path("input/example_input.txt"),
    });
    b.installArtifact(bridge_repair_tests);

    const test_step = b.step("test", "Run Bridge Repair (day 07) tests");
    test_step.dependOn(&b.addRunArtifact(bridge_repair_tests).step);

    // ------------------------- Puzzle benchmarks -------------------------- \\
    const bridge_repair_benchmarks = b.addExecutable(.{
        .name = "bridge_repair_benchmarks",
        .root_source_file = b.path("benchmarks/puzzle_benchmarks.zig"),
        .target = target,
        .optimize = optimize,
    });

    const zbench = b.dependency("zbench", .{
        .target = target,
        .optimize = optimize,
    });
    bridge_repair_benchmarks.root_module.addImport("zbench", zbench.module("zbench"));
    bridge_repair_benchmarks.root_module.addImport("bridge_repair", bridge_repair);
    bridge_repair_benchmarks.root_module.addAnonymousImport("puzzle_input", .{
        .root_source_file = b.path("input/puzzle_input.txt"),
    });
    b.installArtifact(bridge_repair_benchmarks);

    const benchmark_step = b.step("benchmark", "Run Bridge Repair (day 07) benchmarks");
    benchmark_step.dependOn(&b.addRunArtifact(bridge_repair_benchmarks).step);
}
