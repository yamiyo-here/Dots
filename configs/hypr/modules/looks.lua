-----------------------
---- LOOK AND FEEL ----
-----------------------

local c = require("colors")
-- Refer to https://wiki.hypr.land/Configuring/Basics/Variables/
hl.config({
    general = {
        gaps_in  = 4,
        gaps_out = 6,

        border_size = 1,

        col = {
            active_border   = c.active_border,
            inactive_border = c.inactive_border,
        },

        -- Set to true to enable resizing windows by clicking and dragging on borders and gaps
        resize_on_border = false,

        -- Please see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Tearing/ before you turn this on
        allow_tearing = false,

    },

    decoration = {
        rounding       = 8,
        rounding_power = 2,

        -- Change transparency of focused and unfocused windows
        active_opacity   = 0.9,
        inactive_opacity = 0.75,

        shadow = {
            enabled      = false,
        },

        blur = {
            enabled   = true,
            size      = 6,
            passes    = 2,
            vibrancy  = 0.1696,
        },
    },

    animations = {
        enabled = true,
    },
})


-- Curves

-- Snappy ease-out for opens (old: fastOut)
hl.curve("fastOut", { type = "bezier", points = { {0.2, 1}, {0.3, 1} } })

-- Snappy ease-in for closes (old: fastIn)
hl.curve("fastIn",  { type = "bezier", points = { {0.7, 0}, {0.84, 0} } })

-- Sharp, responsive curve for general transitions (old: sharp)
hl.curve("sharp",   { type = "bezier", points = { {0.55, 0.05}, {0.25, 0.95} } })

-- A spring variant tuned for the old "fast" feel (higher stiffness, more dampening = less bounce)
hl.curve("snappy",   { type = "spring", mass = 1, stiffness = 120, dampening = 22 })


-- Global: slightly faster than old (7 -> 6), keep sharp
hl.animation({ leaf = "global",        enabled = true, speed = 6,   bezier = "sharp" })

-- Windows: use spring for modern feel, but keep popin 95% and fast speeds
hl.animation({ leaf = "windows",        enabled = true, speed = 3,   spring = "snappy", style = "slide" })
hl.animation({ leaf = "windowsIn",      enabled = true, speed = 2.5, spring = "snappy", style = "popin 95%" })
hl.animation({ leaf = "windowsOut",     enabled = true, speed = 2.5, bezier = "fastIn",  style = "popin 95%" })
hl.animation({ leaf = "windowsMove",     enabled = true, speed = 1.5, spring = "snappy" })

-- Fade: sharper, faster than default
hl.animation({ leaf = "fade",           enabled = true, speed = 1.8, bezier = "sharp" })
hl.animation({ leaf = "fadeIn",         enabled = true, speed = 1.2, bezier = "fastOut" })
hl.animation({ leaf = "fadeOut",        enabled = true, speed = 1.4, bezier = "fastIn" })
hl.animation({ leaf = "fadeSwitch",     enabled = true, speed = 1.6, bezier = "fastIn" })
hl.animation({ leaf = "fadeShadow",     enabled = true, speed = 1.6, bezier = "fastIn" })
hl.animation({ leaf = "fadeGlow",       enabled = true, speed = 1.6, bezier = "fastIn" })
hl.animation({ leaf = "fadeDim",        enabled = true, speed = 2.0, bezier = "sharp" })

-- Layers: slide from bottom, fast
hl.animation({ leaf = "layers",         enabled = true, speed = 2.5, bezier = "sharp",   style = "slide bottom" })
hl.animation({ leaf = "layersIn",       enabled = true, speed = 2,   bezier = "fastOut", style = "slide bottom" })
hl.animation({ leaf = "layersOut",      enabled = true, speed = 2.2, bezier = "fastIn",  style = "slide bottom" })
hl.animation({ leaf = "fadeLayersIn",  enabled = true, speed = 1.2, bezier = "fastOut" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.4, bezier = "fastIn" })

-- Popups: inherit layers direction but slightly faster
hl.animation({ leaf = "fadePopups",     enabled = true, speed = 1.5, bezier = "sharp" })
hl.animation({ leaf = "fadePopupsIn",   enabled = true, speed = 1.2, bezier = "fastOut" })
hl.animation({ leaf = "fadePopupsOut",  enabled = true, speed = 1.4, bezier = "fastIn" })

-- Workspaces: vertical slide, very snappy
hl.animation({ leaf = "workspaces",     enabled = true, speed = 2.5, bezier = "sharp",   style = "slidevert" })
hl.animation({ leaf = "workspacesIn",   enabled = true, speed = 2,   bezier = "fastOut", style = "slidevert" })
hl.animation({ leaf = "workspacesOut",  enabled = true, speed = 1,   bezier = "fastIn",  style = "slidevert" })

-- Special workspace: match workspaces but slightly faster
hl.animation({ leaf = "specialWorkspace",    enabled = true, speed = 2,   bezier = "sharp",   style = "slidevert" })
hl.animation({ leaf = "specialWorkspaceIn",  enabled = true, speed = 1.5, bezier = "fastOut", style = "slidevert" })
hl.animation({ leaf = "specialWorkspaceOut", enabled = true, speed = 0.8, bezier = "fastIn",  style = "slidevert" })

-- Border: quick color transitions
hl.animation({ leaf = "border",         enabled = true, speed = 4,   bezier = "sharp" })

-- Border angle: subtle loop if you use gradients (new feature!)
-- hl.animation({ leaf = "borderangle",    enabled = true, speed = 20,  bezier = "linear",  style = "loop" })

-- Zoom: fast ease-out
hl.animation({ leaf = "zoomFactor",     enabled = true, speed = 3,   bezier = "fastOut" })

-- Monitor added: subtle zoom
hl.animation({ leaf = "monitorAdded",   enabled = true, speed = 4,   bezier = "fastOut" })


-- Ref https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/
-- "Smart gaps" / "No gaps when only"
-- uncomment all if you wish to use that.
-- hl.workspace_rule({ workspace = "w[tv1]", gaps_out = 0, gaps_in = 0 })
-- hl.workspace_rule({ workspace = "f[1]",   gaps_out = 0, gaps_in = 0 })
-- hl.window_rule({
--     name  = "no-gaps-wtv1",
--     match = { float = false, workspace = "w[tv1]" },
--     border_size = 0,
--     rounding    = 0,
-- })
-- hl.window_rule({
--     name  = "no-gaps-f1",
--     match = { float = false, workspace = "f[1]" },
--     border_size = 0,
--     rounding    = 0,
-- })


