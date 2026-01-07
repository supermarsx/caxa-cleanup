import os

svg_content = """<svg width="256" height="256" viewBox="0 0 256 256" xmlns="http://www.w3.org/2000/svg">
  <!-- Top Flap Left -->
  <path d="M 28 80 L 128 40 L 128 90 L 28 130 Z" fill="#e0c090" stroke="#604020" stroke-width="2"/>
  <!-- Top Flap Right -->
  <path d="M 228 80 L 128 40 L 128 90 L 228 130 Z" fill="#d0b080" stroke="#604020" stroke-width="2"/>
  
  <!-- Front Face Left -->
  <path d="M 28 130 L 128 170 L 128 240 L 28 200 Z" fill="#c0a070" stroke="#604020" stroke-width="2"/>
  <!-- Front Face Right -->
  <path d="M 228 130 L 128 170 L 128 240 L 228 200 Z" fill="#b09060" stroke="#604020" stroke-width="2"/>
  
  <!-- Top Open Flaps (visual effect of open box) -->
  <line x1="28" y1="80" x2="28" y2="130" stroke="#604020" stroke-width="2"/>
  <line x1="228" y1="80" x2="228" y2="130" stroke="#604020" stroke-width="2"/>
  <line x1="128" y1="170" x2="128" y2="240" stroke="#604020" stroke-width="2"/>
</svg>"""

script_dir = os.path.dirname(os.path.abspath(__file__))
assets_dir = os.path.join(script_dir, '..', 'assets')
output_path = os.path.join(assets_dir, 'icon.svg')

if not os.path.exists(assets_dir):
    os.makedirs(assets_dir)

with open(output_path, 'w') as f:
    f.write(svg_content)

print(f"Icon generated in {output_path}")
