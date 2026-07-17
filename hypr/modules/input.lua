---------------
---- INPUT ----
---------------

hl.config({
    input = {
        kb_layout  = "us,ara",
        kb_options = "grp:win_space_toggle, caps:backspace",

        follow_mouse = 1,
        sensitivity  = 0,

        touchpad = {
            natural_scroll = true,
        },
    },

    binds = {
        scroll_event_delay = 0,
    },
})


hl.device({
    name          = "hid-1bcf:08a0-mouse",
    accel_profile = "flat",
})


----------------
--- GESTURES --- 
----------------

hl.gesture({ fingers = 3, direction = "vertical", action = "workspace" })
hl.gesture({ fingers = 3, direction = "horizontal", action = "scroll_move" })