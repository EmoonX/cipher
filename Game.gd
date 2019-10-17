extends Node

var exit = false
var cont = 0

func _process(delta):
	if exit:
		if cont < 120:
			$Fade.color.a = cont/120.0
			cont += 1
		else:
			get_tree().quit()
