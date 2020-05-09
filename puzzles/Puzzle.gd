extends Spatial

onready var initial_pos = $Camera.translation

# --------------------------------------------------------------------------- #

func _ready():
	set_process(false)

func _on_Puzzle_visibility_changed():
	if visible:
		$Camera.current = true
		get_tree().paused = true
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		$"/root/Game".active_object = null
		
	set_process(visible)

func _process(_delta):
	# Make camera lightly follow mouse movement on screen
	var mouse_pos = get_viewport().get_mouse_position()
	var mouse_offset = (mouse_pos - (OS.window_size / 2))
	$Camera.translation.x = initial_pos.x + (mouse_offset.x / 20000)
	$Camera.translation.y = initial_pos.y - (mouse_offset.y / 10000)
