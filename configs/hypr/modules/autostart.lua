-------------------
---- AUTOSTART ----
-------------------

-- See https://wiki.hypr.land/Configuring/Basics/Autostart/

-- Autostart necessary processes (like notifications daemons, status bars, etc.)
-- Or execute your favorite apps at launch like this:

hl.on("hyprland.start", function () 
    -- OSD
    hl.exec_cmd("swayosd-server")
    hl.exec_cmd("sudo swayosd-libinput-backend")

    -- AWWW daemon
    hl.exec_cmd("awww-daemon")

    -- Polkit agent
    hl.exec_cmd("systemctl --user start hyprpolkitagent")    

    -- Clipboard history
    hl.exec_cmd("wl-paste --type text  --watch cliphist store")
    hl.exec_cmd("wl-paste --type image --watch cliphist store")

    -- Quickshell
    hl.exec_cmd("qs -c overview")

    -- Core apps
    -- hl.exec_cmd("wal -R")
    hl.exec_cmd("waybar")
    hl.exec_cmd("swaync")
    -- hl.exec_cmd("firefox")
    hl.exec_cmd("pywalfox start")
    hl.exec_cmd("hyprpm reload")
end)
