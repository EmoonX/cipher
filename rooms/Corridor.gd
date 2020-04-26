extends Spatial

var ok = false

# --------------------------------------------------------------------------- #

func _process(delta):
	if not ok:
		$"/root/Game".display_subtitles("SPEECH_START")
		ok = true
