extends "res://laptop/Program.gd"

# Radius (+1) of drawn dots
const DOT_SIZE = 5

onready var sprite = $GUI/Image
onready var threshold = $GUI/Controls/Threshold

# Current and original images
var image : Image
var original_image

var pixels = []
var last_ts = -1
var last_pos

# If respective tool is currently chosen
var line = false
var fill = false
var picker = false

# --------------------------------------------------------------------------- #

func _ready():
	image = sprite.texture.get_data()
	image.lock()
	original_image = image.duplicate()

func _draw_dot(pos):
	# Draw circular dot (with radius DOT_SIZE - 1) centered at pos
	var color = $GUI/Controls/Color.color
	var x = int(round(pos.x))
	var y = int(round(pos.y))
	var k = DOT_SIZE - 1
	for xx in range(x - k, x + k + 1):
		for yy in range(y - k, y + k + 1):
			var d = sqrt(pow(xx - x, 2) + pow(yy - y, 2))
			if d <= k:
				image.set_pixel(xx, yy, color)

func _draw_line(last_pos, pos):
	# Draw a straight line from last_pos to pos
	var v = pos - last_pos
	var norm = sqrt(pow(v.x, 2) + pow(v.y, 2))
	var vn = v / norm
	for k in range(ceil(norm)):
		var p = last_pos + k * vn
		_draw_dot(p)

func _fill(pos_ini):
	# Fill all neighbour same color pixels with new color
	var color_ini = image.get_pixelv(pos_ini)
	var color_new = $GUI/Controls/Color.color
	var stack = [pos_ini]
	while stack:
		var pos = stack.pop_back()
		if not image.get_used_rect().has_point(pos):
			continue
		var color = image.get_pixelv(pos)
		if color != color_ini:
			continue
		image.set_pixelv(pos, color_new)
		var positions = [
			Vector2(pos.x - 1, pos.y), Vector2(pos.x + 1, pos.y),
			Vector2(pos.x, pos.y - 1), Vector2(pos.x, pos.y + 1)
		]
		for pos_new in positions:
			stack.push_back(pos_new)

func _input(event):
	if event is InputEventMouseButton and event.is_pressed():
		image.lock()
		var dx = ($GUI/Image.rect_size.x - image.get_width()) / 2
		var dy = ($GUI/Image.rect_size.y - image.get_height()) / 2
		var pos = event.position - rect_position - Vector2(dx, dy)
		pos = Vector2(int(pos.x), int(pos.y))
		
		if line:
			if not last_pos:
				_draw_dot(pos)
				last_pos = pos
			else:
				_draw_line(last_pos, pos)
				last_pos = null
		elif fill:
			_fill(pos)
		elif picker:
			var color = image.get_pixelv(pos)
			$GUI/Controls/Color.color = color

func _process(delta):
	if last_ts == -1:
		# Load original pixels in matrix to keep base image state
		last_ts = 0
		for y in image.get_height():
			pixels.append([])
			for x in image.get_width():
				var color = image.get_pixel(x, y)
				pixels[y].append(color)
	
	# TODO: Use a signal
	elif threshold.value != last_ts:
		# Apply threshold based on average pixel intensity
		last_ts = threshold.value
		for y in image.get_height():
			for x in image.get_width():
				var color = pixels[y][x]
				var avg = color.get_v() * 256
				if avg < $GUI/Controls/Threshold.value:
					color = ColorN("black")
				else:
					color = ColorN("white")
				image.set_pixel(x, y, color)
		
	# Swap previous image with new (without having to reimport!)
	sprite.texture = ImageTexture.new()
	sprite.texture.image = image
