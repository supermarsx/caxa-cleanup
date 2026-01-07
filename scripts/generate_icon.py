import os
import sys

try:
    from PIL import Image, ImageDraw
except ImportError:
    print("Pillow is not installed. Please run: pip install Pillow")
    sys.exit(1)

def draw_box(size):
    # Base size is 256
    scale = size / 256.0
    
    # Helper to scale points
    def s(x, y):
        return (x * scale, y * scale)
    
    # Create image with transparent background
    img = Image.new('RGBA', (size, size), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)
    
    # Colors
    color_top_left = "#e0c090"
    color_top_right = "#d0b080"
    color_front_left = "#c0a070"
    color_front_right = "#b09060"
    color_stroke = "#604020"
    stroke_width = max(1, int(2 * scale))

    # Points (from original SVG)
    # Top Flap Left: 28 80, 128 40, 128 90, 28 130
    pts_top_left = [s(28, 80), s(128, 40), s(128, 90), s(28, 130)]
    
    # Top Flap Right: 228 80, 128 40, 128 90, 228 130
    pts_top_right = [s(228, 80), s(128, 40), s(128, 90), s(228, 130)]
    
    # Front Face Left: 28 130, 128 170, 128 240, 28 200
    pts_front_left = [s(28, 130), s(128, 170), s(128, 240), s(28, 200)]
    
    # Front Face Right: 228 130, 128 170, 128 240, 228 200
    pts_front_right = [s(228, 130), s(128, 170), s(128, 240), s(228, 200)]

    # Draw Polygons
    draw.polygon(pts_top_left, fill=color_top_left, outline=color_stroke, width=stroke_width)
    draw.polygon(pts_top_right, fill=color_top_right, outline=color_stroke, width=stroke_width)
    draw.polygon(pts_front_left, fill=color_front_left, outline=color_stroke, width=stroke_width)
    draw.polygon(pts_front_right, fill=color_front_right, outline=color_stroke, width=stroke_width)

    # Extra lines for "visual effect of open box"
    # 28 80 -> 28 130
    draw.line([s(28, 80), s(28, 130)], fill=color_stroke, width=stroke_width)
    # 228 80 -> 228 130
    draw.line([s(228, 80), s(228, 130)], fill=color_stroke, width=stroke_width)
    # 128 170 -> 128 240
    draw.line([s(128, 170), s(128, 240)], fill=color_stroke, width=stroke_width)

    return img

def main():
    script_dir = os.path.dirname(os.path.abspath(__file__))
    assets_dir = os.path.join(script_dir, '..', 'assets')
    icon_path = os.path.join(assets_dir, 'icon.ico')

    if not os.path.exists(assets_dir):
        os.makedirs(assets_dir)

    print("Generating icons...")
    sizes = [16, 32, 48, 64, 128, 256]
    images = []
    
    for size in sizes:
        img = draw_box(size)
        images.append(img)
    
    # Save as ICO with all sizes
    # The first image provides the save method, append_images holds the rest
    images[0].save(icon_path, format='ICO', sizes=[(i.width, i.height) for i in images], append_images=images[1:])
    
    print(f"Icon generated at: {icon_path}")

if __name__ == "__main__":
    main()
