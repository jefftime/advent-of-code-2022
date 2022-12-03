const std = @import("std");

pub fn main() !void {
    const input = @embedFile("input.txt");

    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    var elves = std.ArrayList(usize).init(arena.allocator());
    defer elves.deinit();

    var elf_iter = std.mem.split(u8, input, "\n\n");
    var i: usize = 0;
    while (elf_iter.next()) |elf_calories| {
        var food_iter = std.mem.split(u8, elf_calories, "\n");
        var total_calories: usize = 0;
        while (food_iter.next()) |food| {
            const calories = std.fmt.parseInt(usize, food, 10) catch {
                std.log.warn("Elf #{}: ignoring {s}", .{ i, food });
                continue;
            };

            total_calories += calories;
        }

        try elves.append(total_calories);
        i += 1;
    }

    var n_elf: usize = 0;
    var max_calories: usize = 0;
    for (elves.items) |elf_calories, j| {
        if (max_calories < elf_calories) {
            n_elf = j;
            max_calories = elf_calories;
        }
    }
    std.log.info("Part 1: Elf #{} has {} calories", .{ n_elf, max_calories });

    ////////////////////////////////////////
    // Part 2
    ////////////////////////////////////////

    std.sort.sort(usize, elves.items, {}, std.sort.desc(usize));
    var top_three_calories: usize = 0;
    for (elves.items[0..3]) |elf_calories, j| {
        std.log.info("#{}: {} calories", .{ j + 1, elf_calories });
        top_three_calories += elf_calories;
    }
    std.log.info("Total calories of top three: {}", .{top_three_calories});
}
