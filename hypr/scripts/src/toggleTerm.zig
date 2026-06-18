const std = @import("std");
const hypr = @import("hyprLib.zig");

const ToggleTermError = error{
    PIDNotFound,
    PathNotFound
};

fn grab_shell_pid(term_pid: i64, alloc: std.mem.Allocator, buf: []u8) ![]const u8 {

    const pid_str: []u8 = try std.fmt.bufPrint(buf, "{d}", .{term_pid}); 
    const pid_children = try std.process.Child.run(.{
        .allocator = alloc,
        .argv = &.{
            "ps",
            "--ppid",
            pid_str,
            "-o",
            "pid,comm",
        }
    });
    defer alloc.free(pid_children.stdout);
    defer alloc.free(pid_children.stderr);

    var lines = std.mem.splitScalar(u8, pid_children.stdout, '\n');
    _ = lines.next();
    while(lines.next()) |line| {
        const trimmed = std.mem.trim(u8, line, " \t");
        var cols = std.mem.tokenizeAny(u8, trimmed, " \t");

        const pid = cols.next() orelse continue;
        const process = cols.next() orelse continue;

        if(std.mem.eql(u8, "bash", process)){
            const slice = try std.fmt.bufPrint(buf, "{s}", .{pid});
            return slice;
        }
    }
    return ToggleTermError.PIDNotFound;
}


fn grab_term_pid(jParse: std.json.Value) !i64 {
    const pid_key = jParse.object.get("pid") orelse return ToggleTermError.PIDNotFound;
    return pid_key.integer;
}

fn pwdx_process(alloc: std.mem.Allocator, pid: []const u8) ![]const u8 {
    const working_dir = try std.process.Child.run(.{
        .allocator = alloc,
        .argv = &.{
            "pwdx",
            pid
        }
    });
    defer alloc.free(working_dir.stdout);
    defer alloc.free(working_dir.stderr);

    const trimmed = std.mem.trim(u8, working_dir.stdout, " \t\n");
    var cols = std.mem.tokenizeAny(u8, trimmed, " \t");

    _ = cols.next() orelse return ToggleTermError.PathNotFound;
    const path: []const u8 = cols.next() orelse return ToggleTermError.PathNotFound;
    return try alloc.dupe(u8, path);
}

fn grab_path(jParse: std.json.Value, alloc: std.mem.Allocator) ![]const u8 {
    const term_pid: i64 = try grab_term_pid(jParse);

    var buf: [15]u8 = undefined;
    const pid: []const u8 = try grab_shell_pid(term_pid, alloc, &buf);

    return try pwdx_process(alloc, pid);
}


pub fn handle_grouping(alloc: std.mem.Allocator) !void {
    var jObj: std.json.Parsed(std.json.Value) = try hypr.hypr_query(alloc);
    defer jObj.deinit();
    const jParse = jObj.value;

    var socket: std.net.Stream = try hypr.hypr_connect(alloc);
    defer socket.close();

    const window_status = jParse.object;

    if(window_status.get("grouped")) |gs| {
        switch (gs.array.items.len) {
            0 => {
                const path: []const u8 = grab_path(jParse, alloc) catch |err| {
                    try socket.writeAll("/dispatch togglegroup");
                    return err;
            };
                defer alloc.free(path);

                const cmd = try std.fmt.allocPrint(
                    alloc,
                    "[[BATCH]]dispatch hl.dsp.group.toggle();dispatch hl.dsp.exec_cmd(\"alacritty --working-directory {s}\")",
                    .{path},
                );
                defer alloc.free(cmd);

                try socket.writeAll(cmd);
            },

            1 => {
                const path: []const u8 = grab_path(jParse, alloc) catch |err| {
                    try socket.writeAll("/dispatch exec alacritty");
                    return err;
            };
                defer alloc.free(path);
                const cmd = try std.fmt.allocPrint(
                    alloc,
                    "/dispatch hl.dsp.exec_cmd(\"alacritty --working-directory {s}\")",
                    .{path},
                );
                defer alloc.free(cmd);
                try socket.writeAll(cmd);
            },

            else => {
                try socket.writeAll("dispatch changegroupactive f");
            }
        } 
    }
}


