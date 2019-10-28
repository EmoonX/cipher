extends Control

const Options = preload("res://menus/Options.tscn")

# --------------------------------------------------------------------------- #

func _process(delta):
	if not visible and Input.is_action_just_pressed("ui_cancel"):
		$"/root/Game".tween_blur(self, true)
		visible = true
		get_tree().paused = true
	elif visible:
		if $Items/Resume.pressed or Input.is_action_just_pressed("ui_cancel"):
			$"/root/Game".tween_blur(self, false)
			visible = false
			get_tree().paused = false
		elif $Items/Options.pressed:
			pause_mode = PAUSE_MODE_STOP
			$"/root/Game/CanvasLayer".add_child(Options.instance())
		elif $Items/ReturnToMenu.pressed:
			$"/root/Game".tween_blur(self, false)
			get_tree().paused = false
			get_tree().change_scene("res://menus/MainMenu.tscn")
		elif $Items/QuitGame.pressed:
			get_tree().quit()
