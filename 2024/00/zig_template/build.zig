const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // -------------------------- Solution module --------------------------- \\
    const zig_template = b.addModule("zig_template", .{
        .root_source_file = b.path("src/zig_template.zig"),
    });

    // -------------------------- Main executable --------------------------- \\
    const zig_template_exe = b.addExecutable(.{
        .name = "zig_template",
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    const yazap = b.dependency("yazap", .{});
    zig_template_exe.root_module.addImport("yazap", yazap.module("yazap"));
    zig_template_exe.root_module.addImport("zig_template", zig_template);
    b.installArtifact(zig_template_exe);

    const run_cmd = b.addRunArtifact(zig_template_exe);
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run Zig Template (day 00) app");
    run_step.dependOn(&run_cmd.step);

    // --------------------------- Example tests ---------------------------- \\
    const zig_template_tests = b.addTest(.{
        .name = "zig_template_tests",
        .root_source_file = b.path("tests/example_tests.zig"),
        .target = target,
        .optimize = optimize,
    });

    zig_template_tests.root_module.addImport("zig_template", zig_template);
    zig_template_tests.root_module.addAnonymousImport("example_input", .{
        .root_source_file = b.path("input/example_input.txt"),
    });
    b.installArtifact(zig_template_tests);

    const test_step = b.step("test", "Run Zig Template (day 00) tests");
    test_step.dependOn(&b.addRunArtifact(zig_template_tests).step);

    // ------------------------- Puzzle benchmarks -------------------------- \\
    const zig_template_benchmarks = b.addExecutable(.{
        .name = "zig_template_benchmarks",
        .root_source_file = b.path("benchmarks/puzzle_benchmarks.zig"),
        .target = target,
        .optimize = optimize,
    });

    const zbench = b.dependency("zbench", .{
        .target = target,
        .optimize = optimize,
    });
    zig_template_benchmarks.root_module.addImport("zbench", zbench.module("zbench"));
    zig_template_benchmarks.root_module.addImport("zig_template", zig_template);
    zig_template_benchmarks.root_module.addAnonymousImport("puzzle_input", .{
        .root_source_file = b.path("input/puzzle_input.txt"),
    });
    b.installArtifact(zig_template_benchmarks);

    const benchmark_step = b.step("benchmark", "Run Zig Template (day 00) benchmarks");
    benchmark_step.dependOn(&b.addRunArtifact(zig_template_benchmarks).step);
}
