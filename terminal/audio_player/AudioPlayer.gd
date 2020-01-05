extends "res://terminal/Program.gd"
# --------------------------------------------------------------------------- #

func _process(delta):
	# Check button presses
	if $GUI/Main/Buttons/Play.pressed:
		if not $Player.playing:
			$Player.playing = true
		$Player.stream_paused = false
	elif $GUI/Main/Buttons/Pause.pressed:
		$Player.stream_paused = true
	elif $GUI/Main/Buttons/Stop.pressed:
		$Player.playing = false
