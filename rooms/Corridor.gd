extends "res://rooms/Room.gd"

# --------------------------------------------------------------------------- #

func _ready():
	if $"/root/Game".check_and_flag("SPEECH_START"):
		$"/root/Game".display_subtitles("SPEECH_START")
