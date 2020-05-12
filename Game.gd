extends Node

# Current room/area
var current

# Set of event string flags that already happened
var flags = []

# Set of already examined objects (e.g. for pre-name purposes)
var examined_objects = {}

# Currently active object
var active_object = null

# Number of pics taken with camera
var num_pics = 0

var cont = -60

# --------------------------------------------------------------------------- #

func _ready():
	# Load saved game info before game starts
	connect("ready", Save, "load_game")

func check_and_flag(event):
	# Return if an one-timed event has not been played
	# In case it is still unseen, flag it as done
	if not event in flags:
		flags.append(event)
		return true

func play_sfx(sfx):
	# Play requisited audio file
	var asp = AudioStreamPlayer.new()
	asp.stream = load(sfx)
	asp.play()
	add_child(asp)

func pause_toggle():
	# Treats procedures to be done on (un)pause (+ inventory/terminal)
	get_tree().paused = not get_tree().paused
	_tween_blur(get_tree().paused)
	if get_tree().paused:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
#		$Speech/Audio.stream_paused = true
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
#		$Speech/Audio.stream_paused = false

func _tween_blur(increase):
	# Do an interpolated (de)blur effect
	var tween = Tween.new()
	add_child(tween)
	var next = 2 if increase else 0
	tween.interpolate_property($ScreenEffects/Blur.material,
			"shader_param/amount", null, next, 0.2,
			Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.start()
	yield(tween, "tween_completed")
	remove_child(tween)

func save():
	var save_dict = {
		"room": current.name,
		"flags": flags
	}
	return save_dict

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
