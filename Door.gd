extends "res://Interactive.gd"

onready var game = get_tree().root.get_node("Game")

export(String) var where_to
export(Vector3) var coords
export(float) var angle

var exit = false
var cont2 = 0

func _process(delta):
	if exit:
		if cont2 < 60:
			game.get_node("Fade").color.a = cont2/60.0
			cont2 += 1
		else:
			# Change current room
			game.remove_child(game.current)
			game.current = load("res://" + where_to + ".tscn").instance()
			game.add_child(game.current)
			
			# Position the player accordingly
			var player = game.current.get_node("Player")
			player.translation = coords
			player.rotation_degrees.y = angle
			
			game.get_node("Fade").color.a = 0
			exit = false
			cont2 = 0
		
	elif active and Input.is_action_just_pressed("action"):
		exit = true
