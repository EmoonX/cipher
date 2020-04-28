extends Spatial

# Background music
export(AudioStream) var bgm

# If room has already been visited
var visited = false

# --------------------------------------------------------------------------- #

func _ready():
	# Wait a bit so we can actually save the initial player's position
	yield(get_tree(), "idle_frame")
	
	# Save game upon entering a new room
	Save.save_game()
	
	# Change BGM stream to the current room one, ONLY if necessary
	if bgm != $"/root/Game/BGM".stream:
		$"/root/Game/BGM".start_playing(bgm)
		
	# In case of first visit, register room on map
	if not visited:
		$"/root/Game/Interfaces/Laptop/Map".register_room(self)
		visited = true
