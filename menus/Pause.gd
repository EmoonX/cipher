extends Control

const BlurEnv = preload("res://BlurEnv.res")
const NormalEnv = preload("res://NormalEnv.res")
const Options = preload("res://menus/Options.tscn")

onready var env = $"/root/Game".current.get_node("WorldEnvironment")

# Used to avoid Esc overlapping
var t = 0.0

# --------------------------------------------------------------------------- #

func _ready():
	env.environment = BlurEnv
	$Items/Resume.grab_focus()

func _process(delta):
	t += delta
	if $Items/Resume.pressed or \
			(t > 0.1 and Input.is_action_just_pressed("ui_cancel")):
		env.environment = NormalEnv
		get_tree().paused = false
		queue_free()
	elif $Items/Options.pressed:
		pause_mode = PAUSE_MODE_STOP
		$"/root/Game/CanvasLayer".add_child(Options.instance())
	elif $Items/ReturnToMenu.pressed:
		env.environment = NormalEnv
		get_tree().paused = false
		get_tree().change_scene("res://menus/MainMenu.tscn")
	elif $Items/QuitGame.pressed:
		get_tree().quit()
