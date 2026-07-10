from rembg import remove
from PIL import Image

input_path = r'C:\Users\jesow\.gemini\antigravity-ide\brain\3e5a250c-4ae2-469c-9cc5-58d112538e71\cloud_icon_notext_2_1781488142876.png'
output_path = r'assets/images/logo.png'

print("Loading image...")
input_image = Image.open(input_path)

print("Removing background with rembg...")
output_image = remove(input_image)

print("Saving to logo.png...")
output_image.save(output_path)
print("Done!")
