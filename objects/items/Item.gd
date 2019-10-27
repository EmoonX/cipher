extends "res://objects/Interactable.gd"

onready var inventory = $"/root/Game/Inventory"

# --------------------------------------------------------------------------- #

func _process(delta):
	if active and Input.is_action_just_pressed("action"):
		inventory.add(name)
		if "Key" in name:
			$"/root/Game".play_sfx("res://assets/key_pickup.wav")
	
	if name in inventory.items or name in inventory.used:
		queue_free()
