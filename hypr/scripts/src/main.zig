const std = @import("std");
const scripts = @import("scripts");
const term = @import("toggleTerm.zig");
const sth = @import("structs_helper.zig");


pub fn main(init: std.process.Init) !void {

    const ess: sth.Essentials = sth.Essentials {
        .alloc = init.gpa,
        .io = init.io,
        .env = init.environ_map,
    };
    // defer _ = ess.alloc.;

    term.handle_grouping(ess) catch |err| {
       const notify = try std.process.run(
           ess.alloc,
           ess.io,
           .{
           .argv = &.{
               "notify-send",
               "Hypr Helper",
               @errorName(err)
           }
       });
    ess.alloc.free(notify.stdout);
    ess.alloc.free(notify.stderr);
};
}


