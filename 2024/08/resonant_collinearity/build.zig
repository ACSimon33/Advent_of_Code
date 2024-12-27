const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // -------------------------- Solution module --------------------------- \\
    const resonant_collinearity = b.addModule("resonant_collinearity", .{
        .root_source_file = b.path("src/resonant_collinearity.zig"),
    });

    // -------------------------- Main executable --------------------------- \\
    const resonant_collinearity_exe = b.addExecutable(.{
        .name = "resonant_collinearity",
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    const yazap = b.dependency("yazap", .{});
    resonant_collinearity_exe.root_module.addImport("yazap", yazap.module("yazap"));
    resonant_collinearity_exe.root_module.addImport("resonant_collinearity", resonant_collinearity);
    b.installArtifact(resonant_collinearity_exe);

    const run_cmd = b.addRunArtifact(resonant_collinearity_exe);
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run Resonant Collinearity (day 08) app");
    run_step.dependOn(&run_cmd.step);

    // --------------------------- Example tests ---------------------------- \\
    const resonant_collinearity_tests = b.addTest(.{
        .name = "resonant_collinearity_tests",
        .root_source_file = b.path("tests/example_tests.zig"),
        .target = target,
        .optimize = optimize,
    });

    resonant_collinearity_tests.root_module.addImport("resonant_collinearity", resonant_collinearity);
    inline for (1..6) |i| {
        const num_str = std.fmt.comptimePrint("{!}", .{i});
        resonant_collinearity_tests.root_module.addAnonymousImport(
            "example_input_" ++ num_str,
            .{
                .root_source_file = b.path("input/example_input_" ++ num_str ++ ".txt"),
            },
        );
    }
    b.installArtifact(resonant_collinearity_tests);

    const test_step = b.step("test", "Run Resonant Collinearity (day 08) tests");
    test_step.dependOn(&b.addRunArtifact(resonant_collinearity_tests).step);

    // ------------------------- Puzzle benchmarks -------------------------- \\
    const resonant_collinearity_benchmarks = b.addExecutable(.{
        .name = "resonant_collinearity_benchmarks",
        .root_source_file = b.path("benchmarks/puzzle_benchmarks.zig"),
        .target = target,
        .optimize = optimize,
    });

    const zbench = b.dependency("zbench", .{
        .target = target,
        .optimize = optimize,
    });
    resonant_collinearity_benchmarks.root_module.addImport("zbench", zbench.module("zbench"));
    resonant_collinearity_benchmarks.root_module.addImport("resonant_collinearity", resonant_collinearity);
    resonant_collinearity_benchmarks.root_module.addAnonymousImport("puzzle_input", .{
        .root_source_file = b.path("input/puzzle_input.txt"),
    });
    b.installArtifact(resonant_collinearity_benchmarks);

    const benchmark_step = b.step("benchmark", "Run Resonant Collinearity (day 08) benchmarks");
    benchmark_step.dependOn(&b.addRunArtifact(resonant_collinearity_benchmarks).step);
}
