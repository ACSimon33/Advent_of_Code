const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // ---------------------------- Subprojects ----------------------------- \\
    const day_00 = b.dependency("day_00_zig_template", .{
        .target = target,
        .optimize = optimize,
    });

    const day_02 = b.dependency("day_02_red_nosed_reports", .{
        .target = target,
        .optimize = optimize,
    });

    // --------------------------- Example tests ---------------------------- \\
    const test_step = b.step("test", "Run example tests");
    test_step.dependOn(&b.addRunArtifact(day_00.artifact("zig_template_tests")).step);
    test_step.dependOn(&b.addRunArtifact(day_02.artifact("red_nosed_reports_tests")).step);

    // ------------------------- Puzzle benchmarks -------------------------- \\
    const benchmark_step = b.step("benchmark", "Run puzzle benchmarks");
    benchmark_step.dependOn(&b.addRunArtifact(day_00.artifact("zig_template_benchmarks")).step);
    benchmark_step.dependOn(&b.addRunArtifact(day_02.artifact("red_nosed_reports_benchmarks")).step);
}
