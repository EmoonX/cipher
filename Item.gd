extends "res://Interactable.gd"

func _process(delta):
	if active and Input.is_action_just_pressed("action"):
		var player = $"/root/Game/Player"
		player.inventory.append(name)
		queue_free()
