extends "res://objects/Interactable.gd"

onready var game = $"/root/Game/"
onready var player = game.get_node("Player")
onready var inventory = game.get_node("CanvasLayer/Inventory")

export(String) var where_to
export(String) var key = ""

var exit = false

# --------------------------------------------------------------------------- #

func _process(delta):
	if exit and game.cont == 0:
		if not where_to:
			get_tree().quit()
			return
			
		var door_name = name
		
		# Change current room
		game.remove_child(game.current)
		game.current = load("res://rooms/" + where_to + ".tscn").instance()
		game.add_child(game.current)
		
		# Position the player accordingly
		var door = game.current.get_node(door_name)
		player = game.get_node("Player")
		player.rotation_degrees.y = door.rotation_degrees.y
		player.translation = door.translation
		
		match round(door.rotation_degrees.y):
			0.0:
				player.translation.z += 5
			90.0:
				player.translation.x += 5
			180.0, -180.0:
				player.translation.z -= 5
			270.0, -90.0:
				player.translation.x -= 5
		
		game.cont = -60
		game.play_sfx("res://assets/close_door_1.wav")
		
	elif active and Input.is_action_just_pressed("action"):
		if not key or key in inventory.items:
			if key in inventory.items:
				inventory.remove(key)
			
			exit = true
			game.cont = 60
			game.play_sfx("res://assets/open_door_1.wav")
		else:
			game.play_sfx("res://assets/locked-door.wav")
