const std = @import("std");

fn get_priority(ch: u8) !u8 {
    if (ch >= 'a' and ch <= 'z') {
        return ch - 'a' + 1;
    } else if (ch >= 'A' and ch <= 'Z') {
        return ch - 'A' + 27;
    }

    return error.InvalidCharacter;
}

pub fn main() !void {
    const input = @embedFile("input.txt");

    var rucksack_iter = std.mem.split(u8, input, "\n");
    var total_priority: usize = 0;
    while (rucksack_iter.next()) |rucksack| {
        if (rucksack.len == 0) continue;

        const pouch1 = rucksack[0 .. rucksack.len / 2];
        const pouch2 = rucksack[rucksack.len / 2 ..];
        std.debug.print("Priority for {s} {s}: ", .{ pouch1, pouch2 });
        outer: for (pouch1) |ch| {
            for (pouch2) |ch2| {
                if (ch == ch2) {
                    total_priority += try get_priority(ch);
                    std.debug.print(
                        "{s} ({})\n",
                        .{ [_]u8{ch}, try get_priority(ch) },
                    );

                    break :outer;
                }
            }
        }
        // std.debug.print("\n", .{});
    }

    std.log.info("Total priority: {}", .{total_priority});

    ////////////////////////////////////////
    // Part 2
    ////////////////////////////////////////

    while (false) {}
}
