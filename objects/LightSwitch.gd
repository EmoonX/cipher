extends "res://objects/Interactable.gd"

# --------------------------------------------------------------------------- #

func _process(delta):
	$ActionLabel.text = "Turn " + ("off" if get_parent().lights_on else "on")
	
	if active and Input.is_action_just_pressed("action"):
		get_parent().lights_on = not get_parent().lights_on
		for node in get_parent().get_children():
			if "Lamp" in node.name:
				node.visible = get_parent().lights_on
