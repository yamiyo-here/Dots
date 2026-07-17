#!/usr/bin/env bash
set -euo pipefail

DOTS_DIR="$(cd "$(dirname "$0")" && pwd)"
CONFIGS_DIR="$DOTS_DIR/configs"
CONFIG_DIR="$HOME/.config"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
NC='\033[0m'

missing_pacman=()
missing_yay=()

# ── Dependency check ────────────────────────────────────────────────────

check_deps() {
    echo -e "\n${CYAN}Checking dependencies...${NC}\n"

    # pacman packages: command -> package name
    local -A PACMAN_PKGS=(
        [hyprland]="hyprland"
        [hyprpm]="hyprpm"
        [kitty]="kitty"
        [waybar]="waybar"
        [rofi]="rofi"
        [swaync]="swaync"
        [swayosd]="swayosd"
        [cava]="cava"
        [fastfetch]="fastfetch"
        [grim]="grim"
        [slurp]="slurp"
        [jq]="jq"
        [playerctl]="playerctl"
        [wl-copy]="wl-clipboard"
        [wtype]="wtype"
        [notify-send]="libnotify"
        [nemo]="nemo"
        [firefox]="firefox"
        [mpv]="mpv"
        [pipewire]="pipewire"
        [wpctl]="wireplumber"
        [pulsemixer]="pulsemixer"
        [qt6ct]="qt6ct"
        [kvantum]="kvantum"
        [nwg-look]="nwg-look"
    )

    # AUR packages: command -> package name
    local -A AUR_PKGS=(
        [hyprpolkitagent]="hyprpolkitagent"
        [hyprmoncfg]="hyprmoncfg"
        [wallust]="wallust"
        [pywalfox]="python-pywalfox"
        [awww]="awww"
        [rofi-bluetooth]="rofi-bluetooth-git"
        [swappy]="swappy"
        [wl-screenrec]="wl-screenrec-git"
        [cliphist]="cliphist"
        [yay]="yay"
        [quickshell]="quickshell"
    )

    # Fonts: display name -> AUR package
    local -A FONTS=(
        [ttf-jetbrains-mono-nerd]="ttf-jetbrains-mono-nerd"
        [ttf-meslo-nerd-font-powerlevel10k]="ttf-meslo-nerd-font-powerlevel10k"
    )

    echo -e "${YELLOW}Pacman packages:${NC}"
    for cmd in "${!PACMAN_PKGS[@]}"; do
        pkg="${PACMAN_PKGS[$cmd]}"
        if command -v "$cmd" &>/dev/null; then
            echo -e "  ${GREEN}✓${NC} $cmd"
        else
            missing_pacman+=("$pkg")
            echo -e "  ${RED}✗${NC} $cmd ${CYAN}($pkg)${NC}"
        fi
    done

    echo -e "\n${YELLOW}AUR packages:${NC}"
    for cmd in "${!AUR_PKGS[@]}"; do
        pkg="${AUR_PKGS[$cmd]}"
        if command -v "$cmd" &>/dev/null; then
            echo -e "  ${GREEN}✓${NC} $cmd"
        else
            missing_yay+=("$pkg")
            echo -e "  ${RED}✗${NC} $cmd ${CYAN}($pkg)${NC}"
        fi
    done

    echo -e "\n${YELLOW}Fonts:${NC}"
    for font in "${!FONTS[@]}"; do
        pkg="${FONTS[$font]}"
        if fc-list | grep -qi "$font"; then
            echo -e "  ${GREEN}✓${NC} $font"
        else
            missing_yay+=("$pkg")
            echo -e "  ${RED}✗${NC} $font ${CYAN}($pkg)${NC}"
        fi
    done

    # GTK theme
    echo -e "\n${YELLOW}GTK theme:${NC}"
    if [[ -d "$HOME/.themes/Materia-dark-compact" ]] || pacman -Qi materia-gtk-theme &>/dev/null; then
        echo -e "  ${GREEN}✓${NC} materia-gtk-theme"
    else
        missing_pacman+=("materia-gtk-theme")
        echo -e "  ${RED}✗${NC} materia-gtk-theme"
    fi

    # Cursor theme
    if pacman -Qi bibata-cursor-theme &>/dev/null; then
        echo -e "  ${GREEN}✓${NC} bibata-cursor-theme"
    else
        missing_pacman+=("bibata-cursor-theme")
        echo -e "  ${RED}✗${NC} bibata-cursor-theme"
    fi

    echo ""
}

# ── Ask to install ──────────────────────────────────────────────────────

ask_install() {
    local label="$1"
    shift
    local pkgs=("$@")
    [[ ${#pkgs[@]} -eq 0 ]] && return

    echo -e "${YELLOW}$label${NC}"
    for pkg in "${pkgs[@]}"; do
        echo -e "  - $pkg"
    done
    echo ""

    read -rp "Install these packages? [y/N] " answer
    case "$answer" in
        [yY][eE][sS]|[yY])
            echo -e "\n${CYAN}Installing...${NC}"
            if [[ "$label" == *"AUR"* ]]; then
                yay -S --needed --noconfirm "${pkgs[@]}"
            else
                sudo pacman -S --needed --noconfirm "${pkgs[@]}"
            fi
            echo -e "${GREEN}Done.${NC}\n"
            ;;
        *)
            echo -e "${YELLOW}Skipped. Install these manually if needed.${NC}\n"
            ;;
    esac
}

# ── Copy configs ────────────────────────────────────────────────────────

install_configs() {
    echo -e "${CYAN}Installing configs to $CONFIG_DIR...${NC}\n"

    local folders=(cava fastfetch hypr kitty quickshell rofi swaync swayosd wallust waybar yamiyo)

    for folder in "${folders[@]}"; do
        src="$CONFIGS_DIR/$folder"
        dest="$CONFIG_DIR/$folder"

        if [[ ! -d "$src" ]]; then
            echo -e "  ${YELLOW}~${NC} $folder (not found, skipping)"
            continue
        fi

        if [[ -d "$dest" ]]; then
            echo -e "  ${YELLOW}!${NC} $folder (backing up → $folder.bak)"
            mv "$dest" "$dest.bak"
        fi

        cp -r "$src" "$dest"
        echo -e "  ${GREEN}✓${NC} $folder"
    done
    echo ""
}

# ── Main ────────────────────────────────────────────────────────────────

echo -e "${CYAN}═══════════════════════════════════${NC}"
echo -e "${CYAN}         Dots Installer           ${NC}"
echo -e "${CYAN}═══════════════════════════════════${NC}"

check_deps

if [[ ${#missing_pacman[@]} -gt 0 ]]; then
    ask_install "Missing pacman packages:" "${missing_pacman[@]}"
fi

if [[ ${#missing_yay[@]} -gt 0 ]]; then
    ask_install "Missing AUR packages:" "${missing_yay[@]}"
fi

install_configs

echo -e "${GREEN}Done!${NC} Log out and back in for changes to take effect."
echo -e "Put wallpapers in ${CYAN}~/Pictures/wallz/${NC} and press ${CYAN}ALT + W${NC} to browse."
