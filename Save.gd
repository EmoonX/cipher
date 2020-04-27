extends Node

# --------------------------------------------------------------------------- #

func save_game(room):
	# Dict containing persistent save info
	var save_dict = {
		"room": room
	}
	
	# Open and write save file, recording current game state
	var file = File.new()
	file.open("res://user/emoon.save", File.WRITE)
	file.store_line(to_json(save_dict))
	file.close()
