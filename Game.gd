extends Node

# Current area
onready var current = $Corridor

# Number of pics taken with camera
var num_pics = 0

var cont = -60

# --------------------------------------------------------------------------- #

func display_subtitles(key):
	$Subtitles.display(key)

func play_sfx(sfx):
	# Play requisited audio file
	var asp = AudioStreamPlayer.new()
	add_child(asp)
	asp.stream = load(sfx)
	asp.play()

func pause_toggle():
	# Treats procedures to be done on (un)pause (+ inventory/terminal)
	get_tree().paused = not get_tree().paused
	_tween_blur(get_tree().paused)
	var mode = Input.MOUSE_MODE_VISIBLE if get_tree().paused \
			else Input.MOUSE_MODE_CAPTURED
	Input.set_mouse_mode(mode)

func _tween_blur(increase):
	# Do an interpolated (de)blur effect
	var tween = Tween.new()
	var next = 3 if increase else 0
	tween.interpolate_property($ScreenEffects/Blur.material,
			"shader_param/amount", null, next, 0.2,
			Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.start()
	add_child(tween)
	yield(tween, "tween_completed")
	remove_child(tween)

func _process(delta):
	if cont != 0:
		var value = abs(cont) if cont < 0 else 60 - cont
		$ScreenEffects/Fade.color.a = value/60.0
		cont -= sign(cont)
	
	# Show number of frames per second
	if Input.is_action_just_pressed("fps"):
		$FPSCounter.visible = not $FPSCounter.visible
	if $FPSCounter.visible and delta > 0.0:
		var fps = 1 / delta
		$FPSCounter.text = "%2.1f FPS" % fps
