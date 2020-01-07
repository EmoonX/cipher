extends Button

# --------------------------------------------------------------------------- #

func _on_Key_button_down():
	# Play sound file corresponding to note
	var filename = "res://puzzles/piano/" + name.to_lower() + ".wav"
	var player = AudioStreamPlayer.new()
	player.stream = load(filename)
	player.playing = true
	add_child(player)

func _process(delta):
	# Free player after playing note
	if get_children() and not get_child(0).playing:
		get_child(0).queue_free()
