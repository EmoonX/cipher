extends "res://Interactable.gd"

onready var game = $"/root/Game"

func _process(delta):
	if active and Input.is_action_just_pressed("action"):
		game.get_node("Player").inventory.append(name)
		game.picked_up.append(name)
		if "Key" in name:
			game.play_sfx("res://assets/key_pickup.wav")
	
	if name in game.picked_up:
		queue_free()
