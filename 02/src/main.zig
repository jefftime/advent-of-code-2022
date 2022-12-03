const std = @import("std");

pub fn main() !void {
    const input = @embedFile("input.txt");
    std.log.info("--- Input ---\n{}", .{input});
}
