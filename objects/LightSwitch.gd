extends "res://objects/Interactable.gd"

# If lights are turned on
var turned_on = false

# --------------------------------------------------------------------------- #

func _process(delta):
	$ActionLabel.text = \
			"ACTION_TURNON" if not turned_on else "ACTION_TURNON"
	
	if active and Input.is_action_just_pressed("action"):
		turned_on = not turned_on
		for node in $"../Lamps".get_children():
			if node is OmniLight:
				node.visible = not node.visible
