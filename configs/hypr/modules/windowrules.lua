

--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/
-- and https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/


-- Window Rules

-- Ignore maximize requests from applications
hl.window_rule({
    name  = "suppress-maximize-events",
    match = { class = ".*" },
    suppress_event = "maximize",
})

-- Fix dragging issues with some XWayland windows
hl.window_rule({
    name  = "fix-xwayland-drags",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },
    no_focus = true,
})

-- FLoating Window Rules

-- local s75 = { w = "monitor_w*0.75", h = "monitor_h*0.75" }
-- local s60 = { w = "monitor_w*0.6",  h = "monitor_h*0.6"  }
-- local s50 = { w = "monitor_w*0.5",  h = "monitor_h*0.6"  }
-- local s55 = { w = "monitor_w*0.55", h = "monitor_h*0.55" }

hl.window_rule({ match = { class = "nwg-look"    }, float = true, center = true, size = {"monitor_w * 0.75", "monitor_h * 0.75"} })
hl.window_rule({ match = { class = "nwg-displays" }, float = true, center = true, size = {"monitor_w * 0.75", "monitor_h * 0.75"}})
hl.window_rule({ match = { class = "lxappearance" }, float = true, center = true, size = {"monitor_w * 0.75", "monitor_h * 0.75"} })
hl.window_rule({ match = { class = "hyprland-share-picker" }, float = true, center = true, size = {"monitor_w * 0.75", "monitor_h * 0.75"} })

hl.window_rule({ match = { class = "blueman-manager" }, float = true, center = true, size = {"monitor_w * 0.5", "monitor_h * 0.6"} })

hl.window_rule({ match = { title = "Open File"          }, float = true, center = true, size = {"monitor_w * 0.6", "monitor_h * 0.6"}})
hl.window_rule({ match = { title = "Picture-in-Picture" }, float = true })

hl.window_rule({ match = { class = "xdg-desktop-portal-gtk" }, float = true, center = true, size = {"monitor_w * 0.6", "monitor_h * 0.6"} })

-- hl.window_rule({ match = { class = "kitty" }, float = true, center = true, size = {"monitor_w * 0.55", "monitor_h * 0.55"} })

hl.window_rule({match = {class = "hyprland-run"}, center = true})


-- Opaque Window Rules

local opaque = { "firefox", "modrinth-app", "zoom" }
for _, app in ipairs(opaque) do
    hl.window_rule({ match = { class = app }, opaque = true })
end


hl.layer_rule({
    match = { namespace = "waybar" },
    blur = true,
    ignore_alpha = 0.1
    })

hl.layer_rule({
    match = { namespace = "rofi" },
    blur = true,
    ignore_alpha = 0
    })

hl.layer_rule({
    match = { namespace = "swaync-control-center" },
    blur = true,
    ignore_alpha = 0
    })
    

for i = 1, 5 do
    hl.workspace_rule({workspace =  "" .. i, persistent = true, monitor = "eDP-1"})
end
for i = 11, 15 do
    hl.workspace_rule({workspace =  "" .. i, persistent = true, monitor = "HDMI-A-1"})
end