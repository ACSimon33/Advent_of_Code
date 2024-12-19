const std = @import("std");
const Allocator = std.mem.Allocator;
const ArrayList = std.ArrayList;
const string = []const u8;

/// Task 1 - Compress the files on the disk while actively fragmenting the
///          files. Return the checksum of the compressed disk.
///
/// Arguments:
///   - `contents`: Input file contents.
///   - `main_allocator`: Base allocator for everything.
///
/// Returns:
///   - Checksum of the compressed (fragmented) disk.
pub fn checksum_of_fragmented_disk(contents: string, main_allocator: Allocator) !usize {
    var arena = std.heap.ArenaAllocator.init(main_allocator);
    defer arena.deinit();

    const allocator = arena.allocator();
    var files, var gaps = try parse_initial_disk(contents, allocator);

    var checksum: usize = 0;

    var files_front_idx: usize = 0;
    var files_back_idx: usize = files.items.len - 1;
    var disk_idx: usize = 0;
    var eof_idx: usize = 0;
    while (files_front_idx <= files_back_idx) {
        // Insert file
        eof_idx = disk_idx + files.items[files_front_idx] - 1;
        checksum += files_front_idx * partial_gauss_sum(disk_idx, eof_idx);
        disk_idx = eof_idx + 1;

        // Fill gap
        while (gaps.items[files_front_idx] > 0 and files_front_idx < files_back_idx) {
            if (files.items[files_back_idx] <= gaps.items[files_front_idx]) {
                eof_idx = disk_idx + files.items[files_back_idx] - 1;
                checksum += files_back_idx * partial_gauss_sum(disk_idx, eof_idx);
                disk_idx = eof_idx + 1;

                gaps.items[files_front_idx] -= files.items[files_back_idx];
                files_back_idx -= 1;
            } else {
                eof_idx = disk_idx + gaps.items[files_front_idx] - 1;
                checksum += files_back_idx * partial_gauss_sum(disk_idx, eof_idx);
                disk_idx = eof_idx + 1;

                files.items[files_back_idx] -= gaps.items[files_front_idx];
                gaps.items[files_front_idx] = 0;
            }
        }

        files_front_idx += 1;
    }

    return checksum;
}

/// Task 2 - Compress the files on the disk while preventing fragmentation of
///          the files. Return the checksum of the compressed disk.
///
/// Arguments:
///   - `contents`: Input file contents.
///   - `main_allocator`: Base allocator for everything.
///
/// Returns:
///   - Checksum of the compressed (defragmented) disk.
pub fn checksum_of_defragmented_disk(contents: string, main_allocator: Allocator) !usize {
    var arena = std.heap.ArenaAllocator.init(main_allocator);
    defer arena.deinit();

    const allocator = arena.allocator();
    const files, const gaps = try parse_initial_disk(contents, allocator);

    // Calculate initial disk locations
    var file_disk_locations = ArrayList(usize).init(allocator);
    var gap_disk_locations = ArrayList(usize).init(allocator);
    var disk_idx: usize = 0;
    for (0..files.items.len) |i| {
        try file_disk_locations.append(disk_idx);
        disk_idx += files.items[i];
        if (i < gaps.items.len) {
            try gap_disk_locations.append(disk_idx);
            disk_idx += gaps.items[i];
        }
    }

    // Move files where possible
    var file_idx = files.items.len;
    while (file_idx > 0) {
        file_idx -= 1;
        for (0..gaps.items.len) |gap_idx| {
            if (gap_disk_locations.items[gap_idx] > file_disk_locations.items[file_idx]) {
                break;
            }
            if (files.items[file_idx] <= gaps.items[gap_idx]) {
                file_disk_locations.items[file_idx] = gap_disk_locations.items[gap_idx];
                gap_disk_locations.items[gap_idx] += files.items[file_idx];
                gaps.items[gap_idx] -= files.items[file_idx];
                break;
            }
        }
    }

    // Calculate checksum
    var checksum: usize = 0;
    for (0..files.items.len) |i| {
        checksum += i * partial_gauss_sum(
            file_disk_locations.items[i],
            file_disk_locations.items[i] + files.items[i] - 1,
        );
    }

    return checksum;
}

// -------------------------------------------------------------------------- \\

/// Sum all natural numbers between two given numbers.
///
/// Arguments:
///   - `first`: The first number (lower bound).
///   - `last`: The last number (upper bound).
///
/// Returns:
///   - The sum of all natural numbers within the bounds.
fn partial_gauss_sum(first: usize, last: usize) usize {
    return gauss_sum(last) - gauss_sum(first) + first;
}

/// Sum all natural numbers up to the given number.
///
/// Arguments:
///   - `num`: The give number.
///
/// Returns:
///   - The Gauss sum of the given number.
fn gauss_sum(num: usize) usize {
    return num * (num + 1) / 2;
}

/// Parse the file contents into a list of file sizes and a list of gap sizes.
///
/// Arguments:
///   - `contents`: Input file contents.
///   - `allocator`: Allocator for the containers.
///
/// Returns:
///   - Two lists with files sizes and gap sizes.
fn parse_initial_disk(contents: string, allocator: Allocator) !struct { ArrayList(u32), ArrayList(u32) } {
    var files = ArrayList(u32).init(allocator);
    var gaps = ArrayList(u32).init(allocator);

    for (0..contents.len) |i| {
        if (i % 2 == 0) {
            try files.append(try std.fmt.parseInt(u32, contents[i..(i + 1)], 10));
        } else {
            try gaps.append(try std.fmt.parseInt(u32, contents[i..(i + 1)], 10));
        }
    }

    return .{ files, gaps };
}
