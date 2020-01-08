extends Button

# Button position
var i
var j

# --------------------------------------------------------------------------- #

func _on_Button_toggled(button_pressed):
	$"../..".toggle(i, j)
