extends TextureRect

# Position of piece
var i
var j

# Rotation angle (continuous valued) of piece
onready var rotation = rect_rotation

# Last mouse position and click offset
var last_pos
var offset

# --------------------------------------------------------------------------- #

func _input(event):
	if event is InputEventMouseButton:
		# Get initial position and offset
		last_pos = event.position
		offset = event.position - (rect_position + get_parent().rect_position)
	
	elif event is InputEventMouseMotion and has_focus():
		if Input.is_mouse_button_pressed(BUTTON_LEFT):
			# Move piece
			rect_position = \
					event.position - get_parent().rect_position - offset
			
			# Snap into grid, if applicable
			if rect_position.x >= 0 and \
					rect_position.x < get_parent().rect_size.x and \
					rect_position.y >= 0 and \
					rect_position.y < get_parent().rect_size.y:
				rect_position.x = round(rect_position.x / \
						get_parent().rect_size.x * $"../..".width) * \
						(get_parent().rect_size.x / $"../..".width)
				rect_position.y = round(rect_position.y / \
						get_parent().rect_size.y * $"../..".height) * \
						(get_parent().rect_size.y / $"../..".height)
		
		elif Input.is_mouse_button_pressed(BUTTON_RIGHT):
			# Rotate piece
			var delta = event.position - last_pos
			last_pos = event.position
			rotation = fmod(rotation + 0.5 * delta.x, 360)
			rect_rotation = round(round(rotation / 360 * 16) * 360/16)
			rect_rotation = int(rect_rotation) % 360
