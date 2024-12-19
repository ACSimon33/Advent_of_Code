const std = @import("std");
const Allocator = std.mem.Allocator;
const ArrayList = std.ArrayList;
const string = []const u8;

/// Task 1 - Calculate the cost of all fences.
///
/// Arguments:
///   - `contents`: Input file contents.
///   - `main_allocator`: Base allocator for everything.
///
/// Returns:
///   - The fence cost.
pub fn fence_cost(contents: string, main_allocator: Allocator) !u32 {
    var arena = std.heap.ArenaAllocator.init(main_allocator);
    defer arena.deinit();

    const allocator = arena.allocator();
    var garden = try parse_garden(contents, allocator);
    garden.plan_fences();

    var cost: u32 = 0;
    for (0..garden.x_size * garden.y_size) |i| {
        const area, const perimeter = garden.install_fences(i);
        cost += area * perimeter;
    }

    return cost;
}

/// Task 2 - Calculate the cost of all fences with bulk discount.
///
/// Arguments:
///   - `contents`: Input file contents.
///   - `main_allocator`: Base allocator for everything.
///
/// Returns:
///   - The fence cost.
pub fn fence_cost_with_bulk_discount(contents: string, main_allocator: Allocator) !u32 {
    var arena = std.heap.ArenaAllocator.init(main_allocator);
    defer arena.deinit();

    const allocator = arena.allocator();
    var garden = try parse_garden(contents, allocator);
    garden.plan_fences();
    garden.plan_fence_posts();

    var cost: u32 = 0;
    for (0..garden.x_size * garden.y_size) |i| {
        const area, const sides = garden.install_fence_posts(i);
        cost += area * sides;
    }

    return cost;
}

// -------------------------------------------------------------------------- \\

/// Cardinal direction.
const Direction = enum(u2) { north, east, south, west };

/// A single garden plot.
const GardenPlot = struct {
    crop_id: u8,
    fences: [4]bool,
    fence_posts: [4]bool,
    claimed: bool,

    /// Calculate the amount fences in this plot.
    ///
    /// Arguments:
    ///   - `self`: The GardenPlot object.
    ///
    /// Returns:
    ///   - The amount of fences in this plot.
    fn count_fences(self: GardenPlot) u32 {
        var fence_count: u32 = 0;
        for (self.fences) |fence| {
            fence_count += @intFromBool(fence);
        }
        return fence_count;
    }

    /// Calculate the amount fence posts in this plot.
    ///
    /// Arguments:
    ///   - `self`: The GardenPlot object.
    ///
    /// Returns:
    ///   - The amount of fence posts in this plot.
    fn count_fence_posts(self: GardenPlot) u32 {
        var post_count: u32 = 0;
        for (self.fence_posts) |post| {
            post_count += @intFromBool(post);
        }
        return post_count;
    }
};

