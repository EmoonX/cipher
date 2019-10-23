extends "res://Interactable.gd"

onready var game = $"/root/Game/"
onready var player = game.get_node("Player")

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
		player.rotation_degrees = door.rotation_degrees
		player.translation = door.translation
		match int(door.rotation_degrees.y):
			0:
				player.translation.z += 5
			90:
				player.translation.x += 5
			180, -180:
				player.translation.z += 5
			270, -90:
				player.translation.x -= 5
		
		game.cont = -60
		game.play_sfx("res://assets/close_door_1.wav")
		
	elif active and Input.is_action_just_pressed("action"):
		if not key or key in player.inventory:
			exit = true
			game.cont = 60
			game.play_sfx("res://assets/open_door_1.wav")
		else:
			game.play_sfx("res://assets/locked-door.wav")
			if name == "LockedDoor":
				game.display_subtitles("first_locked")
