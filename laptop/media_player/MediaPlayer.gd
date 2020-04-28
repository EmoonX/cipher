extends "res://laptop/Program.gd"

# Filename of the media to be played
var file_name

# Which player should we use (audio or video)
var player

# If the playback is paused
var paused = false

# --------------------------------------------------------------------------- #

func _ready():
	if file_name.split(".")[-1] != "webm":
		player = $AudioPlayer
	else:
		player = $GUI/Main/VideoPlayer
		
		# Disable options that don't work with videos
		$GUI/Main/Slider.visible = false
		$GUI/Extras/Reverse.disabled = true
		$GUI/Extras/Speed.editable = false
	
	player.stream = load(file_name)

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
		if not player.is_playing() or paused:
			if player == $AudioPlayer:
				player.playing = true
				player.seek($GUI/Main/Slider.value)
			else:
				if not paused:
					player.play()
			_set_paused(false)
	elif $GUI/Main/Buttons/Pause.pressed:
		_set_paused(true)
	elif $GUI/Main/Buttons/Stop.pressed:
		player.stop()
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
