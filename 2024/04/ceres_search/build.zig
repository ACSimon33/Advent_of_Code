const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // -------------------------- Solution module --------------------------- \\
    const ceres_search = b.addModule("ceres_search", .{
        .root_source_file = b.path("src/ceres_search.zig"),
    });

    // -------------------------- Main executable --------------------------- \\
    const ceres_search_exe = b.addExecutable(.{
        .name = "ceres_search",
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    const yazap = b.dependency("yazap", .{});
    ceres_search_exe.root_module.addImport("yazap", yazap.module("yazap"));
    ceres_search_exe.root_module.addImport("ceres_search", ceres_search);
    b.installArtifact(ceres_search_exe);

    const run_cmd = b.addRunArtifact(ceres_search_exe);
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run Ceres Search (day 04) app");
    run_step.dependOn(&run_cmd.step);

    // --------------------------- Example tests ---------------------------- \\
    const ceres_search_tests = b.addTest(.{
        .name = "ceres_search_tests",
        .root_source_file = b.path("tests/example_tests.zig"),
        .target = target,
        .optimize = optimize,
    });

    ceres_search_tests.root_module.addImport("ceres_search", ceres_search);
    ceres_search_tests.root_module.addAnonymousImport("example_input", .{
        .root_source_file = b.path("input/example_input.txt"),
    });
    b.installArtifact(ceres_search_tests);

    const test_step = b.step("test", "Run Ceres Search (day 04) tests");
    test_step.dependOn(&b.addRunArtifact(ceres_search_tests).step);

    // ------------------------- Puzzle benchmarks -------------------------- \\
    const ceres_search_benchmarks = b.addExecutable(.{
        .name = "ceres_search_benchmarks",
        .root_source_file = b.path("benchmarks/puzzle_benchmarks.zig"),
        .target = target,
        .optimize = optimize,
    });

    const zbench = b.dependency("zbench", .{
        .target = target,
        .optimize = optimize,
    });
    ceres_search_benchmarks.root_module.addImport("zbench", zbench.module("zbench"));
    ceres_search_benchmarks.root_module.addImport("ceres_search", ceres_search);
    ceres_search_benchmarks.root_module.addAnonymousImport("puzzle_input", .{
        .root_source_file = b.path("input/puzzle_input.txt"),
    });
    b.installArtifact(ceres_search_benchmarks);

    const benchmark_step = b.step("benchmark", "Run Ceres Search (day 04) benchmarks");
    benchmark_step.dependOn(&b.addRunArtifact(ceres_search_benchmarks).step);
}