/// 2D Garden with all garden plots that grow different plots.
const Garden = struct {
    plots: ArrayList(GardenPlot),
    x_size: usize,
    y_size: usize,

    /// Initialize garden.
    ///
    /// Arguments:
    ///   - `x_size`: The size of the map in x direction.
    ///   - `y_size`: The size of the map in y direction.
    ///   - `allocator`: An allocator for the heights and values.
    ///
    /// Returns:
    ///   - The garden.
    fn init(x_size: usize, y_size: usize, allocator: Allocator) !Garden {
        var plots = ArrayList(GardenPlot).init(allocator);
        try plots.resize(x_size * y_size);

        return Garden{
            .plots = plots,
            .x_size = x_size,
            .y_size = y_size,
        };
    }

    /// Plan where we need fences (between two plots with different crops).
    ///
    /// Arguments:
    ///   - `self`: The garden object.
    fn plan_fences(self: Garden) void {
        for (0..self.x_size * self.y_size) |pos| {
            for (0..4) |d| {
                const dir: Direction = @enumFromInt(d);
                const neighbour = self.adjacent_plot(pos, dir) catch {
                    self.plots.items[pos].fences[d] = true;
                    continue;
                };
                if (self.plots.items[pos].crop_id != self.plots.items[neighbour].crop_id) {
                    self.plots.items[pos].fences[d] = true;
                }
            }
        }
    }

    /// Plan where we need fence post. Exterior fence post can be detected by
    /// looking at the fences. If a corner has adjacent fences, it needs a post.
    /// This exterior post can be projected diagonally to the other side where
    /// it can become an interior side post in the adjacent region.
    ///
    /// Arguments:
    ///   - `self`: The garden object.
    fn plan_fence_posts(self: Garden) void {
        for (0..self.x_size * self.y_size) |pos| {
            for (0..4) |dir_int| {
                const d: u2 = @intCast(dir_int);

                // Exterior posts
                const fence1 = self.plots.items[pos].fences[d];
                const fence2 = self.plots.items[pos].fences[d -% 1];
                if (fence1 and fence2) {
                    self.plots.items[pos].fence_posts[d] = true;
                }

                // Interior posts in adjacent region
                if (self.plots.items[pos].fence_posts[d]) {
                    const dir1: Direction = @enumFromInt(d);
                    const dir2: Direction = @enumFromInt(d -% 1);
                    const neighbour1 = self.adjacent_plot(pos, dir1) catch {
                        continue;
                    };
                    const neighbour2 = self.adjacent_plot(pos, dir2) catch {
                        continue;
                    };
                    const diag_neighbour = self.adjacent_plot(neighbour1, dir2) catch {
                        continue;
                    };
                    if (self.plots.items[neighbour1].crop_id == self.plots.items[diag_neighbour].crop_id and
                        self.plots.items[neighbour2].crop_id == self.plots.items[diag_neighbour].crop_id)
                    {
                        self.plots.items[diag_neighbour].fence_posts[d +% 2] = true;
                    }
                }
            }
        }
    }

    /// Calculate the area and perimeter of the region that the plot at the
    /// given position is part of. The perimeter is just the amount of all
    /// fences in the region.
    ///
    /// Arguments:
    ///   - `self`: The garden object.
    ///   - `pos`: The position of the current garden plot.
    ///
    /// Returns:
    ///   - The area and perimeter of the region the current plot is a part of.
    fn install_fences(self: Garden, pos: usize) struct { u32, u32 } {
        if (self.plots.items[pos].claimed) {
            return .{ 0, 0 };
        }

        self.plots.items[pos].claimed = true;
        var area: u32 = 1;
        var perimeter: u32 = self.plots.items[pos].count_fences();

        for (0..4) |d| {
            const dir: Direction = @enumFromInt(d);
            const neighbour = self.adjacent_plot(pos, dir) catch {
                continue;
            };

            // Recursively find plots that are part of the current region and
            // increase the area and perimeter
            if (self.plots.items[pos].crop_id == self.plots.items[neighbour].crop_id) {
                const n_area, const n_perimeter = self.install_fences(neighbour);
                area += n_area;
                perimeter += n_perimeter;
            }
        }

        return .{ area, perimeter };
    }

    /// Calculate the area and amount of sides of the region that the plot at
    /// the given position is part of. The amount of sides is equal to the
    /// amount of all fence posts in the region.
    ///
    /// Arguments:
    ///   - `self`: The garden object.
    ///   - `pos`: The position of the current garden plot.
    ///
    /// Returns:
    ///   - The area and sides of the region the current plot is a part of.
    fn install_fence_posts(self: Garden, pos: usize) struct { u32, u32 } {
        if (self.plots.items[pos].claimed) {
            return .{ 0, 0 };
        }

        self.plots.items[pos].claimed = true;
        var area: u32 = 1;
        var sides: u32 = self.plots.items[pos].count_fence_posts();

        for (0..4) |d| {
            const dir: Direction = @enumFromInt(d);
            const neighbour = self.adjacent_plot(pos, dir) catch {
                continue;
            };

            // Recursively find plots that are part of the current region and
            // increase the area and amount of sides
            if (self.plots.items[pos].crop_id == self.plots.items[neighbour].crop_id) {
                const n_area, const n_sides = self.install_fence_posts(neighbour);
                area += n_area;
                sides += n_sides;
            }
        }

        return .{ area, sides };
    }

    /// Return the adjacent garden plot in the given direction.
    ///
    /// Arguments:
    ///   - `self`: The garden object.
    ///   - `pos`: The position of the current garden plot.
    ///   - `dir`: The moving direction.
    ///
    /// Returns:
    ///   - The position of the neighbouring garden plot.
    ///   - `error.OutOfBounds` if the move would leave the garden.
    fn adjacent_plot(self: Garden, pos: usize, dir: Direction) !usize {
        const x = pos % self.x_size;
        const y = pos / self.x_size;
        return switch (dir) {
            Direction.north => blk: {
                if (y == 0) {
                    return error.OutOfBounds;
                }
                break :blk (pos - self.x_size);
            },
            Direction.east => blk: {
                if (x >= self.x_size - 1) {
                    return error.OutOfBounds;
                }
                break :blk (pos + 1);
            },
            Direction.south => blk: {
                if (y >= self.y_size - 1) {
                    return error.OutOfBounds;
                }
                break :blk (pos + self.x_size);
            },
            Direction.west => blk: {
                if (x == 0) {
                    return error.OutOfBounds;
                }
                break :blk (pos - 1);
            },
        };
    }
};

/// Parse the file contents into a `Garden`.
///
/// Arguments:
///   - `contents`: Input file contents.
///   - `allocator`: Allocator for the containers.
///
/// Returns:
///   - The garden.
fn parse_garden(contents: string, allocator: Allocator) !Garden {
    var lines = std.mem.tokenize(u8, contents, "\r\n");
    const y_size: usize = @intCast(std.mem.count(u8, contents, &[1]u8{'\n'}) + 1);
    const x_size: usize = lines.peek().?.len;
    const garden = try Garden.init(x_size, y_size, allocator);

    var plot_idx: usize = 0;
    while (lines.next()) |plots| {
        for (plots) |crop_id| {
            garden.plots.items[plot_idx] = GardenPlot{
                .crop_id = crop_id,
                .fences = [4]bool{ false, false, false, false },
                .fence_posts = [4]bool{ false, false, false, false },
                .claimed = false,
            };
            plot_idx += 1;
        }
    }

    return garden;
}
