extends Node

var subtitles = []
var index = 0
var audio_id

# --------------------------------------------------------------------------- #

func display(speech_id : String):
	# Translate speech text from ID and split between lines
	subtitles = TranslationServer.translate(speech_id).split("\n")
	
	# Get speech audio ID
	audio_id = speech_id.replace("SPEECH_", "").to_lower()
	
	# Play first (or only) line
	_play_next_line()

func _play_next_line():
	# Get absolute path of next audio file
	var filename = audio_id + "_" + str(index + 1) + ".wav"
	var path = "res://audio/speech/en/" + filename
	
	# Play speech audio
	$AudioStreamPlayer.stream = load(path)
	$AudioStreamPlayer.playing = true
	
	# Show subtitle
	$Subtitle.text = subtitles[index]
