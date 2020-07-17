extends "res://puzzles/Draggable.gd"

# --------------------------------------------------------------------------- #

func _input(event):
	if not hovering:
		return
	
	if event is InputEventMouseMotion:
		if Input.is_mouse_button_pressed(BUTTON_LEFT):
			# Check if image is in near slot
			var dx = $Image.rect_position.x - $"../Slot".rect_position.x;
			var dy = $Image.rect_position.y - $"../Slot".rect_position.y;
			if abs(dx) < 50 and abs(dy) < 50:
				# Add transparency
				$Image.modulate.a = 0.5;
			else:
				# Remove transparency
				$Image.modulate.a = 1.0;
