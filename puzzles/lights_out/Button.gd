extends Button

# Button position
var i
var j

# --------------------------------------------------------------------------- #

func _on_Button_toggled(button_pressed):
	var positions = [
		Vector2(i-1, j), Vector2(i+1, j), Vector2(i, j-1), Vector2(i, j+1)
	]
	for pos in positions:
		if pos.x < 0 or pos.x >= $"../..".height or \
				pos.y < 0 or pos.y >= $"../..".width:
			continue
		var button = $"../..".grid[pos.x][pos.y]
		button.pressed = not button.pressed
