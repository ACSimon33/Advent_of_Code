const std = @import("std");
const Allocator = std.mem.Allocator;
const ArrayList = std.ArrayList;
const string = []const u8;

/// Task 1 - Simulate the robots for the given amount of secconds and calculate
///          the security factor (product of the amounts of robots in each
///          quadrant).
///
/// Arguments:
///   - `contents`: Input file contents.
///   - `seconds`: The amount of seconds to simulate.
///   - `width`: Size of the x dimension.
///   - `height`: Size of the y dimension.
///
/// Returns:
///   - The security factor.
pub fn security_factor(contents: string, seconds: i32, width: i32, height: i32) !i32 {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const allocator = arena.allocator();
    const robots = try parse_robots(contents, allocator);

    for (0..robots.items.len) |i| {
        simulate_robot(&robots.items[i], seconds, width, height);
    }

    const x_mid = @divTrunc(width, 2);
    const y_mid = @divTrunc(height, 2);

    var robot_count = @Vector(4, i32){ 0, 0, 0, 0 };
    for (robots.items) |robot| {
        if (robot.x == x_mid or robot.y == y_mid) {
            continue;
        }

        var quadrant: usize = 0;
        if (robot.x > x_mid) {
            quadrant += 1;
        }
        if (robot.y > y_mid) {
            quadrant += 2;
        }
        robot_count[quadrant] += 1;
    }

    return @reduce(.Mul, robot_count);
}

/// Task 2 - Calculate the amount of seconds after which the 'easter egg' (a
///          picture of a christmas tree) appears in the formation of the
///          robots.
///
/// Since the christmas tree will most likely group many robots together, one
/// can assume that the variance of the x and y coordinates across all robots
/// will be minimized when the christmas tree appears. Additionally, the x and y
/// coordinates will repeat after exactly `width` and `height` seconds (because
/// they are prime).
/// That means we can calculate the time steps that minimize the x and y
/// variance, let's call them tx and ty. To find the time step in the future
/// that minimizes both the x and y variance at the same time we can use the
/// Chinese Remainder Theorem to solve the following system of equations:
///
///     T = tx (mod width)
///     T = ty (mod height)
///
/// T will be the amount of seconds until the christmas tree appears.
///
/// Arguments:
///   - `contents`: Input file contents.
///   - `width`: Size of the x dimension.
///   - `height`: Size of the y dimension.
///
/// Returns:
///   - The amount of seconds until the tree appears.
pub fn time_until_christmas_tree(contents: string, width: i32, height: i32, print: bool) !i32 {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const allocator = arena.allocator();
    const robots = try parse_robots(contents, allocator);

    // Calculate smallest variances for x and y coordinates
    var smallest_x_variance: f64 = std.math.inf(f64);
    var smallest_x_variance_time: i32 = undefined;
    var smallest_y_variance: f64 = std.math.inf(f64);
    var smallest_y_variance_time: i32 = undefined;
    for (0..@intCast(@max(width, height))) |seconds| {
        const x_var, const y_var = calc_variance(robots);
        if (seconds < width) {
            if (x_var < smallest_x_variance) {
                smallest_x_variance = x_var;
                smallest_x_variance_time = @intCast(seconds);
            }
        }
        if (seconds < height) {
            if (y_var < smallest_y_variance) {
                smallest_y_variance = y_var;
                smallest_y_variance_time = @intCast(seconds);
            }
        }

        for (0..robots.items.len) |i| {
            simulate_robot(&robots.items[i], 1, width, height);
        }
    }

    // Chinese remainder theorem (naive search for a solution)
    var T = smallest_x_variance_time;
    while (T < width * height) : (T += width) {
        if (@rem(T, height) == smallest_y_variance_time) {
            break;
        }
    } else {
        return error.NoSolutionFound;
    }

    if (print) {
        for (0..robots.items.len) |i| {
            simulate_robot(&robots.items[i], T - @max(width, height), width, height);
        }
        print_robots(robots, width, height);
    }

    return T;
}

