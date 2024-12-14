const std = @import("std");
const string = []const u8;
const ResolvedTarget = std.Build.ResolvedTarget;
const OptimizeMode = std.builtin.OptimizeMode;
const Step = std.Build.Step;

var previous_test_step: ?*Step = null;
var previous_benchmark_step: ?*Step = null;

/// Add a dependency for each day
fn add_subproject(
    b: *std.Build,
    target: ResolvedTarget,
    optimize: OptimizeMode,
    test_step: *Step,
    benchmark_step: *Step,
    comptime day: string,
    comptime name: string,
) void {
    const subproject = b.dependency("day_" ++ day ++ "_" ++ name, .{
        .target = target,
        .optimize = optimize,
    });

    const subproject_test_step = &b.addRunArtifact(subproject.artifact(name ++ "_tests")).step;
    if (previous_test_step) |prev_subproject_test_step| {
        subproject_test_step.dependOn(prev_subproject_test_step);
    }
    test_step.dependOn(subproject_test_step);
    previous_test_step = subproject_test_step;

    const subproject_benchmark_step = &b.addRunArtifact(subproject.artifact(name ++ "_benchmarks")).step;
    if (previous_benchmark_step) |prev_subproject_benchmark_step| {
        subproject_benchmark_step.dependOn(prev_subproject_benchmark_step);
    }
    benchmark_step.dependOn(subproject_benchmark_step);
    previous_benchmark_step = subproject_benchmark_step;
}

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const test_step = b.step("test", "Run example tests");
    const benchmark_step = b.step("benchmark", "Run puzzle benchmarks");

    // ---------------------------- Subprojects ----------------------------- \\
    add_subproject(b, target, optimize, test_step, benchmark_step, "00", "zig_template");
    add_subproject(b, target, optimize, test_step, benchmark_step, "01", "historian_hysteria");
    add_subproject(b, target, optimize, test_step, benchmark_step, "02", "red_nosed_reports");
    add_subproject(b, target, optimize, test_step, benchmark_step, "03", "mull_it_over");
    add_subproject(b, target, optimize, test_step, benchmark_step, "04", "ceres_search");
    add_subproject(b, target, optimize, test_step, benchmark_step, "05", "print_queue");
    add_subproject(b, target, optimize, test_step, benchmark_step, "06", "guard_gallivant");
    add_subproject(b, target, optimize, test_step, benchmark_step, "09", "disk_fragmenter");
    add_subproject(b, target, optimize, test_step, benchmark_step, "10", "hoof_it");
    add_subproject(b, target, optimize, test_step, benchmark_step, "11", "plutonian_pebbles");
    add_subproject(b, target, optimize, test_step, benchmark_step, "12", "garden_groups");
    add_subproject(b, target, optimize, test_step, benchmark_step, "13", "claw_contraption");
}
