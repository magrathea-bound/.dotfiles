const std = @import("std");

pub const Essentials = struct {
    alloc: std.mem.Allocator,
    io: std.Io,
    env: *std.process.Environ.Map,
};
