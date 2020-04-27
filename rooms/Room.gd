extends Spatial

export(AudioStream) var bgm

# --------------------------------------------------------------------------- #

func _ready():
	# Save game upon entering a new room
	var room = name
	Save.save_game(room)
	
	# Change BGM stream to the current room one, ONLY if necessary
	if bgm != $"/root/Game/BGM".stream:
		$"/root/Game/BGM".start_playing(bgm)
