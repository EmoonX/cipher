extends Button

onready var sprite = $"../../Image/Sprite"

# --------------------------------------------------------------------------- #

func _on_Button_button_up():
	var image = $"../../../".image
	
	# Check button presses
	if name == "FlipH":
		image.flip_x()
	elif name == "FlipV":
		image.flip_y()
	
	# Swap previous image with new (without having to reimport!)
	sprite.texture = ImageTexture.new()
	sprite.texture.image = image
