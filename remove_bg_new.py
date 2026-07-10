from rembg import remove
from PIL import Image

input_path = r'C:\Users\jesow\.gemini\antigravity-ide\brain\c7ea0cc3-db7a-4ac2-b14c-d52e225aedc6\nova_logo_final_1783707030029.png'
output_path = r'assets/logo.png'

print("Loading image...")
input_image = Image.open(input_path)

print("Removing background with rembg...")
output_image = remove(input_image)

print("Saving to logo.png...")
output_image.save(output_path)
print("Done!")
