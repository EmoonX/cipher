extends Control
	
func _process(delta):
	if $Fade.color.a > 0.0:
		var value = $Fade.color.a - delta
		$Fade.color.a = max(value, 0.0)
		if $Fade.color.a == 0.0:
			$Fade.visible = false
			$Items/Start.grab_focus()
	
	if $Items/Start.pressed:
		get_tree().change_scene("res://Game.tscn")
	elif $Items/Options.pressed:
		get_tree().change_scene("res://menus/Options.tscn")
	elif $Items/Quit.pressed:
		get_tree().quit()
