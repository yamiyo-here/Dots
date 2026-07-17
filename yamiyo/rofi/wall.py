#!/usr/bin/env python3
"""
Wallpaper selector using awww + wallust + rofi.
"""

import os
import sys
import subprocess
import random
import argparse
import tempfile
from pathlib import Path

# ── CONFIG ──────────────────────────────────────────────────────────────

ROOT = Path.home() / "Pictures" / "wallz"
ROFI_THEME = Path.home() / ".config" / "rofi" / "themes" / "Wall.rasi"
WALL_SYMLINK = Path.home() / ".wall"

FPS = 60
TYPE = "wave"
DURATION = 1
ANGLE = 56
AWWW_PARAMS = f"--transition-fps {FPS} --transition-type {TYPE} --transition-duration {DURATION} --transition-angle {ANGLE}"

IMG_EXTS = {".jpg", ".jpeg", ".png", ".webp", ".gif", ".bmp", ".tiff", ".avif"}

# ── UTILS ───────────────────────────────────────────────────────────────

def get_image_files(directory: Path) -> list[Path]:
    return sorted(f for f in directory.iterdir() if f.is_file() and f.suffix.lower() in IMG_EXTS)

def get_all_images(directory: Path) -> list[Path]:
    return [f for f in directory.rglob("*") if f.is_file() and f.suffix.lower() in IMG_EXTS]

def get_subdirs(directory: Path) -> list[Path]:
    return sorted(d for d in directory.iterdir() if d.is_dir())

def find_dir_icon(directory: Path) -> Path | None:
    """Pick a random image from THIS directory only (not subdirs)."""
    images = get_image_files(directory)
    return random.choice(images) if images else None

def escape_pango(text: str) -> str:
    return text.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;")

def get_current_wall() -> Path | None:
    """Resolve current wallpaper from ~/.wall symlink."""
    if WALL_SYMLINK.is_symlink():
        target = WALL_SYMLINK.resolve()
        if target.exists():
            return target
    return None

def run_rofi(entries: list[tuple[str, str, Path | None]], prompt: str) -> str | None:
    """Run rofi with icon support. entries: (display, return_val, icon_path)."""
    lines_bytes = []
    for display, _, icon in entries:
        if icon and icon.exists():
            line = f"{display}\0icon\x1f{icon}\n"
        else:
            line = f"{display}\n"
        lines_bytes.append(line.encode("utf-8"))

    cmd = [
        "rofi", "-dmenu",
        "-theme", str(ROFI_THEME),
        "-p", prompt,
        "-markup-rows", "-i",
    ]
    if not ROFI_THEME.exists():
        cmd = ["rofi", "-dmenu", "-p", prompt, "-markup-rows", "-i"]

    result = subprocess.run(cmd, input=b"".join(lines_bytes), capture_output=True)
    if result.returncode != 0:
        return None

    selected = result.stdout.decode("utf-8").strip()

    # Match exact display string (with or without pango tags)
    for display, ret_val, _ in entries:
        clean = display.replace("<b>", "").replace("</b>", "").replace("<i>", "").replace("</i>", "")
        if selected in (display, clean):
            return ret_val

    # Fallback: partial match
    for display, ret_val, _ in entries:
        clean = display.replace("<b>", "").replace("</b>").replace("<i>", "").replace("</i>", "")
        if selected in clean or clean in selected:
            return ret_val

    return None

def set_wallpaper(image_path: Path) -> bool:
    print(f"Setting wallpaper: {image_path}")

    # Update symlink
    try:
        WALL_SYMLINK.unlink(missing_ok=True)
        WALL_SYMLINK.symlink_to(image_path.resolve())
    except OSError as e:
        print(f"Warning: could not update symlink: {e}")

    # Set wallpaper via awww
    awww_cmd = ["awww", "img", str(image_path)] + AWWW_PARAMS.split()
    try:
        subprocess.run(awww_cmd, check=True)
    except (subprocess.CalledProcessError, FileNotFoundError) as e:
        print(f"awww failed: {e}")
        return False

    # Generate colors via wallust
    try:
        subprocess.run(["wallust", "run", str(image_path)], capture_output=True)
    except FileNotFoundError:
        pass

    run_post_commands()
    return True

