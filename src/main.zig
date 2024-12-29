const std = @import("std");
const c = @cImport({
    @cInclude("gtk/gtk.h");
    @cInclude("libadwaita-1/adwaita.h");
});

var window: *c.GtkWidget = undefined;

pub fn main() !void {
    const app: *c.AdwApplication = c.adw_application_new("org.gtk.example", c.G_APPLICATION_FLAGS_NONE);
    _ = c.g_signal_connect_data(app, "activate", c.G_CALLBACK(&activate), null, null, 0);
    _ = c.g_application_run(@ptrCast(app), 0, null);
}

fn activate(app: *c.GtkApplication, _: c.gpointer) callconv(.C) void {
    window = c.gtk_application_window_new(app);
    c.gtk_window_set_title(@ptrCast(window), "Zig Adwaita Test");
    c.gtk_window_set_default_size(@ptrCast(window), 500, 500);

    const box: *c.GtkWidget = c.gtk_box_new(c.GTK_ORIENTATION_VERTICAL, 30);
    c.gtk_widget_set_halign(box, c.GTK_ALIGN_CENTER);
    c.gtk_widget_set_valign(box, c.GTK_ALIGN_CENTER);

    const ziglings_image: *c.GtkWidget = c.gtk_image_new_from_file("assets/ziglings.jpg");
    c.gtk_widget_set_size_request(@ptrCast(ziglings_image), 400, 300);

    const popup_button: *c.GtkWidget = c.gtk_button_new_with_label("Show Popup");
    const button_style_context = c.gtk_widget_get_style_context(popup_button);
    c.gtk_style_context_add_class(button_style_context, "pill");
    c.gtk_style_context_add_class(button_style_context, "suggested-action");
    _ = c.g_signal_connect_data(popup_button, "clicked", c.G_CALLBACK(&show_popup), null, null, 0);

    c.gtk_box_append(@ptrCast(box), @ptrCast(ziglings_image));
    c.gtk_box_append(@ptrCast(box), @ptrCast(popup_button));

    c.gtk_window_set_child(@ptrCast(window), @ptrCast(box));
    c.gtk_widget_show(@ptrCast(window));
}

fn show_popup(_: *c.GtkApplication, _: c.gpointer) callconv(.C) void {
    const dialog: *c.AdwDialog = c.adw_alert_dialog_new("Surprise!", "Hello");
    c.adw_alert_dialog_add_response(@ptrCast(dialog), "", "Ok");
    c.adw_alert_dialog_choose(@ptrCast(dialog), @ptrCast(window), null, null, null);
}