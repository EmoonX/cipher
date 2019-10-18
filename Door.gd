extends "res://Interactable.gd"

onready var game = $"/root/Game/"
onready var player = game.get_node("Player")

export(String) var where_to
export(Vector3) var coords
export(float) var angle
export(String) var key = ""

var exit = false

func _process(delta):
	if exit and game.cont == 0:
		if not where_to:
			get_tree().quit()
			return
		
		# Change current room
		game.remove_child(game.current)
		game.current = load("res://" + where_to + ".tscn").instance()
		game.add_child(game.current)
		
		# Position the player accordingly
		player = game.get_node("Player")
		player.translation = coords
		player.rotation_degrees.y = angle
		
		game.cont = -60
		game.play_sfx("res://assets/close_door_1.wav")
		
	elif active and Input.is_action_just_pressed("action"):
		if not key or key in player.inventory:
			exit = true
			game.cont = 60
			game.play_sfx("res://assets/open_door_1.wav")
		else:
			game.play_sfx("res://assets/locked-door.wav")
