from PIL import Image
import math

def color_distance(c1, c2):
    return math.sqrt((c1[0] - c2[0])**2 + (c1[1] - c2[1])**2 + (c1[2] - c2[2])**2)

img = Image.open('assets/images/logo.png').convert('RGBA')
data = img.getdata()

bg_color = (19, 19, 20) # #131314
threshold = 30 # Distance within which pixels become fully transparent
fade_range = 30 # Additional distance for fading alpha

new_data = []
for item in data:
    # Ignore existing transparency
    if item[3] == 0:
        new_data.append(item)
        continue
        
    dist = color_distance(item[:3], bg_color)
    
    if dist < threshold:
        # Fully transparent
        new_data.append((item[0], item[1], item[2], 0))
    elif dist < threshold + fade_range:
        # Fade alpha
        alpha_ratio = (dist - threshold) / fade_range
        new_alpha = int(255 * alpha_ratio)
        new_data.append((item[0], item[1], item[2], new_alpha))
    else:
        new_data.append(item)

img.putdata(new_data)
img.save('assets/images/logo.png')
print("Background removed from logo.png")
