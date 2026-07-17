


local hs = require("hyprsplit")
hs.config({ num_workspaces = 10 })


---------------------
---- MY PROGRAMS ----
---------------------

-- Set programs that you use
local terminal    = "kitty"
local fileManager = "dolphin"
local menu        = "hyprlauncher"


---------------------
---- KEYBINDINGS ----
---------------------

-- Some Apps
hl.bind("SUPER + return", hl.dsp.exec_cmd("kitty"))

hl.bind("SUPER + Q", hl.dsp.window.close())
hl.bind("SUPER + SHIFT + Q", hl.dsp.exec_cmd("hyprctl kill"))

hl.bind("SUPER + M", hl.dsp.exit())

hl.bind("SUPER + E", hl.dsp.exec_cmd("nemo"))

hl.bind("SUPER + T", hl.dsp.window.float({ action = "toggle" }))

hl.bind("ALT + space", hl.dsp.exec_cmd("rofi -show drun"))

hl.bind("SUPER + N", hl.dsp.exec_cmd("swaync-client -t"))
hl.bind("SUPER + A", hl.dsp.exec_cmd("swaync-client -t"))


hl.bind("SUPER + Z", hl.dsp.exec_cmd("firefox"))


-- Rofi
hl.bind("SUPER + period", hl.dsp.exec_cmd("rofi -show emoji"))
-- hl.bind("SUPER + C",      hl.dsp.exec_cmd("rofi -show calc -modi calc -no-show-match -no-sort"))
hl.bind("SUPER + V",      hl.dsp.exec_cmd("cliphist list | rofi -dmenu -display-columns 2 | cliphist decode | wl-copy && wtype -M ctrl -k v -m ctrl"))
hl.bind("SUPER + SHIFT + V", hl.dsp.exec_cmd("cliphist wipe"))


-- Window focus
hl.bind("SUPER + left",  hl.dsp.layout("focus l"))
hl.bind("SUPER + right", hl.dsp.layout("focus r"))
hl.bind("SUPER + up",    hl.dsp.layout("focus u"))
hl.bind("SUPER + down",  hl.dsp.layout("focus d"))

hl.bind("ALT + Tab", hl.dsp.layout("focus r"))
hl.bind("ALT + SHIFT + Tab", hl.dsp.layout("focus l"))

hl.bind("SUPER + SHIFT + left",  hl.dsp.layout("swapcol l"))
hl.bind("SUPER + SHIFT + right", hl.dsp.layout("swapcol r"))

hl.bind("SUPER + mouse_down", hl.dsp.layout("focus l"))
hl.bind("SUPER + mouse_up",   hl.dsp.layout("focus r"))

hl.bind("SUPER + SHIFT + mouse_down", hl.dsp.layout("swapcol l"))
hl.bind("SUPER + SHIFT + mouse_up",   hl.dsp.layout("swapcol r"))

hl.bind("SUPER + F", hl.dsp.window.fullscreen({action = "toggle"})) 


-- Window Resize
hl.bind("SUPER + CTRL + left",  hl.dsp.layout("colresize -0.1"))
hl.bind("SUPER + CTRL + right", hl.dsp.layout("colresize +0.1"))
hl.bind("SUPER + CTRL + up",    hl.dsp.layout("promote"))

hl.bind("SUPER + CTRL + mouse_up",   hl.dsp.layout("colresize -0.1"))
hl.bind("SUPER + CTRL + mouse_down", hl.dsp.layout("colresize +0.1"))
hl.bind("SUPER + CTRL + mouse:274",  hl.dsp.layout("promote"))


-- Workspaces
for i = 1, 9 do
    hl.bind("SUPER + " .. i,       hs.dsp.focus({ workspace = i }))
    hl.bind("SUPER + SHIFT + " .. i, hs.dsp.window.move({ workspace = i, follow = true }))
end
hl.bind("SUPER + 0",       hs.dsp.focus({ workspace = 10 }))
hl.bind("SUPER + SHIFT + 0", hs.dsp.window.move({ workspace = 10, follow = true }))

hl.bind("SUPER + SHIFT + ALT + W", hs.dsp.grab_rogue_windows())

hl.bind("SUPER + Tab", function()
    hl.plugin.scrolloverview.overview("toggle")
end)

hl.bind("SUPER + SHIFT + S", hl.dsp.workspace.toggle_special({ workspace = "magic" }))


-- Mouse drag/resize
hl.bind("SUPER + mouse:272", hl.dsp.window.drag())
hl.bind("SUPER + mouse:273", hl.dsp.window.resize())


-- Media/Volume/Brightness controls
hl.bind("XF86AudioRaiseVolume",  hl.dsp.exec_cmd("swayosd-client --output-volume +2"))
hl.bind("XF86AudioLowerVolume",  hl.dsp.exec_cmd("swayosd-client --output-volume -2"))
hl.bind("XF86AudioMute",         hl.dsp.exec_cmd("swayosd-client --output-volume mute-toggle"))
hl.bind("XF86AudioMicMute",      hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"))
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("swayosd-client --brightness +2 --min-brightness 2"))
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("swayosd-client --brightness -2 --min-brightness 2"))

hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("~/.config/yamiyo/hypr/player-smart.sh next"))
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("~/.config/yamiyo/hypr/player-smart.sh play-pause"))
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("~/.config/yamiyo/hypr/player-smart.sh play-pause"))
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("~/.config/yamiyo/hypr/player-smart.sh prev"))


-- Scripts
hl.bind("ALT + W",        hl.dsp.exec_cmd("~/.config/yamiyo/rofi/wall.py")) -- wallpaper selector
hl.bind("SUPER + X",      hl.dsp.exec_cmd("~/.config/yamiyo/rofi/power.sh")) --power menu
hl.bind("SUPER + SUPER_L", hl.dsp.exec_cmd("~/.config/yamiyo/rofi/menu.sh")) -- main menu
hl.bind("CTRL + Print", hl.dsp.exec_cmd("~/.config/yamiyo/hypr/screenshot.sh full")) -- full screenshot
hl.bind("SHIFT + Print",  hl.dsp.exec_cmd("~/.config/yamiyo/hypr/screenshot.sh window")) -- window screenshot
hl.bind("Print",  hl.dsp.exec_cmd("~/.config/yamiyo/hypr/screenshot.sh area")) -- selected screenshot
hl.bind("ALT + Print", hl.dsp.exec_cmd("~/.config/yamiyo/hypr/record.sh")) -- record screen
hl.bind("SUPER + R", hl.dsp.exec_cmd("~/.config/yamiyo/hypr/refresh.sh")) -- refresh waybar

-- Gamemode bind
hl.bind("SUPER + F1", function ()
    local game_mode = (hl.get_config("animations.enabled") == false)

    if game_mode then
        hl.exec_cmd("hyprctl reload")
        return
    end
    
    hl.config({
        general = {
            gaps_in = 0, gaps_out = 0, -- Disable gaps  
            border_size = 0,
        },

        animations = {
            enabled = false, -- Disable animations
        },
        
        -- Disable blur, shadow and window rounding
        decoration = {
            shadow = { enabled = false },
            blur = { enabled = false },
            rounding = 0,
        }
    })
end)