// -------------------------------------------------------------------------- \\

// Robot with a current position and velocity.
const Robot = struct { x: i32, y: i32, v_x: i32, v_y: i32 };

/// Simulate where the robots will be after the given amount of seconds.
///
/// Arguments:
///   - `robot`: The robot.
///   - `seconds`: The amount of seconds to simulate.
///   - `width`: Size of the x dimension.
///   - `height`: Size of the y dimension.
fn simulate_robot(robot: *Robot, seconds: i32, width: i32, height: i32) void {
    robot.x += robot.v_x * seconds;
    while (robot.x < 0) {
        robot.x += width;
    }
    robot.x = @rem(robot.x, width);
    robot.y += robot.v_y * seconds;
    while (robot.y < 0) {
        robot.y += height;
    }
    robot.y = @rem(robot.y, height);
}

/// Calculate the variance of the x and y coordinates across all robots.
///
/// Arguments:
///   - `robots`: The robots.
///
/// Returns:
///   - The variances of x and y coordinates.
fn calc_variance(robots: ArrayList(Robot)) struct { f64, f64 } {
    var x_mean: f64 = 0;
    var y_mean: f64 = 0;
    for (robots.items) |robot| {
        x_mean += @floatFromInt(robot.x);
        y_mean += @floatFromInt(robot.y);
    }
    x_mean /= @floatFromInt(robots.items.len);
    y_mean /= @floatFromInt(robots.items.len);

    var x_var: f64 = 0;
    var y_var: f64 = 0;
    for (robots.items) |robot| {
        x_var += std.math.pow(f64, @as(f64, @floatFromInt(robot.x)) - x_mean, 2);
        y_var += std.math.pow(f64, @as(f64, @floatFromInt(robot.y)) - y_mean, 2);
    }
    x_var /= @floatFromInt(robots.items.len - 1);
    y_var /= @floatFromInt(robots.items.len - 1);

    return .{ x_var, y_var };
}

/// Print the grid with all the robots.
///
/// Arguments:
///   - `robots`: The robots.
///   - `width`: Size of the x dimension.
///   - `height`: Size of the y dimension.
fn print_robots(robots: ArrayList(Robot), width: i32, height: i32) void {
    for (0..@intCast(height)) |y| {
        for (0..@intCast(width)) |x| {
            var found = false;
            for (robots.items) |robot| {
                if (x == robot.x and y == robot.y) {
                    found = true;
                    break;
                }
            }
            if (found) {
                std.debug.print("#", .{});
            } else {
                std.debug.print(".", .{});
            }
        }
        std.debug.print("\n", .{});
    }
}

/// Parse the file contents into a list of robots.
///
/// Arguments:
///   - `allocator`: Allocator for the containers.
///
/// Returns:
///   - Array list of robot objects.
fn parse_robots(contents: string, allocator: Allocator) !ArrayList(Robot) {
    var robots = ArrayList(Robot).init(allocator);

    var lines = std.mem.tokenize(u8, contents, "\r\n");
    while (lines.next()) |line| {
        var robot = Robot{
            .x = undefined,
            .y = undefined,
            .v_x = undefined,
            .v_y = undefined,
        };
        var robot_params = std.mem.split(u8, line, " ");
        if (robot_params.next()) |position| {
            var position_components = std.mem.split(u8, position[2..], ",");
            robot.x = try std.fmt.parseInt(i32, position_components.next().?, 10);
            robot.y = try std.fmt.parseInt(i32, position_components.next().?, 10);
        }
        if (robot_params.next()) |velocity| {
            var velocity_components = std.mem.split(u8, velocity[2..], ",");
            robot.v_x = try std.fmt.parseInt(i32, velocity_components.next().?, 10);
            robot.v_y = try std.fmt.parseInt(i32, velocity_components.next().?, 10);
        }
        try robots.append(robot);
    }

    return robots;
}
