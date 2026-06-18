const std = @import("std");
const scripts = @import("scripts");
const term = @import("toggleTerm.zig");

pub fn main() !void {
    var gpa = std.heap.DebugAllocator(.{}){};
    defer _ = gpa.deinit();
    const alloc = gpa.allocator();

    term.handle_grouping(alloc) catch |err| {
       const notify = try std.process.Child.run(.{
           .allocator = alloc,
           .argv = &.{
               "notify-send",
               "Hypr Helper",
               @errorName(err)
           }
       });
    alloc.free(notify.stdout);
    alloc.free(notify.stderr);
};
}


