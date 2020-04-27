extends Spatial

export(AudioStream) var bgm

# --------------------------------------------------------------------------- #

func _ready():
	# Save game upon entering a new room
	Save.save_game()
	
	# Change BGM stream to the current room one, ONLY if necessary
	if bgm != $"/root/Game/BGM".stream:
		$"/root/Game/BGM".start_playing(bgm)
