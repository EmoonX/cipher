extends Node

const SAVE_FILE = "res://user/emoon.save"

# --------------------------------------------------------------------------- #

func create_save():
	# Make a empty save file, which is simply a copy of the base save file
	var dir = Directory.new()
	dir.copy("res://etc/new.save", SAVE_FILE)

func save_game():
	# Open and write save file, recording current game state
	var file = File.new()
	file.open(SAVE_FILE, File.WRITE)
	var save_nodes = get_tree().get_nodes_in_group("persist")
	for node in save_nodes:
		var data = node.save()
		file.store_line(to_json(data))
	file.close()

func load_game():
	# Load persistent info from saved game file
	var file = File.new()
	file.open(SAVE_FILE, File.READ)
	while true:
		var line = parse_json(file.get_line())
		if not line:
			break
		print(line)
		match line.keys()[0]:
			"room":
				var current = load("res://rooms/" + \
						line[line.keys()[0]] + ".tscn").instance()
				$"/root/Game".current = current
				$"/root/Game".add_child(current)
	file.close()
