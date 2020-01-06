extends "res://terminal/Program.gd"

# --------------------------------------------------------------------------- #

func _process(delta):
	# Set slider length as audio length
	$GUI/Main/Slider.max_value = $Player.stream.get_length()
	
	# Slider goes together with the music ~
	if $Player.playing and not $Player.stream_paused:
		$GUI/Main/Slider.value = $Player.get_playback_position()
	
	# Check button presses
	if $GUI/Main/Buttons/Play.pressed:
		if not $Player.playing or $Player.stream_paused:
			$Player.playing = true
			$Player.stream_paused = false
			$Player.seek($GUI/Main/Slider.value)
	elif $GUI/Main/Buttons/Pause.pressed:
		$Player.stream_paused = true
	elif $GUI/Main/Buttons/Stop.pressed:
		$Player.playing = false
		$GUI/Main/Slider.value = 0.0
	
	# Volume
	$Player.volume_db = $GUI/Volume.value
