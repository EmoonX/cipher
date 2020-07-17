extends CanvasLayer

# If the object is being hovered
var hovering

# Offset of initial mouse click
var click_offset

# --------------------------------------------------------------------------- #

func _on_Image_mouse_entered():
	hovering = true
	
func _on_Image_mouse_exited():
	hovering = false

func _input(event):
	if not hovering:
		return
	
	if event is InputEventMouseButton:
		# Get click offset
		click_offset = event.position - $Image.rect_position
		
		# Put currently dragged image above all others
		for canvas in $"..".get_children():
			canvas.layer = 1 if canvas.name == name else 0
	
	elif event is InputEventMouseMotion:
		if Input.is_mouse_button_pressed(BUTTON_LEFT):
			# Move object
			$Image.rect_position = event.position - click_offset
