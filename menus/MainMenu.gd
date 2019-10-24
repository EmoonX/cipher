extends Control
	
func _process(delta):
	if $Fade.color.a > 0.0:
		var value = $Fade.color.a - delta/2
		$Fade.color.a = max(value, 0.0)
		if $Fade.color.a == 0.0:
			$Fade.visible = false
			$Start.grab_focus()
	
	if $Start.pressed:
		get_tree().change_scene("res://Game.tscn")
	elif $Quit.pressed:
		get_tree().quit()
