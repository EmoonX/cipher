extends CanvasLayer

# If the object is being hovered
var hovering

# Offset of initial mouse click
var click_offset

# Number of canvas layers
var num_canvas = 0

# --------------------------------------------------------------------------- #

func _ready():
	for canvas in $"..".get_children():
		if canvas is CanvasLayer:
			num_canvas += 1

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
		
		# Position currently dragged image above all others.
		# Also keep original relative ordering
		for canvas in $"..".get_children():
			if canvas is CanvasLayer and canvas.layer > layer:
				canvas.layer -= 1
		layer = num_canvas
	
	elif event is InputEventMouseMotion:
		if Input.is_mouse_button_pressed(BUTTON_LEFT):
			# Move object
			$Image.rect_position = event.position - click_offset
