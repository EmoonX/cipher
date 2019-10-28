extends Control

const OptionsMenu = preload("res://menus/OptionsMenu.tscn")

# --------------------------------------------------------------------------- #

func _process(delta):
	if not visible and Input.is_action_just_pressed("ui_cancel"):
		visible = true
		$"/root/Game".pause_toggle()
		$Items/Resume.grab_focus()
	elif visible:
		if $Items/Resume.pressed or Input.is_action_just_pressed("ui_cancel"):
			visible = false
			$"/root/Game".pause_toggle()
		elif $Items/Options.pressed:
			pause_mode = PAUSE_MODE_STOP
			$"/root/Game/CanvasLayer".add_child(OptionsMenu.instance())
		elif $Items/ReturnToMenu.pressed:
			$"/root/Game".pause_toggle()
			get_tree().change_scene("res://menus/MainMenu.tscn")
		elif $Items/QuitGame.pressed:
			get_tree().quit()
