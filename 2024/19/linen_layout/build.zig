const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // -------------------------- Solution module --------------------------- \\
    const linen_layout = b.addModule("linen_layout", .{
        .root_source_file = b.path("src/linen_layout.zig"),
    });

    // -------------------------- Main executable --------------------------- \\
    const linen_layout_exe = b.addExecutable(.{
        .name = "linen_layout",
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    const yazap = b.dependency("yazap", .{});
    linen_layout_exe.root_module.addImport("yazap", yazap.module("yazap"));
    linen_layout_exe.root_module.addImport("linen_layout", linen_layout);
    b.installArtifact(linen_layout_exe);

    const run_cmd = b.addRunArtifact(linen_layout_exe);
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run Linen Layout (day 19) app");
    run_step.dependOn(&run_cmd.step);

    // --------------------------- Example tests ---------------------------- \\
    const linen_layout_tests = b.addTest(.{
        .name = "linen_layout_tests",
        .root_source_file = b.path("tests/example_tests.zig"),
        .target = target,
        .optimize = optimize,
    });

    linen_layout_tests.root_module.addImport("linen_layout", linen_layout);
    linen_layout_tests.root_module.addAnonymousImport("example_input", .{
        .root_source_file = b.path("input/example_input.txt"),
    });
    b.installArtifact(linen_layout_tests);

    const test_step = b.step("test", "Run Linen Layout (day 19) tests");
    test_step.dependOn(&b.addRunArtifact(linen_layout_tests).step);

    // ------------------------- Puzzle benchmarks -------------------------- \\
    const linen_layout_benchmarks = b.addExecutable(.{
        .name = "linen_layout_benchmarks",
        .root_source_file = b.path("benchmarks/puzzle_benchmarks.zig"),
        .target = target,
        .optimize = optimize,
    });

    const zbench = b.dependency("zbench", .{
        .target = target,
        .optimize = optimize,
    });
    linen_layout_benchmarks.root_module.addImport("zbench", zbench.module("zbench"));
    linen_layout_benchmarks.root_module.addImport("linen_layout", linen_layout);
    linen_layout_benchmarks.root_module.addAnonymousImport("puzzle_input", .{
        .root_source_file = b.path("input/puzzle_input.txt"),
    });
    b.installArtifact(linen_layout_benchmarks);

    const benchmark_step = b.step("benchmark", "Run Linen Layout (day 19) benchmarks");
    benchmark_step.dependOn(&b.addRunArtifact(linen_layout_benchmarks).step);
}
