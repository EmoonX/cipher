extends Node

const FILE = "res://user/emoon.save"

var room = "Corridor"

# --------------------------------------------------------------------------- #

func save_game():
	# Open and write save file, recording current game state
	var file = File.new()
	file.open(FILE, File.WRITE)
	var save_nodes = get_tree().get_nodes_in_group("persist")
	for node in save_nodes:
		var data = node.save()
		file.store_line(to_json(data))
	file.close()

func load_game():
	# Load persistent info from saved game file
	var file = File.new()
	file.open(FILE, File.READ)
	var line = parse_json(file.get_line())
	room = line["room"]
	
	# Continue game
	get_tree().change_scene("res://Game.tscn")
