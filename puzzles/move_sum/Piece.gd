extends Label

# Position of piece on grid
onready var x = (get_index() % 3) + 1
onready var y = (get_index() / 3) + 1

# --------------------------------------------------------------------------- #

func _on_Piece_focus_entered():
	if modulate.a != 1.0:
		# Middle piece can't be moved
		return
	
	var x0 = $"../..".x0
	var y0 = $"../..".y0
	var pos_list = [[x-1, y], [x+1, y], [x, y-1], [x, y+1]]
	for pos in pos_list:
		if pos[0] == x0 and pos[1] == y0:
			print("OK")
			rect_position.x = rect_size.x * (x0 - 1)
			rect_position.y = rect_size.y * (y0 - 1)
			$"../..".x0 = x
			$"../..".y0 = y
			x = x0
			y = y0
			break
	
	# Allow piece to be clicked again immediately
	release_focus()
