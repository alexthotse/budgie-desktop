/*
 * This file is part of budgie-desktop
 * 
 * Copyright (C) 2016 Ikey Doherty <ikey@solus-project.com>
 * 
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 */

namespace Budgie
{

public static const int OSD_SIZE = 250;

/**
 * The BudgieOSD provides a very simplistic On Screen Display service, complying with the
 * private GNOME Settings Daemon -> GNOME Shell protocol.
 *
 * In short, all elements of the permanently present window should be able to hide or show
 * depending on the updated ShowOSD message, including support for a progress bar (level),
 * icon, optional label.
 *
 * This OSD is used by gnome-settings-daemon to portray special events, such as brightness/volume
 * changes, physical volume changes (disk eject/mount), etc. This special window should remain
 * above all other windows and be non-interactive, allowing unobtrosive overlay of information
 * even in full screen movies and games.
 *
 * Each request to ShowOSD will reset the expiration timeout for the OSD's current visibility,
 * meaning subsequent requests to the OSD will keep it on screen in a natural fashion, allowing
 * users to "hold down" the volume change buttons, for example.
 */
[GtkTemplate (ui = "/com/solus-project/budgie/daemon/osd.ui")]
public class OSD : Gtk.Window
{
    public OSD()
    {
        Object(type: Gtk.WindowType.POPUP, type_hint: Gdk.WindowTypeHint.NOTIFICATION);
        /* Skip everything, appear above all else, everywhere. */
        resizable = false;
        skip_pager_hint = true;
        skip_taskbar_hint = true;
        set_decorated(false);
        set_keep_above(true);
        stick();

        /* Set up an RGBA map for transparency styling */
        Gdk.Visual? vis = screen.get_rgba_visual();
        if (vis != null) {
            this.set_visual(vis);
        }

        /* Set up size */
        set_default_size(OSD_SIZE, -1);
        realize();
        move_osd();

        /* Temp! */
        show_all();
    }

    /**
     * Move the OSD into the correct position
     */
    private void move_osd()
    {
        /* Find the primary monitor bounds */
        Gdk.Screen sc = get_screen();
        int monitor = sc.get_primary_monitor();
        Gdk.Rectangle bounds;

        sc.get_monitor_geometry(monitor, out bounds);
        Gtk.Allocation alloc;

        get_allocation(out alloc);

        /* For now just center it */
        int x = bounds.x + ((bounds.width / 2) - (alloc.width / 2));
        int y = bounds.y + ((int)(bounds.height * 0.85));
        move(x, y);
    }
} /* End class OSD (BudgieOSD) */

} /* End namespace Budgie */
