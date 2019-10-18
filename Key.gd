extends "res://Interactable.gd"

func _process(delta):
	if active and Input.is_action_just_pressed("action"):
		var player = get_tree().root.get_node("Game/Player")
		player.inventory.append("Key")
		queue_free()

