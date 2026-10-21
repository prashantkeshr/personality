"""Makes the Play Store icon (512x512) and feature graphic (1024x500).

python tool/store_graphics.py

Uses the app icon in tool/branding/icon_source.png and Windows' Segoe UI.
Output: docs/store/graphics/.
"""

import os

from PIL import Image, ImageDraw, ImageFilter, ImageFont

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
OUT = os.path.join(ROOT, "docs", "store", "graphics")
BG = (0, 0, 15)  # the icon's own background
FONT = r"C:\Windows\Fonts\segoeui.ttf"
FONT_BOLD = r"C:\Windows\Fonts\segoeuib.ttf"


def icon_art():
    return Image.open(os.path.join(ROOT, "tool", "branding", "icon_source.png")).convert("RGBA")


def fit(img, box):
    w, h = img.size
    s = min(box / w, box / h)
    return img.resize((round(w * s), round(h * s)), Image.LANCZOS)


def play_icon():
    canvas = Image.new("RGBA", (512, 512), BG + (255,))
    art = fit(icon_art(), 400)
    canvas.alpha_composite(art, ((512 - art.width) // 2, (512 - art.height) // 2))
    canvas.convert("RGB").save(os.path.join(OUT, "icon-512.png"))


def feature_graphic():
    w, h = 1024, 500
    img = Image.new("RGB", (w, h), BG)
    # Soft teal-to-violet glow behind the logo.
    glow = Image.new("RGB", (w, h), BG)
    d = ImageDraw.Draw(glow)
    d.ellipse((60, 40, 480, 460), fill=(22, 92, 110))
    d.ellipse((260, 80, 620, 440), fill=(64, 40, 120))
    img = Image.blend(img, glow.filter(ImageFilter.GaussianBlur(90)), 0.85)

    canvas = img.convert("RGBA")
    art = fit(icon_art(), 330)
    canvas.alpha_composite(art, (90, (h - art.height) // 2))

    draw = ImageDraw.Draw(canvas)
    title = ImageFont.truetype(FONT_BOLD, 68)
    line = ImageFont.truetype(FONT, 30)
    small = ImageFont.truetype(FONT, 24)
    x = 470
    draw.text((x, 128), "Personality", font=title, fill=(255, 255, 255))
    draw.text((x, 222), "Wellness, habits & style", font=line, fill=(176, 235, 233))
    draw.text((x, 266), "that stay on your phone.", font=line, fill=(176, 235, 233))
    draw.text((x, 340), "Private · On-device · No ads", font=small, fill=(200, 190, 255))
    canvas.convert("RGB").save(os.path.join(OUT, "feature-graphic-1024x500.png"))


if __name__ == "__main__":
    os.makedirs(OUT, exist_ok=True)
    play_icon()
    feature_graphic()
    print("wrote", sorted(os.listdir(OUT)))
