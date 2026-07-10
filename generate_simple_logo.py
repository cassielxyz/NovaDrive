from PIL import Image

# Create a 1x1 transparent image
img = Image.new('RGBA', (1, 1), (0, 0, 0, 0))
img.save('transparent.png')

# Create a simple vector-style logo using Pillow for the actual logo
img2 = Image.new('RGBA', (512, 512), (0, 0, 0, 0))
from PIL import ImageDraw
draw = ImageDraw.Draw(img2)
# Orbit Arc
draw.arc([76, 76, 436, 436], start=0, end=360, fill=(201, 191, 255, 30), width=6)
# Core rounded rect
draw.rounded_rectangle([106, 106, 406, 406], radius=60, fill=(201, 191, 255, 255))
# Inner white square
draw.rounded_rectangle([216, 216, 296, 296], radius=24, fill=(255, 255, 255, 230))
img2.save('assets/images/logo.png')
print("Generated transparent.png and assets/images/logo.png")