def run_post_commands() -> None:
    cmds = [
        (["pkill", "swayosd-server"], False),
        (["swayosd-server"], True),
        (["pywalfox", "update"], False),
        (["hyprctl", "reload"], False),
    ]
    for cmd, background in cmds:
        try:
            if background:
                subprocess.Popen(cmd, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
            else:
                subprocess.run(cmd, capture_output=True)
        except FileNotFoundError:
            pass

def send_notification(image_path: Path) -> None:
    """Send non-blocking notification with 'Open in sxiv' action."""
    filename = image_path.name
    script = f'''#!/bin/sh
action=$(notify-send \
    -i "{image_path}" \
    -a "Wallpaper Selector" \
    -u low \
    -t 0 \
    --action="open-sxiv=Open in sxiv" \
    "🖼️  Wallpaper set" \
    "{filename}")
[ "$action" = "open-sxiv" ] && sxiv "{image_path}" &
'''
    with tempfile.NamedTemporaryFile(mode="w", suffix=".sh", delete=False) as f:
        f.write(script)
        tmp = Path(f.name)

    tmp.chmod(0o755)
    subprocess.Popen([str(tmp)], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)

def browse_directory(directory: Path) -> Path | str | None:
    entries = []

    # Parent directory
    if directory != ROOT:
        entries.append(("📁  ..", f"DIR:{directory.parent}", None))

    # Random preselection from all images
    all_imgs = get_all_images(directory)
    if all_imgs:
        preselected = random.choice(all_imgs)
        entries.append(("🎲  Random", f"RANDOM:{preselected}", preselected))

    # Reload current wallpaper
    current_wall = get_current_wall()
    entries.append(("🔄  Reload", "RELOAD", current_wall))

    # Subdirectories with preview icon
    for subdir in get_subdirs(directory):
        icon = find_dir_icon(subdir)
        entries.append((f"📁  {escape_pango(subdir.name)}", f"DIR:{subdir}", icon))

    # Images in current directory
    for img in get_image_files(directory):
        entries.append((f"🖼️  {escape_pango(img.name)}", f"IMG:{img}", img))

    if not entries:
        subprocess.run(["notify-send", "No images found", str(directory)])
        return None

    selected = run_rofi(entries, directory.name)
    if selected is None:
        return None

    # Parse selection
    if selected.startswith("DIR:"):
        return browse_directory(Path(selected[4:]))
    if selected.startswith(("IMG:", "RANDOM:")):
        return Path(selected.split(":", 1)[1])
    return selected  # "RELOAD" or None

def handle_reload() -> None:
    current = get_current_wall()
    if not current:
        print("No current wallpaper found (no ~/.wall symlink)")
        sys.exit(1)
    if set_wallpaper(current):
        send_notification(current)
        print(f"Reloaded: {current}")
    else:
        print("Failed to reload wallpaper")
        sys.exit(1)

def main() -> None:
    parser = argparse.ArgumentParser(description="Wallpaper selector")
    parser.add_argument("-d", "--dir", type=str, help="Start directory")
    parser.add_argument("-r", "--random", action="store_true", help="Pick random wallpaper")
    parser.add_argument("--reload", action="store_true", help="Re-set current wallpaper")
    args = parser.parse_args()

    if args.reload:
        handle_reload()
        return

    start_dir = Path(args.dir).expanduser() if args.dir else ROOT
    if not start_dir.exists():
        print(f"Directory does not exist: {start_dir}")
        sys.exit(1)

    if args.random:
        imgs = get_all_images(start_dir)
        if not imgs:
            print("No images found")
            sys.exit(1)
        selected = random.choice(imgs)
    else:
        selected = browse_directory(start_dir)

    if selected == "RELOAD":
        handle_reload()
        return

    if isinstance(selected, Path) and set_wallpaper(selected):
        send_notification(selected)
        print(f"Wallpaper set: {selected}")
    elif selected is None:
        print("No wallpaper selected")
    else:
        print("Failed to set wallpaper")
        sys.exit(1)

if __name__ == "__main__":
    main()