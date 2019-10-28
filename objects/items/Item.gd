extends "res://objects/Interactable.gd"

onready var inventory = $"/root/Game/Inventory"

# Name and description to show in player's inventory
onready var pretty_name = name.to_upper() + "_NAME"
onready var description = name.to_upper() + "_DESCR"

# --------------------------------------------------------------------------- #

func _process(delta):
	if active and Input.is_action_just_pressed("action"):
		inventory.add(self)
		if "Key" in name:
			$"/root/Game".play_sfx("res://assets/key_pickup.wav")
	
	if inventory.was_picked_up(self):
		$"/root/Game".current.remove_child(self)
