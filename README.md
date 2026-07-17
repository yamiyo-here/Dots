# Dots

My Hyprland rice configuration. Wallpaper-driven dynamic theming via wallust, glassmorphic surfaces, spring-physics animations.

Put your wallpapers in `~/Pictures/wallz/`. Press `ALT + W` to browse and select -- colors regenerate across the entire desktop automatically.

## Preview

<!-- add a screenshot here -->

## Requirements

- **Hyprland** (Lua config support)
- **wallust** -- [codeberg.org/jackmrthews/wallust](https://codeberg.org/jackmrthews/wallust)
- **kitty**, **waybar**, **rofi-wayland**, **swaync**, **swayosd**, **cava**, **fastfetch**
- **quickshell** -- overview widget
- **awww** -- wallpaper daemon
- **pywalfox** -- Firefox theme sync
- **grim**, **slurp**, **swappy** -- screenshots
- **playerctl**, **cliphist**, **wl-screenrec**
- **JetBrainsMono Nerd Font**, **MesloLGS NF**
- **Materia-dark-compact** (GTK), **WhiteSur-dark** (icons), **Bibata-Modern-Classic** (cursor)

## Install

```bash
git clone https://github.com/yamiyo-here/Dots.git ~/Dots
cd ~/Dots
chmod +x install.sh
./install.sh
```

## Keybindings

| Key | Action |
|-----|--------|
| `SUPER + Return` | Terminal |
| `ALT + Space` | App launcher |
| `SUPER + E` | File manager |
| `SUPER + T` | Toggle floating |
| `SUPER + F` | Fullscreen |
| `SUPER + Q` | Close window |
| `SUPER + M` | Exit |
| `SUPER + Tab` | Overview |
| `ALT + W` | Wallpaper selector |
| `SUPER + X` | Power menu |
| `SUPER + V` | Clipboard |
| `SUPER + .` | Emoji |
| `SUPER + N` | Notifications |
| `SUPER + Z` | Firefox |
| `SUPER + F1` | Game mode |
| `SUPER + 1-0` | Workspace |
| `Print` | Screenshot (area) |
| `CTRL + Print` | Screenshot (full) |
| `SHIFT + Print` | Screenshot (window) |
| `ALT + Print` | Record toggle |

## Structure

```
Dots/
├── hypr/           Hyprland (Lua modules)
│   ├── hyprsplit/  Per-monitor workspaces
│   └── modules/    Binds, looks, layout, etc.
├── waybar/         Status bar
├── kitty/          Terminal
├── rofi/           Launcher (3 themes)
│   └── themes/     Main, menu, wallpaper grid
├── swaync/         Notifications
├── swayosd/        Volume/brightness OSD
├── cava/           Audio visualizer + 10 GLSL shaders
├── fastfetch/      System info
├── wallust/        Color generation templates
├── quickshell/     Overview widget
└── yamiyo/         Scripts
    ├── hypr/       Screenshot, record, player, refresh
    ├── rofi/       Menu, power, wallpaper selector
    └── waybar/     Cava bar, media status
```

## Color Pipeline

```
Wallpaper change → wallust → colors.{css,conf,rasi,lua}
  → Hyprland, Waybar, Kitty, Rofi, SwayNC, SwayOSD, Firefox
```

## Credits

- [wallust](https://codeberg.org/jackmrthews/wallust) -- color generation
- [hyprsplit](https://github.com/Aylur/hyprsplit) -- per-monitor workspaces
- [quickshell](https://github.com/quickshell-mirror/quickshell) -- overview widget

## License

Do whatever you want. Credit appreciated.
