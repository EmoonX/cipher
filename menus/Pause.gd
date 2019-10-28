extends Control

const Options = preload("res://menus/Options.tscn")

var previous_alpha

# --------------------------------------------------------------------------- #

func _ready():
	$Items/Resume.grab_focus()
	previous_alpha = $"/root/Game/Fade".color.a
	#$"/root/Game/Fade".color.a = max(previous_alpha, 0.8)

func _process(delta):
	if $Items/Resume.pressed:
		get_tree().paused = false
		#$"/root/Game/Fade".color.a = previous_alpha
		queue_free()
	elif $Items/Options.pressed:
		pause_mode = PAUSE_MODE_STOP
		$"/root/Game/CanvasLayer".add_child(Options.instance())
	elif $Items/ReturnToMenu.pressed:
		get_tree().paused = false
		get_tree().change_scene("res://menus/MainMenu.tscn")
	elif $Items/QuitGame.pressed:
		get_tree().quit()
