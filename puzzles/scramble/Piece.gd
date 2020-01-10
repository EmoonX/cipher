extends TextureRect

# Current and needed position of piece
var i = -1
var j = -1
var i_goal
var j_goal

# Continously valued rotation angle of piece
onready var rotation = rect_rotation

# If mouse is hovering piece
var hover = false

# Last mouse position and click offset
var last_pos
var offset

# --------------------------------------------------------------------------- #

func _on_Piece_mouse_entered():
	hover = true
	
func _on_Piece_mouse_exited():
	hover = false

func _input(event):
	if event is InputEventMouseButton:
		# Get initial position and offset
		last_pos = event.position
		offset = event.position - rect_position
	
	elif event is InputEventMouseMotion and hover:
		if Input.is_mouse_button_pressed(BUTTON_LEFT):
			# Move piece
			rect_position = event.position - offset
			
			# Snap into grid, if applicable
			var pos = rect_position - $"../Grid".rect_position
			if pos.x >= -100 and pos.x < $"../Grid".rect_size.x and \
					pos.y >= -100 and pos.y < $"../Grid".rect_size.y:
				j = abs(round(pos.x / $"../Grid".rect_size.x * $"..".width))
				i = abs(round(pos.y / $"../Grid".rect_size.y * $"..".height))
				pos.x = j * ($"../Grid".rect_size.x / $"..".width)
				pos.y = i * ($"../Grid".rect_size.y / $"..".height)
				rect_position = pos + $"../Grid".rect_position
		
		elif Input.is_mouse_button_pressed(BUTTON_RIGHT):
			# Rotate piece
			var delta = event.position - last_pos
			last_pos = event.position
			rotation = fmod(rotation + 0.5 * delta.x, 360)
			rect_rotation = round(round(rotation / 360 * 16) * 360/16)
			rect_rotation = int(rect_rotation) % 360
