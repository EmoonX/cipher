extends "res://objects/Interactable.gd"

# --------------------------------------------------------------------------- #

func _process(delta):
	$ActionLabel.text = \
			"ACTION_TURNOFF" if $"../Lamps".visible else "ACTION_TURNON"
	if active and Input.is_action_just_pressed("action"):
		$"../Lamps".visible = not $"../Lamps".visible
