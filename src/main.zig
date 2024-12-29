const std = @import("std");
const c = @cImport({
    @cInclude("gtk/gtk.h");
    @cInclude("libadwaita-1/adwaita.h");
});

pub fn main() !void {
    const app = c.adw_application_new("org.gtk.example", c.G_APPLICATION_FLAGS_NONE);

    _ = c.g_signal_connect_data(app, "activate", c.G_CALLBACK(&activate_cb), null, null, 0);
    _ = c.g_application_run(@ptrCast(app), 0, null);
}

fn activate_cb(app: *c.GtkApplication, _: c.gpointer) callconv(.C) void {
    const window = c.gtk_application_window_new(app);
    const image = c.gtk_image_new_from_file("assets/ziglings.jpg");

    c.gtk_window_set_title(@ptrCast(window), "Zig Adwaita Test");
    c.gtk_window_set_default_size(@ptrCast(window), 400, 400);

    c.gtk_window_set_child(@ptrCast(window), @ptrCast(image));

    c.gtk_widget_show(@ptrCast(window));
}
