extends Label

# Position on the grid
var i
var j

# --------------------------------------------------------------------------- #

func _ready():
	rect_size.x = 77

func _process(delta):
	if has_focus():
		for number in range(KEY_1, KEY_9 + 1):
			if Input.is_key_pressed(number):
				text = str(number - KEY_0)
				$"../..".grid[i][j] = text
				var color = ColorN("green" if $"../..".check(i, j) else "red")
				set("custom_colors/font_color", color)
			elif Input.is_key_pressed(KEY_DELETE) or \
					Input.is_key_pressed(KEY_BACKSPACE):
				text = " "
				$"../..".grid[i][j] = text
