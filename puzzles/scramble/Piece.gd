extends TextureRect

# Position of piece
var i
var j

# Rotation angle (continuous valued) of piece
onready var rotation = rect_rotation

# Last mouse position
var last_pos

# --------------------------------------------------------------------------- #

func _input(event):
	if event is InputEventMouseButton:
		last_pos = event.position
	elif event is InputEventMouseMotion and \
			has_focus() and Input.is_mouse_button_pressed(BUTTON_LEFT):
		var delta = event.position - last_pos
		last_pos = event.position
		rotation = fmod(rotation + 0.5 * delta.x, 360)
		self.rect_rotation = round(round(rotation / 360 * 16) * 360/16)
		self.rect_rotation = int(self.rect_rotation) % 360
