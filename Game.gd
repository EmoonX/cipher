extends Node

onready var current = $Corridor
var cont = -60

# --------------------------------------------------------------------------- #

func display_subtitles(key):
	$CanvasLayer/Subtitles.display(key)

func play_sfx(sfx):
	var asp = AudioStreamPlayer.new()
	add_child(asp)
	asp.stream = load(sfx)
	asp.play()

func tween_blur(caller, increase):
	var tween = Tween.new()
	var next = 3 if increase else 0
	tween.interpolate_property($CanvasLayer/Blur.material,
			"shader_param/amount", null, next, 0.3,
			Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.start()
	caller.add_child(tween)
	yield(tween, "tween_completed")
	caller.remove_child(tween)

func _process(delta):
	if cont != 0:
		var value = abs(cont) if cont < 0 else 60 - cont
		$Fade.color.a = value/60.0
		cont -= sign(cont)
