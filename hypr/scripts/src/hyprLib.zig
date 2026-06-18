const std = @import("std");

pub fn hypr_connect(alloc: std.mem.Allocator) !std.net.Stream {
    const hypr = std.process.getEnvVarOwned(alloc, "HYPRLAND_INSTANCE_SIGNATURE") catch |err| {
        std.debug.print("Issue getting hyprland instance signature", .{});
        return err;
    };
    defer alloc.free(hypr);

    const hypr_sock = try std.fmt.allocPrint(
        alloc,
        "/run/user/1000/hypr/{s}/.socket.sock",
        .{hypr},
    );
    defer alloc.free(hypr_sock);
    const socket = try std.net.connectUnixSocket(hypr_sock);

    return socket;
}

pub fn hypr_query(alloc: std.mem.Allocator) !std.json.Parsed(std.json.Value){

    var socket: std.net.Stream = try hypr_connect(alloc);
    defer socket.close();

    try socket.writeAll("j/activewindow");

    var buf: [16384]u8 = undefined;
    const len = try socket.read(&buf);
    const slice = buf[0..len];

    std.debug.print("slice {s}\n", .{slice});

    const j_parse = try std.json.parseFromSlice(
        std.json.Value,
        alloc,
        slice,
        .{},
    );

    return j_parse;
}
