const std = @import("std");
const init = std.process.Init;
const io = std.Io;
const Essentials = @import("structs_helper.zig");

const HyprError = error{
    HyprlandSocketNotFound,
};

pub fn hypr_connect(ess: Essentials.Essentials) !io.net.Stream {
    // const hypr = env.get("HYPRLAND_INSTANCE_SIGNATURE") catch |err| {
    //     std.debug.print("Issue getting hyprland instance signature", .{});
    //     return err;
    // };
    const hypr = ess.env.get("HYPRLAND_INSTANCE_SIGNATURE") orelse return HyprError.HyprlandSocketNotFound;
    // defer ess.alloc.free(hypr);

    const hypr_sock = try std.fmt.allocPrint(
        ess.alloc,
        "/run/user/1000/hypr/{s}/.socket.sock",
        .{hypr},
    );
    defer ess.alloc.free(hypr_sock);
    const ua = try io.net.UnixAddress.init(hypr_sock);
    const socket = try io.net.UnixAddress.connect(&ua, ess.io);

    return socket;
}

pub fn hypr_query(ess: Essentials.Essentials) !std.json.Parsed(std.json.Value){

    var socket: io.net.Stream = try hypr_connect(ess);
    defer socket.close(ess.io);

    var buf_out: [32]u8 = undefined;
    var writer = socket.writer(ess.io, &buf_out);
    const sock_write = &writer.interface;
    try sock_write.writeAll("j/activewindow");
    try sock_write.flush();

    // var buf: [4096]u8 = undefined;
    var reader = socket.reader(ess.io, &.{});
    var sock_read = &reader.interface;
    const slice = try sock_read.allocRemaining(ess.alloc, .unlimited);
    defer ess.alloc.free(slice);

    std.debug.print("slice {s}\n", .{slice});

    const j_parse = try std.json.parseFromSlice(
        std.json.Value,
        ess.alloc,
        slice,
        .{},
    );

    return j_parse;
}
