extends Button

onready var note = name.to_lower()

# --------------------------------------------------------------------------- #

func _on_Key_button_down():
	# Play sound file corresponding to note
	var filename = "res://puzzles/piano/" + note + ".wav"
	var player = AudioStreamPlayer.new()
	player.stream = load(filename)
	player.playing = true
	add_child(player)
	
	# Save as last note played
	$"..".add(note)

func _process(delta):
	# Free player after playing note
	if get_children() and not get_child(0).playing:
		get_child(0).queue_free()
