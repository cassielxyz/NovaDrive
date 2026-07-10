from PIL import Image

path = r'assets/images/logo.png'
img = Image.open(path)
bbox = img.getbbox()
if bbox:
    # Adding a small padding (e.g., 20 pixels) so it isn't completely touching the edge
    padding = 40
    new_bbox = (
        max(0, bbox[0] - padding),
        max(0, bbox[1] - padding),
        min(img.width, bbox[2] + padding),
        min(img.height, bbox[3] + padding)
    )
    cropped = img.crop(new_bbox)
    cropped.save(path)
    print(f"Cropped image from {img.size} to {cropped.size}")
else:
    print("Image is entirely transparent, nothing to crop.")
