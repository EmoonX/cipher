extends Sprite

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		# Hide from view and return control to terminal
		visible = false
		get_parent().pause_mode = Node.PAUSE_MODE_PROCESS
		pause_mode = Node.PAUSE_MODE_STOP
