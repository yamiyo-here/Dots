# Dots

My Hyprland rice. Wallpaper-driven dynamic theming via wallust, glassmorphic surfaces, spring-physics animations.

Put wallpapers in `~/Pictures/wallz/`. Press `ALT + W` to browse -- colors regenerate across the entire desktop.

## Preview

<!-- add a screenshot here -->

## Dependencies

### Core

| Package | AUR | Notes |
|---------|-----|-------|
| `hyprland` | | Wayland compositor (Lua config support) |
| `hyprpm` | | Plugin manager (comes with Hyprland) |
| | `hyprpolkitagent` | Polkit authentication |
| | `hyprmoncfg` | Monitor config generator |

### Desktop

| Package | AUR | Notes |
|---------|-----|-------|
| `kitty` | | Terminal |
| `waybar` | | Status bar |
| `rofi` | | App launcher (Wayland fork) |
| | `rofi-bluetooth-git` | Bluetooth menu |
| `swaync` | | Notification daemon |
| `swayosd` | | Volume/brightness OSD |
| `cava` | | Audio visualizer |
| `fastfetch` | | System info |
| `nemo` | | File manager |
| `firefox` | | Browser (auto-themed via pywalfox) |
| | `quickshell-overview-git` | Overview widget |

### Theming

| Package | AUR | Notes |
|---------|-----|-------|
| | `wallust` | Wallpaper-based color generation |
| | `python-pywalfox` | Firefox theme sync |
| | `awww` | Wallpaper daemon with transitions |
| `materia-gtk-theme` | | GTK theme |
| | `WhiteSur-icon-theme` | Icon theme ([manual install](https://github.com/vinceliuice/WhiteSur-icon-theme)) |
| `bibata-cursor-theme` | | Cursor theme |
| `qt6ct` | | Qt6 settings |
| `kvantum` | | Qt theme engine |
| `nwg-look` | | GTK appearance manager |

### Fonts

| Package (AUR) | Used by |
|----------------|---------|
| `ttf-jetbrains-mono-nerd` | Waybar, SwayNC, Rofi, SwayOSD |
| `ttf-meslo-nerd-font-powerlevel10k` | Kitty terminal |

### Media

| Package | AUR | Notes |
|---------|-----|-------|
| `playerctl` | | Media player control |
| `mpv` | | Media player |

### Screenshots & Recording

| Package | AUR | Notes |
|---------|-----|-------|
| `grim` | | Screenshot tool |
| `slurp` | | Region selection |
| | `swappy` | Screenshot annotation |
| | `wl-screenrec-git` | Screen recording |

### Clipboard & Input

| Package | AUR | Notes |
|---------|-----|-------|
| | `cliphist` | Clipboard history |
| `wl-clipboard` | | `wl-copy` |
| `wtype` | | Wayland typing utility |
| `libnotify` | | `notify-send` |

### Audio

| Package | AUR | Notes |
|---------|-----|-------|
| `pipewire` | | Audio server |
| `wireplumber` | | Session manager (`wpctl`) |
| `pulsemixer` | | TUI mixer (in waybar) |

### System

| Package | AUR | Notes |
|---------|-----|-------|
| `jq` | | JSON processor |
| | `yay` | AUR helper |

## Install

### Dependencies

```bash
sudo pacman -S --needed hyprland hyprpm kitty waybar rofi swaync swayosd cava fastfetch grim slurp jq playerctl wl-clipboard wtype libnotify nemo firefox mpv pipewire wireplumber pulsemixer qt6ct kvantum nwg-look materia-gtk-theme bibata-cursor-theme

yay -S --needed hyprpolkitagent hyprmoncfg wallust python-pywalfox awww rofi-bluetooth-git swappy wl-screenrec-git cliphist yay quickshell-overview-git ttf-jetbrains-mono-nerd ttf-meslo-nerd-font-powerlevel10k
```

Then install [WhiteSur-icon-theme](https://github.com/vinceliuice/WhiteSur-icon-theme) manually.

### Configs

```bash
git clone https://github.com/yamiyo-here/Dots.git ~/Dots
cd ~/Dots
chmod +x install.sh
./install.sh
```

Test without changes first:

```bash
./install.sh --dry-run
```

The install script will:
1. Check which dependencies are installed
2. Show you each pacman/yay command before running it
3. Copy configs to `~/.config/`
4. Back up any existing configs

## Keybindings

| Key | Action |
|-----|--------|
| `SUPER + Return` | Terminal |
| `SUPER + Space` | Main menu |
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
├── configs/
│   ├── hypr/           Hyprland (Lua modules)
│   │   ├── hyprsplit/  Per-monitor workspaces
│   │   └── modules/    Binds, looks, layout, etc.
│   ├── waybar/         Status bar
│   ├── kitty/          Terminal
│   ├── rofi/           Launcher (3 themes)
│   ├── swaync/         Notifications
│   ├── swayosd/        Volume/brightness OSD
│   ├── cava/           Audio visualizer + GLSL shaders
│   ├── fastfetch/      System info
│   ├── wallust/        Color generation templates
│   ├── quickshell/     Overview widget
│   └── yamiyo/         Scripts
│       ├── hypr/       Screenshot, record, player, refresh
│       ├── rofi/       Menu, power, wallpaper selector
│       └── waybar/     Cava bar, media status
├── install.sh
├── LICENSE
└── README.md
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

[MIT](LICENSE)
