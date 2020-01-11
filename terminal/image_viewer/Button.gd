extends Button

const picker = preload("res://terminal/image_viewer/color_picker.png")

onready var sprite = $"../../Image"

# --------------------------------------------------------------------------- #

func _on_Button_button_up():
	var image = $"../../../".image
	
	# Check button presses
	if name == "FlipH":
		image.flip_x()
	elif name == "FlipV":
		image.flip_y()
	elif name == "ColorPicker":
		if not $"../../..".picker:
			Input.set_custom_mouse_cursor(picker, 0, Vector2(0, 32))
		else:
			Input.set_custom_mouse_cursor(View.default_cursor)
		$"../../..".picker = not $"../../..".picker
	
	# Swap previous image with new (without having to reimport!)
	sprite.texture = ImageTexture.new()
	sprite.texture.image = image
