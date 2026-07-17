#!/usr/bin/env bash
set -eo pipefail

DRY_RUN=false
[[ "${1:-}" == "--dry-run" || "${1:-}" == "-n" ]] && DRY_RUN=true

DOTS_DIR="$(cd "$(dirname "$0")" && pwd)"
CONFIGS_DIR="$DOTS_DIR/configs"
CONFIG_DIR="$HOME/.config"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
DIM='\033[2m'
NC='\033[0m'

missing_pacman=()
missing_yay=()

pkg_installed() {
    pacman -Qi "$1" &>/dev/null
}

# ── Dependency check ────────────────────────────────────────────────────

check_deps() {
    echo -e "\n${CYAN}Checking dependencies...${NC}\n"

    # pacman packages: binary_to_check -> package_name
    # Use pacman -Qi for packages where binary name != package name
    local -A PACMAN_PKGS=(
        [hyprland]="hyprland"
        [kitty]="kitty"
        [waybar]="waybar"
        [rofi]="rofi"
        [swaync]="swaync"
        [swayosd-server]="swayosd"
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
        [pamixer]="pamixer"
        [brightnessctl]="brightnessctl"
        [blueman]="blueman"
        [qt6ct]="qt6ct"
        [kvantummanager]="kvantum"
        [nwg-look]="nwg-look"
    )

    # Packages that have no standard binary in PATH — check via pacman directly
    local -A PACMAN_NOBIN=(
        [materia-gtk-theme]="materia-gtk-theme"
    )

    # AUR packages: binary_to_check -> package_name
    local -A AUR_PKGS=(
        [hyprmoncfg]="hyprmoncfg"
        [wallust]="wallust"
        [pywalfox]="python-pywalfox"
        [awww]="awww"
        [rofi-bluetooth]="rofi-bluetooth-git"
        [swappy]="swappy"
        [wl-screenrec]="wl-screenrec-git"
        [cliphist]="cliphist"
        [yay]="yay"
        [qs]="quickshell-overview-git"
        [whitesur-icon-theme]="whitesur-icon-theme"
        [rofi-calc]="rofi-calc"
        [rofi-emoji]="rofi-emoji"
        [rofi-wifi]="rofi-wifi"
    )

    # AUR packages without standard binary
    local -A AUR_NOBIN=(
        [hyprpolkitagent]="hyprpolkitagent"
        [bibata-cursor-theme]="bibata-cursor-theme"
    )

    echo -e "${YELLOW}Pacman packages:${NC}"
    for cmd in "${!PACMAN_PKGS[@]}"; do
        pkg="${PACMAN_PKGS[$cmd]}"
        if command -v "$cmd" &>/dev/null || pkg_installed "$pkg"; then
            echo -e "  ${GREEN}✓${NC} $cmd"
        else
            missing_pacman+=("$pkg")
            echo -e "  ${RED}✗${NC} $cmd ${CYAN}($pkg)${NC}"
        fi
    done

    for pkg in "${!PACMAN_NOBIN[@]}"; do
        if pkg_installed "$pkg"; then
            echo -e "  ${GREEN}✓${NC} $pkg"
        else
            missing_pacman+=("$pkg")
            echo -e "  ${RED}✗${NC} $pkg"
        fi
    done

    echo -e "\n${YELLOW}AUR packages:${NC}"
    for cmd in "${!AUR_PKGS[@]}"; do
        pkg="${AUR_PKGS[$cmd]}"
        if command -v "$cmd" &>/dev/null || pkg_installed "$pkg"; then
            echo -e "  ${GREEN}✓${NC} $cmd"
        else
            missing_yay+=("$pkg")
            echo -e "  ${RED}✗${NC} $cmd ${CYAN}($pkg)${NC}"
        fi
    done

    for pkg in "${!AUR_NOBIN[@]}"; do
        if pkg_installed "$pkg"; then
            echo -e "  ${GREEN}✓${NC} $pkg"
        else
            missing_yay+=("$pkg")
            echo -e "  ${RED}✗${NC} $pkg"
        fi
    done

    # Fonts (store output to avoid SIGPIPE with pipefail)
    echo -e "\n${YELLOW}Fonts:${NC}"
    local font_list
    font_list="$(fc-list 2>/dev/null)"

    if grep -qi "JetBrainsMono" <<< "$font_list"; then
        echo -e "  ${GREEN}✓${NC} JetBrainsMono Nerd Font"
    else
        missing_yay+=("ttf-jetbrains-mono-nerd")
        echo -e "  ${RED}✗${NC} JetBrainsMono Nerd Font ${CYAN}(ttf-jetbrains-mono-nerd)${NC}"
    fi

    if grep -qi "MesloLGS" <<< "$font_list"; then
        echo -e "  ${GREEN}✓${NC} MesloLGS NF"
    else
        missing_yay+=("ttf-meslo-nerd-font-powerlevel10k")
        echo -e "  ${RED}✗${NC} MesloLGS NF ${CYAN}(ttf-meslo-nerd-font-powerlevel10k)${NC}"
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

    if $DRY_RUN; then
        echo -e "  ${DIM}[dry-run] would run:${NC}"
        if [[ "$label" == *"AUR"* ]]; then
            echo -e "  ${DIM}yay -S --needed --noconfirm ${pkgs[*]}${NC}"
        else
            echo -e "  ${DIM}sudo pacman -S --needed --noconfirm ${pkgs[*]}${NC}"
        fi
        echo ""
        return
    fi

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

        if $DRY_RUN; then
            if [[ -d "$dest" ]]; then
                echo -e "  ${YELLOW}!${NC} $folder ${DIM}(would backup → $folder.bak)${NC}"
            else
                echo -e "  ${DIM}$folder (would copy)${NC}"
            fi
            continue
        fi

        if [[ -d "$dest" ]]; then
            read -rp "  Backup & replace $folder? [y/N] " answer
            case "$answer" in
                [yY][eE][sS]|[yY])
                    echo -e "  ${YELLOW}!${NC} $folder (backing up → $folder.bak)"
                    mv "$dest" "$dest.bak"
                    ;;
                *)
                    echo -e "  ${YELLOW}~${NC} $folder (skipped)"
                    continue
                    ;;
            esac
        else
            read -rp "  Copy $folder to ~/.config/? [y/N] " answer
            case "$answer" in
                [yY][eE][sS]|[yY]) ;;
                *)
                    echo -e "  ${YELLOW}~${NC} $folder (skipped)"
                    continue
                    ;;
            esac
        fi

        cp -r "$src" "$dest"
        echo -e "  ${GREEN}✓${NC} $folder"
    done
    echo ""
}

# ── Main ────────────────────────────────────────────────────────────────

if $DRY_RUN; then
    echo -e "${CYAN}═══════════════════════════════════${NC}"
    echo -e "${CYAN}      Dots Installer (dry-run)    ${NC}"
    echo -e "${CYAN}═══════════════════════════════════${NC}"
else
    echo -e "${CYAN}═══════════════════════════════════${NC}"
    echo -e "${CYAN}         Dots Installer           ${NC}"
    echo -e "${CYAN}═══════════════════════════════════${NC}"
fi

check_deps

if [[ ${#missing_pacman[@]} -gt 0 ]]; then
    ask_install "Missing pacman packages:" "${missing_pacman[@]}"
fi

if [[ ${#missing_yay[@]} -gt 0 ]]; then
    ask_install "Missing AUR packages:" "${missing_yay[@]}"
fi

install_configs

if $DRY_RUN; then
    echo -e "${CYAN}Dry run complete. Nothing was changed.${NC}"
else
    echo -e "${GREEN}Done!${NC} Log out and back in for changes to take effect."
    echo -e "Put wallpapers in ${CYAN}~/Pictures/wallz/${NC} and press ${CYAN}ALT + W${NC} to browse."
fi
