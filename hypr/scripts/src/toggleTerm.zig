const std = @import("std");
const hypr = @import("hyprLib.zig");
const Essentials = @import("structs_helper.zig").Essentials;

const ToggleTermError = error{
    ActiveWindowPIDNotFound,
    ChildPIDNotFound,
    PathNotFound
};

fn grab_child_pid(term_pid: i64, ess: Essentials, buf: []u8) ![]const u8 {

    const pid_str: []u8 = try std.fmt.bufPrint(buf, "{d}", .{term_pid}); 
    const pid_children = try std.process.run(
        ess.alloc,
        ess.io,
        .{
        .argv = &.{"ps", "--ppid", pid_str, "-o", "pid,comm"},
        });
    defer ess.alloc.free(pid_children.stdout);
    defer ess.alloc.free(pid_children.stderr);

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
    return ToggleTermError.ChildPIDNotFound;
}


fn grab_active_window_pid(jParse: std.json.Value) !i64 {
    const pid_key = jParse.object.get("pid") orelse return ToggleTermError.ActiveWindowPIDNotFound;
    return pid_key.integer;
}

fn pwdx_process(ess: Essentials, pid: []const u8) ![]const u8 {
    const working_dir = try std.process.run(
        ess.alloc,
        ess.io,
        .{
        .argv = &.{
            "pwdx",
            pid
        }
    });
    defer ess.alloc.free(working_dir.stdout);
    defer ess.alloc.free(working_dir.stderr);

    const trimmed = std.mem.trim(u8, working_dir.stdout, " \t\n");
    var cols = std.mem.tokenizeAny(u8, trimmed, " \t");

    _ = cols.next() orelse return ToggleTermError.PathNotFound;
    const path: []const u8 = cols.next() orelse return ToggleTermError.PathNotFound;
    return try ess.alloc.dupe(u8, path);
}

fn grab_path(jParse: std.json.Value, ess: Essentials) ![]const u8 {
    const term_pid: i64 = try grab_active_window_pid(jParse);

    var buf: [15]u8 = undefined;
    const pid: []const u8 = try grab_child_pid(term_pid, ess, &buf);
    return try pwdx_process(ess, pid);
}


pub fn handle_grouping(ess: Essentials) !void {
    var jObj: std.json.Parsed(std.json.Value) = try hypr.hypr_query(ess);
    defer jObj.deinit();
    const jParse = jObj.value;

    var socket = try hypr.hypr_connect(ess);
    defer socket.close(ess.io);
    var buf_out: [128]u8 = undefined;
    var writer = socket.writer(ess.io, &buf_out);
    const sock_write = &writer.interface;

    const window_status = jParse.object;

    const grouped = window_status.get("grouped").?.array.items;

    switch (grouped.len) {
        0 => {
            const path: []const u8 = grab_path(jParse, ess) catch |err| {
                try sock_write.writeAll("/dispatch hl.dsp.group.toggle()");
                try sock_write.flush();
                return err;
            };
            defer ess.alloc.free(path);

            const cmd = try std.fmt.allocPrint(
                ess.alloc,
                "[[BATCH]]dispatch hl.dsp.group.toggle();dispatch hl.dsp.exec_cmd(\"alacritty --working-directory {s}\")",
                .{path},
            );
            defer ess.alloc.free(cmd);

            try sock_write.writeAll(cmd);
            try sock_write.flush();
        },

        1 => {
            const path: []const u8 = grab_path(jParse, ess) catch |err| {
                try sock_write.writeAll("/dispatch hl.dsp.exec_cmd(\"alacritty\")");
                try sock_write.flush();
                return err;
            };
            defer ess.alloc.free(path);
            const cmd = try std.fmt.allocPrint(
                ess.alloc,
                "/dispatch hl.dsp.exec_cmd(\"alacritty --working-directory {s}\")",
                .{path},
            );
            defer ess.alloc.free(cmd);
            try sock_write.writeAll(cmd);
            try sock_write.flush();
        },

        else => {
            try sock_write.writeAll("/dispatch hl.dsp.group.next()");
            try sock_write.flush();
        }
    } 
}


