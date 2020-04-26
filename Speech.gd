extends Node

var speech = []
var index = 0
var audio_id

# --------------------------------------------------------------------------- #

func display(speech_id : String):
	# Translate speech text from ID and split between lines
	speech = TranslationServer.translate(speech_id).split("\n")
	
	# Get speech audio ID
	audio_id = speech_id.replace("SPEECH_", "").to_lower()
	
	# Play first (or only) line
	_play_next_line()

func _play_next_line():
	# Get absolute path of next audio file
	var filename = audio_id + "_" + str(index + 1) + ".wav"
	var lang = Config.langs[Config.file.get_value("base", "opt_lang")]
	var path = "res://audio/speech/" + lang + "/" + filename
	
	# Play speech audio
	$Audio.stream = load(path)
	$Audio.playing = true
	
	# Reduce BGM volume so speech can be heard better
	$"/root/Game".current.get_node("BGM").volume_db = -10.0
	
	# Show subtitle
	$Subtitle.text = speech[index]

func _on_AudioStreamPlayer_finished():
	# When line is finished spoken, either play next one (if any)
	# or just blank subtitles and return BGM volume to normal.
	if index < len(speech) - 1:
		index += 1
		_play_next_line()
	else:
		index = 0
		$Subtitle.text = ""
		$"/root/Game".current.get_node("BGM").volume_db = 0.0
