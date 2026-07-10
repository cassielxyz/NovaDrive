from PIL import Image

input_path = 'assets/logo.png'
output_path = 'assets/logo.png'

print("Loading image...")
img = Image.open(input_path).convert("RGBA")

# Resize image to 95% of the canvas size
canvas_size = 1024
new_size = int(canvas_size * 0.95) # 95% to make it large
img_resized = img.resize((new_size, new_size), Image.Resampling.LANCZOS)

# Create a transparent canvas
canvas = Image.new("RGBA", (canvas_size, canvas_size), (0, 0, 0, 0))

# Paste the resized image onto the center of the canvas
offset = ((canvas_size - new_size) // 2, (canvas_size - new_size) // 2)
canvas.paste(img_resized, offset, img_resized)

print("Saving padded image...")
canvas.save(output_path)
print("Done!")
