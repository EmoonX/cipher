extends Label

const box = preload("res://puzzles/sudoku/Box.tres")

# Position on the grid
var i
var j

# --------------------------------------------------------------------------- #

func _ready():
	rect_size.x = 77

func _process(delta):
	if has_focus():
		set("custom_styles/normal", box)
		
		for key in range(KEY_1, KEY_9 + 1):
			# Ckeck number presses
			if Input.is_key_pressed(key):
				var number = key - KEY_0
				$"../..".mark_number(i, j, number)
			
			# Check also for delete/backspace presses
			elif Input.is_key_pressed(KEY_DELETE) or \
					Input.is_key_pressed(KEY_BACKSPACE):
				text = " "
				$"../..".grid[i][j] = text

	else:
		set("custom_styles/normal", StyleBoxEmpty.new())
