const std = @import("std");

const Play = enum {
    Rock,
    Paper,
    Scissors,

    fn points(self: *const Play) u8 {
        switch (self.*) {
            .Rock => return 1,
            .Paper => return 2,
            .Scissors => return 3,
        }
    }

    fn from_play(ch: u8) !Play {
        switch (ch) {
            'A' => return .Rock,
            'B' => return .Paper,
            'C' => return .Scissors,
            else => return error.InvalidPlay,
        }
    }

    fn from_response(ch: u8) !Play {
        switch (ch) {
            'X' => return .Rock,
            'Y' => return .Paper,
            'Z' => return .Scissors,
            else => return error.InvalidPlay,
        }
    }
};

const Outcome = enum(u8) {
    Loss = 0,
    Draw = 3,
    Win = 6,

    fn from(play: Play, response: Play) Outcome {
        switch (play) {
            .Rock => switch (response) {
                .Rock => return .Draw,
                .Paper => return .Win,
                .Scissors => return .Loss,
            },
            .Paper => switch (response) {
                .Rock => return .Loss,
                .Paper => return .Draw,
                .Scissors => return .Win,
            },
            .Scissors => switch (response) {
                .Rock => return .Win,
                .Paper => return .Loss,
                .Scissors => return .Draw,
            },
        }
    }

    fn from_response(ch: u8) !Outcome {
        switch (ch) {
            'X' => return .Loss,
            'Y' => return .Draw,
            'Z' => return .Win,
            else => return error.InvalidOutcome,
        }
    }

    fn points(self: *const Outcome) u8 {
        return @enumToInt(self.*);
    }
};

pub fn main() !void {
    const input = @embedFile("input.txt");
    var play_iter = std.mem.split(u8, input, "\n");
    var total_points: usize = 0;
    while (play_iter.next()) |play_response| {
        if (play_response.len < 3) continue;

        const play = try Play.from_play(play_response[0]);
        const response = try Play.from_response(play_response[2]);
        const outcome = Outcome.from(play, response);
        const points: usize = outcome.points() + response.points();
        total_points += points;

        std.log.info("({s}): {} for {} points", .{
            play_response,
            outcome,
            points,
        });
    }
    std.debug.print("\n\n", .{});
    std.log.info("Total points from strategy guide: {}", .{total_points});

    ////////////////////////////////////////
    // Part 2
    ////////////////////////////////////////

    play_iter = std.mem.split(u8, input, "\n");
    total_points = 0;
    while (play_iter.next()) |play_response| {
        if (play_response.len < 3) continue;

        const play = try Play.from_play(play_response[0]);
        const outcome = try Outcome.from_response(play_response[2]);

        var shape: Play = undefined;
        switch (outcome) {
            .Win => switch (play) {
                .Rock => shape = .Paper,
                .Paper => shape = .Scissors,
                .Scissors => shape = .Rock,
            },
            .Draw => switch (play) {
                .Rock => shape = .Rock,
                .Paper => shape = .Paper,
                .Scissors => shape = .Scissors,
            },
            .Loss => switch (play) {
                .Rock => shape = .Scissors,
                .Paper => shape = .Rock,
                .Scissors => shape = .Paper,
            },
        }
        total_points += outcome.points() + shape.points();
    }
    std.log.info("Part 2 total points: {}", .{total_points});
}
