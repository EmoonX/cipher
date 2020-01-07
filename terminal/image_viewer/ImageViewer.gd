extends "res://terminal/Program.gd"

onready var sprite = $GUI/Image/Sprite
onready var threshold = $GUI/Controls/Threshold

var image : Image
var pixels = []
var last_ts = -1

# --------------------------------------------------------------------------- #

func _process(delta):
	if last_ts == -1:
		# Load original pixels in matrix to keep base image state
		last_ts = 0
		image = sprite.texture.get_data()
		image.lock()
		for y in image.get_height():
			pixels.append([])
			for x in image.get_width():
				var color = image.get_pixel(x, y)
				pixels[y].append(color)
	
	elif threshold.value != last_ts:
		# Apply threshold based on average pixel intensity
		last_ts = threshold.value
		for y in image.get_height():
			for x in image.get_width():
				var color = pixels[y][x]
				var avg = color.get_v() * 256
				if avg < $GUI/Controls/Threshold.value:
					color = Color(0, 0, 0)
				else:
					color = Color(1, 1, 1)
				image.set_pixel(x, y, color)
		
		# Swap previous image with new (without having to reimport!)
		sprite.texture = ImageTexture.new()
		sprite.texture.image = image
