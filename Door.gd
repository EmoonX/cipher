extends "res://Interactive.gd"

func _process(delta):
	if active and Input.is_action_just_pressed("action"):
		get_tree().root.get_node("Game").exit = true
