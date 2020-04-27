extends Node

const SAVE_FILE = "res://user/emoon.save"

# --------------------------------------------------------------------------- #

func create_save():
	# Make a empty save file with the initial persistent game state
	var initial_state = {
		"room": "Corridor",
		"player_translation": var2str(Vector3(30, 0, 0)),
		"player_rotation": var2str(Vector3(0, -90, 0))
	}
	var file = File.new()
	file.open(SAVE_FILE, File.WRITE)
	file.store_line(to_json(initial_state))
	file.close()

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
		for attr in line:
			match attr:
				"room":
					var current = load("res://rooms/" + \
							line[attr] + ".tscn").instance()
					$"/root/Game".current = current
					$"/root/Game".add_child(current)
					
				"player_translation":
					$"/root/Game/Player".translation = str2var(line[attr])
				"player_rotation":
					$"/root/Game/Player".rotation = str2var(line[attr])
	file.close()
