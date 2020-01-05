extends Panel

# --------------------------------------------------------------------------- #

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_parent().pause_mode = PAUSE_MODE_STOP

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		# Close and return control to terminal
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		get_parent().pause_mode = PAUSE_MODE_PROCESS
		queue_free()
