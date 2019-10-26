extends Node

const BASE = "res://etc/base.cfg"
#const FILE = "user://player.cfg"
const FILE = "res://player.cfg"

onready var file = ConfigFile.new()

# Dictionary {Name -> Language Code}
var langs = { \
	"English": "en",
	"Português (Brasil)": "pt_BR"
}

# --------------------------------------------------------------------------- #

func set_options():
	# Language
	var lang_code = langs[file.get_value("base", "opt_lang")]
	TranslationServer.set_locale(lang_code)
	
	# Screen mode
	match file.get_value("base", "opt_scrmod"):
		"SCRMOD_WIN":
			OS.window_fullscreen = false
			OS.window_borderless = false
		"SCRMOD_BLWIN":
			OS.window_fullscreen = false
			OS.window_borderless = true
		"SCRMOD_FULL":
			OS.window_fullscreen = true
	
	# Screen resolution
	var res = file.get_value("base", "opt_res")
	if res == "RES_SCR_ADAPT":
		OS.window_size = OS.get_screen_size()
	else:
		var aux = res.split("x")
		OS.window_size = Vector2(int(aux[0]), int(aux[1]))
