const std = @import("std");
const Allocator = std.mem.Allocator;
const ArrayList = std.ArrayList;
const string = []const u8;

/// Task 1 - Count the amount of XMAS strings in the word game.
///
/// Arguments:
///   - `contents`: Input file contents.
///   - `main_allocator`: Base allocator for everything.
///
/// Returns:
///   - Amount of XMAS strings.
pub fn xmas_count(contents: string, main_allocator: Allocator) !u32 {
    var arena = std.heap.ArenaAllocator.init(main_allocator);
    defer arena.deinit();

    const allocator = arena.allocator();
    const word_search = try parse(contents, allocator);

    var xmas: u32 = 0;
    for (0..@intCast(word_search.x_size * word_search.y_size)) |idx| {
        xmas += word_search.count_XMAS(@intCast(idx));
    }

    return xmas;
}

/// Task 2 - Count the amount of X-MAS patterns in the word game.
///
/// Arguments:
///   - `contents`: Input file contents.
///   - `main_allocator`: Base allocator for everything.
///
/// Returns:
///   - Amount of X-MAS patterns.
pub fn x_mas_count(contents: string, main_allocator: Allocator) !u32 {
    var arena = std.heap.ArenaAllocator.init(main_allocator);
    defer arena.deinit();

    const allocator = arena.allocator();
    const word_search = try parse(contents, allocator);

    var x_mas: u32 = 0;
    for (0..@intCast(word_search.x_size * word_search.y_size)) |idx| {
        x_mas += word_search.count_X_MAS(@intCast(idx));
    }

    return x_mas;
}

// -------------------------------------------------------------------------- \\

const WordSearch = struct {
    chars: []u8,
    x_size: isize,
    y_size: isize,
    xmas_offsets: [8][3]isize,
    x_mas_offsets: [4][4]isize,

    /// Initialize word search.
    ///
    /// Arguments:
    ///   - `x_size`: The size of the word rectangle in x direction.
    ///   - `y_size`: The size of the word rectangle in y direction.
    ///   - `allocator`: An allocator for the characters.
    ///
    /// Returns:
    ///   - The word search game.
    fn init(x_size: isize, y_size: isize, allocator: Allocator) !WordSearch {
        return WordSearch{
            .chars = try allocator.alloc(u8, @intCast(x_size * y_size)),
            .x_size = x_size,
            .y_size = y_size,
            .xmas_offsets = [8][3]isize{
                [_]isize{ -1, -2, -3 },
                [_]isize{ -(x_size + 1), -2 * (x_size + 1), -3 * (x_size + 1) },
                [_]isize{ -x_size, -2 * x_size, -3 * x_size },
                [_]isize{ -(x_size - 1), -2 * (x_size - 1), -3 * (x_size - 1) },
                [_]isize{ 1, 2, 3 },
                [_]isize{ x_size + 1, 2 * (x_size + 1), 3 * (x_size + 1) },
                [_]isize{ x_size, 2 * x_size, 3 * x_size },
                [_]isize{ x_size - 1, 2 * (x_size - 1), 3 * (x_size - 1) },
            },
            .x_mas_offsets = [4][4]isize{
                [_]isize{ -(x_size + 1), -(x_size - 1), x_size + 1, x_size - 1 },
                [_]isize{ x_size - 1, -(x_size + 1), -(x_size - 1), x_size + 1 },
                [_]isize{ x_size + 1, x_size - 1, -(x_size + 1), -(x_size - 1) },
                [_]isize{ -(x_size - 1), x_size + 1, x_size - 1, -(x_size + 1) },
            },
        };
    }

    /// Count the amount of XMAS strings that start at the given index.
    /// Will be between 0 and 8.
    ///
    /// Arguments:
    ///   - `self`: The word game object.
    ///   - `idx`: The idx of the character where the XMAS should start.
    ///
    /// Returns:
    ///   - The amount of XMAS strings (0-8).
    fn count_XMAS(self: WordSearch, idx: isize) u32 {
        if (self.chars[@intCast(idx)] != 'X') {
            return 0;
        }

        const x = @rem(idx, self.x_size);
        const y = @divTrunc(idx, self.x_size);

        const left = (x >= 3);
        const right = (x + 3 < self.x_size);
        const top = (y >= 3);
        const bottom = (y + 3 < self.y_size);
        const directions = [8]bool{
            left,
            left and top,
            top,
            right and top,
            right,
            right and bottom,
            bottom,
            left and bottom,
        };

        var xmas: u32 = 0;
        for (directions, self.xmas_offsets) |valid_direction, offsets| {
            if (valid_direction) {
                xmas += @intFromBool(true and
                    self.chars[@intCast(idx + offsets[0])] == 'M' and
                    self.chars[@intCast(idx + offsets[1])] == 'A' and
                    self.chars[@intCast(idx + offsets[2])] == 'S');
            }
        }

        return xmas;
    }

    /// Count the amount of X-MAS patterns that start at the given index.
    /// Will be either 0 or 1.
    ///
    /// Arguments:
    ///   - `self`: The word game object.
    ///   - `idx`: The idx of the character where the X-MAS should start.
    ///
    /// Returns:
    ///   - The amount of X-MAS patterns (0-1).
    fn count_X_MAS(self: WordSearch, idx: isize) u32 {
        if (self.chars[@intCast(idx)] != 'A') {
            return 0;
        }

        const x = @rem(idx, self.x_size);
        const y = @divTrunc(idx, self.x_size);

        const left = (x >= 1);
        const right = (x + 1 < self.x_size);
        const top = (y >= 1);
        const bottom = (y + 1 < self.y_size);

        var x_mas: bool = false;
        if (left and right and top and bottom) {
            for (self.x_mas_offsets) |offsets| {
                x_mas = x_mas or self.chars[@intCast(idx + offsets[0])] == 'M' and
                    self.chars[@intCast(idx + offsets[1])] == 'M' and
                    self.chars[@intCast(idx + offsets[2])] == 'S' and
                    self.chars[@intCast(idx + offsets[3])] == 'S';
            }
        }

        return @intFromBool(x_mas);
    }
};

/// Parse the file contents into word search game.
///
/// Arguments:
///   - `contents`: Input file contents.
///   - `main_allocator`: Base allocator for everything.
///   - `allocator`: Allocator for the containers.
///
/// Returns:
///   - The word search object.
fn parse(contents: string, allocator: Allocator) !WordSearch {
    var lines = std.mem.tokenize(u8, contents, "\r\n");
    const y_size: isize = @intCast(std.mem.count(u8, contents, &[1]u8{'\n'}) + 1);
    const x_size: isize = @intCast(lines.peek().?.len);
    var word_search = try WordSearch.init(x_size, y_size, allocator);

    var idx: usize = 0;
    while (lines.next()) |line| {
        for (line) |char| {
            word_search.chars[idx] = char;
            idx += 1;
        }
    }

    return word_search;
}
