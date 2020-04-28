extends Control

# --------------------------------------------------------------------------- #

func _process(delta):
	# Enter or exit map
	if not visible and Input.is_action_just_pressed("map") and \
			not get_tree().paused:
		visible = true
		$"..".visible = true
		$"/root/Game".pause_toggle()
	elif visible and Input.is_action_just_pressed("map"):
		visible = false
		$"..".visible = false
		$"/root/Game".pause_toggle()
	Input.action_release("map")
