extends Node

const BASE = "res://etc/base.cfg"
#const FILE = "user://player.cfg"
const FILE = "res://player.cfg"

onready var file = ConfigFile.new()

# --------------------------------------------------------------------------- #

func set_options():
	# Screen mode
	match file.get_value("base", "screen_mode"):
		"Window":
			OS.window_fullscreen = false
			OS.window_borderless = false
		"Borderless Window":
			OS.window_fullscreen = false
			OS.window_borderless = true
		"Fullscreen":
			OS.window_fullscreen = true
	
	# Screen resolution
	var res = file.get_value("base", "resolution")
	if res == "Screen Adapt":
		OS.window_size = OS.get_screen_size()
	else:
		var aux = res.split("x")
		OS.window_size = Vector2(int(aux[0]), int(aux[1]))
