# dwm - dynamic window manager

dwm is an extremely fast, small, and dynamic window manager for X.

## Requirements

In order to build dwm you need the Xlib header files.

## Installation

Edit config.mk to match your local setup (dwm is installed into
the /usr/local namespace by default).

Afterwards enter the following command to build and install dwm (if
necessary as root):

    make clean install

## Running dwm

Add the following line to your .xinitrc to start dwm using startx:

    exec dwm

In order to connect dwm to a specific display, make sure that
the DISPLAY environment variable is set correctly, e.g.:

    DISPLAY=foo.bar:1 exec dwm

(This will start dwm on display :1 of the host foo.bar.)

In order to display status info in the bar, you can do something
like this in your .xinitrc:

    while xsetroot -name "`date` `uptime | sed 's/.*,//'`"
    do
    	sleep 1
    done &
    exec dwm

## Configuration

The configuration of dwm is done by creating a custom config.h
and (re)compiling the source code.

## Patches

1.  [autostart](https://dwm.suckless.org/patches/autostart/)

    - https://dwm.suckless.org/patches/autostart/dwm-autostart-20161205-bb3bd6f.diff

2.  dwm-statuscmd-20210405-67d76bd.diff

    - 支持状态栏信号控制

3.  dwm-alpha-20230401-348f655.diff

    - 状态栏支持透明

4.  修改状态栏选中色

    ```c
        static const char col_sel_bg[] = "#6C71C4";
        static const char col_sel_fg[] = "#ECEFF4";
        [SchemeSel]  = { col_sel_fg, col_sel_bg,  col_sel_bg  },

    ```

5.  dwm-fullgaps-6.4.diff
    - 给窗口增加间距
