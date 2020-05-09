extends Spatial

onready var initial_pos = $Camera.translation

# --------------------------------------------------------------------------- #

func _ready():
	set_process(false)
	set_process_input(false)

func _on_Puzzle_visibility_changed():
	if visible:
		$Camera.current = true
		get_tree().paused = true
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		$"/root/Game".active_object = null
		
	set_process(visible)
	set_process_input(visible)

func _input(event):
	# Make camera lightly follow mouse movement on screen
	if event is InputEventMouseMotion:
		# Calculate mouse offset based on its position relative to center
		var mouse_pos = get_viewport().get_mouse_position()
		var mouse_offset = mouse_pos - (OS.window_size / 2)
		
		# Calculate new adjusted camera translation
		var x_new = initial_pos.x + (mouse_offset.x / 20000)
		var y_new = initial_pos.y - (mouse_offset.y / 10000)
		var pos_new = Vector3(x_new, y_new, $Camera.translation.z)
		
		# Make smooth "delayed" interpolation to next position
		$Camera/Tween.interpolate_property($Camera, "translation", \
				null, pos_new, 1.5, Tween.TRANS_EXPO, Tween.EASE_OUT)
		$Camera/Tween.start()
