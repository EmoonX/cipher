extends Node

const SAVE_FILE = "res://user/emoon.save"

# --------------------------------------------------------------------------- #

func create_save():
	# Make a empty save file with the initial persistent game state
	var initial_state = {
		"room": "Corridor",
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
					var path = "res://rooms/" + line[attr] + ".tscn"
					var current = load(path).instance()
					$"/root/Game".current = current
					$"/root/Game".add_child(current)
				"flags":
					for flag in line[attr]:
						$"/root/Game".flags.append(flag)
					
				"player_translation":
					$"/root/Game/Player".translation = str2var(line[attr])
				"player_rotation":
					$"/root/Game/Player".rotation = str2var(line[attr])
				
				"picked_items":
					var items = []
					for item_name in str2var(line[attr]):
						items.append(item_name)
					$"/root/Game/Interfaces/Inventory".picked_items = items
				"inventory":
					var items = []
					for item_name in str2var(line[attr]):
						var path = "res://objects/items/" + item_name + ".tscn"
						var item = load(path).instance()
						add_child(item)
						items.append(item)
						remove_child(item)
						# (adding and removing from tree is a quick fix so
						# the item's _ready method actually gets called...)
					$"/root/Game/Interfaces/Inventory".inventory = items
	file.close()
