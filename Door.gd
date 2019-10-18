extends "res://Interactable.gd"

onready var game = get_tree().root.get_node("Game")

export(String) var where_to
export(Vector3) var coords
export(float) var angle

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
		var player = game.get_node("Player")
		player.translation = coords
		player.rotation_degrees.y = angle
		
		exit = false
		game.cont = -60
		
	elif active and Input.is_action_just_pressed("action"):
		exit = true
		game.cont = 60
