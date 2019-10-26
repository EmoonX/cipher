extends Spatial

func _ready():
	var text = \
			"I find myself once again stuck at the same dark corridor...\n" + \
			"Gotta find my way out."
	$"/root/Game".display_subtitles(text)
