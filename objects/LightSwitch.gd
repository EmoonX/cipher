extends "res://objects/Interactable.gd"

# --------------------------------------------------------------------------- #

func _process(delta):
	$ActionLabel.text = "Turn " + ("off" if $"../Lamps".visible else "on")
	if active and Input.is_action_just_pressed("action"):
		$"../Lamps".visible = not $"../Lamps".visible
