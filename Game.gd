extends Node

onready var current = $Corridor
var cont = -60

# --------------------------------------------------------------------------- #

func display_subtitles(key):
	$CanvasLayer/Subtitles.display(key)

func play_sfx(sfx):
	# Play requisited audio file
	var asp = AudioStreamPlayer.new()
	add_child(asp)
	asp.stream = load(sfx)
	asp.play()

func pause_toggle():
	# Treats procedures to be done on (un)pause (+ inventory/terminal) game
	get_tree().paused = not get_tree().paused
	_tween_blur(get_tree().paused)
	var mode = Input.MOUSE_MODE_VISIBLE if get_tree().paused \
			else Input.MOUSE_MODE_CAPTURED
	Input.set_mouse_mode(mode)

func _tween_blur(increase):
	# Do an interpolated (de)blur effect
	var tween = Tween.new()
	var next = 3 if increase else 0
	tween.interpolate_property($CanvasLayer/Blur.material,
			"shader_param/amount", null, next, 0.3,
			Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.start()
	add_child(tween)
	yield(tween, "tween_completed")
	remove_child(tween)

func _process(delta):
	if cont != 0:
		var value = abs(cont) if cont < 0 else 60 - cont
		$Fade.color.a = value/60.0
		cont -= sign(cont)
