extends Node

const FILE = "res://user/emoon.save"

var room = "Corridor"

# --------------------------------------------------------------------------- #

func save_game(room):
	# Dict containing persistent save info
	var save_dict = {
		"room": room
	}
	
	# Open and write save file, recording current game state
	var file = File.new()
	file.open(FILE, File.WRITE)
	file.store_line(to_json(save_dict))
	file.close()

func load_game():
	# Load persistent info from saved game file
	var file = File.new()
	file.open(FILE, File.READ)
	var line = parse_json(file.get_line())
	room = line["room"]
	
	# Continue game
	get_tree().change_scene("res://Game.tscn")
