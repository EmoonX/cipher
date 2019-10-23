extends Node

onready var current = $Corridor
var cont = -60

# List of picked up (used or not) items
var picked_up = []

# --------------------------------------------------------------------------- #

func display_subtitles(key):
	$CanvasLayer/Subtitles.display(key)

func play_sfx(sfx):
	var asp = AudioStreamPlayer.new()
	add_child(asp)
	asp.stream = load(sfx)
	asp.play()

func _process(delta):
	if cont != 0:
		var value = abs(cont) if cont < 0 else 60 - cont
		$Fade.color.a = value/60.0
		cont -= sign(cont)
