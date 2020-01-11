extends "res://terminal/Program.gd"

onready var sprite = $GUI/Image
onready var threshold = $GUI/Controls/Threshold

var image : Image
var pixels = []
var last_ts = -1

var picker = false

# --------------------------------------------------------------------------- #

func _ready():
	image = sprite.texture.get_data()
	image.lock()

func _process(delta):
	if last_ts == -1:
		# Load original pixels in matrix to keep base image state
		last_ts = 0
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

func _input(event):
	if event is InputEventMouseButton and event.is_pressed() and picker:
		image.lock()
		var dx = ($GUI/Image.rect_size.x - image.get_width()) / 2
		var dy = ($GUI/Image.rect_size.y - image.get_height()) / 2
		var pos = event.position - rect_position - Vector2(dx, dy)
		var color = image.get_pixelv(pos)
		$GUI/Controls/Color.color = color
