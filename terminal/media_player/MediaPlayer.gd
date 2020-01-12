extends "res://terminal/Program.gd"

# Filename of the media to be played
var file_name

# Which player should we use (audio or video)
var player

# If the playback is paused
var paused = false

# --------------------------------------------------------------------------- #

func _set_paused(value):
	# Pause or unpause playback
	paused = value
	if player == $AudioPlayer:
		player.stream_paused = value
	else:
		player.paused = value

func _process(delta):
	if player == $AudioPlayer:
		# Set slider length as audio length
		$GUI/Main/Slider.max_value = player.stream.get_length()
	
		# Slider goes together with the audio ~
		if player.playing and not player.stream_paused:
			$GUI/Main/Slider.value = player.get_playback_position()
	
	# Check button presses
	if $GUI/Main/Buttons/Play.pressed:
		if not player.playing or paused:
			player.playing = true
			_set_paused(false)
			if player == $AudioPlayer:
				player.seek($GUI/Main/Slider.value)
	elif $GUI/Main/Buttons/Pause.pressed:
		_set_paused(true)
	elif $GUI/Main/Buttons/Stop.pressed:
		player.playing = false
		if player == $AudioPlayer:
			$GUI/Main/Slider.value = 0.0 if not $GUI/Extras/Reverse.pressed \
					else $GUI/Main/Slider.max_value
	
	# Volume and speed
	player.volume_db = $GUI/Volume.value
	if player == $AudioPlayer:
		player.pitch_scale = $GUI/Extras/Speed.value

func _on_Player_finished():
	# Return slider to initial position when audio playback's finished
	if player == $AudioPlayer:
		$GUI/Main/Slider.value = 0.0 if not $GUI/Extras/Reverse.pressed \
				else $GUI/Main/Slider.max_value

func _on_Reverse_toggled(button_pressed):
	if button_pressed:
		player.stream.loop_mode = AudioStreamSample.LOOP_BACKWARD
	else:
		player.stream.loop_mode = AudioStreamSample.LOOP_DISABLED
