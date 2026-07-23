#!/usr/bin/env python3
"""Optimize built site images for deploy: resize, WebP, rewrite references.

Source Markdown/front matter keep original filenames (e.g. .jpg) for the author;
only the built site directory is changed.

Usage:
  scripts/optimize-site-images.py [_site]

Env:
  MAX_EDGE  max long edge in pixels (default 1600)
  QUALITY   WebP quality 1–100 (default 80)
"""

import argparse
import os
import re
import shutil
import subprocess
import sys
from pathlib import Path
from typing import Tuple

SOURCE_SUFFIXES = {".jpg", ".jpeg", ".png"}
REWRITE_SUFFIXES = {".html", ".xml", ".json"}

# assets/img/...file.jpg|jpeg|png → same path with .webp (skip favicon/)
REF_PATTERN = re.compile(
    r"(assets/img/(?:(?!favicon/)[^\"'?\s>]+))\.(?:jpe?g|png)",
    re.IGNORECASE,
)


def die(message: str) -> None:
    print(f"error: {message}", file=sys.stderr)
    sys.exit(1)


def require_imagemagick() -> str:
    # Ubuntu packages ImageMagick 6 as `convert`; IM7 uses `magick`.
    for name in ("magick", "convert"):
        path = shutil.which(name)
        if path is not None:
            return path
    die("ImageMagick is required (command 'magick' or 'convert')")


def convert_images(
    img_root: Path, im_cmd: str, max_edge: int, quality: int
) -> Tuple[int, int, int]:
    converted = 0
    bytes_before = 0
    bytes_after = 0

    sources = sorted(
        p
        for p in img_root.rglob("*")
        if p.is_file() and p.suffix.lower() in SOURCE_SUFFIXES
    )

    for src in sources:
        if "favicon" in src.relative_to(img_root).parts:
            continue

        dest = src.with_suffix(".webp")
        before = src.stat().st_size
        bytes_before += before

        subprocess.run(
            [
                im_cmd,
                str(src),
                "-auto-orient",
                "-resize",
                f"{max_edge}x{max_edge}>",
                "-strip",
                "-quality",
                str(quality),
                str(dest),
            ],
            check=True,
        )

        after = dest.stat().st_size
        bytes_after += after
        src.unlink()
        converted += 1
        print(f"  {src} -> {dest} ({before} -> {after} bytes)")

    return converted, bytes_before, bytes_after


def rewrite_references(site_dir: Path) -> Tuple[int, int]:
    changed_files = 0
    replacements = 0

    for path in sorted(site_dir.rglob("*")):
        if not path.is_file() or path.suffix.lower() not in REWRITE_SUFFIXES:
            continue

        text = path.read_text(encoding="utf-8")
        new_text, n = REF_PATTERN.subn(r"\1.webp", text)
        if n:
            path.write_text(new_text, encoding="utf-8")
            changed_files += 1
            replacements += n

    return replacements, changed_files


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "site_dir",
        nargs="?",
        default="_site",
        type=Path,
        help="built site directory (default: _site)",
    )
    args = parser.parse_args()

    site_dir = args.site_dir
    max_edge = int(os.environ.get("MAX_EDGE", "1600"))
    quality = int(os.environ.get("QUALITY", "80"))

    if not site_dir.is_dir():
        die(f"site directory not found: {site_dir}")

    img_root = site_dir / "assets" / "img"
    if not img_root.is_dir():
        die(f"no images at {img_root}")

    im_cmd = require_imagemagick()
    converted, bytes_before, bytes_after = convert_images(
        img_root, im_cmd, max_edge, quality
    )
    replacements, changed_files = rewrite_references(site_dir)

    print(f"rewrote {replacements} image reference(s) in {changed_files} file(s)")
    print(f"optimize-site-images: converted={converted}")
    print(
        "optimize-site-images: image payload "
        f"{bytes_before / 1048576:.2f} MiB -> {bytes_after / 1048576:.2f} MiB "
        f"(max edge {max_edge}px, quality {quality})"
    )


if __name__ == "__main__":
    main()
