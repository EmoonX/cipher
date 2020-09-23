extends Label

# Position of piece on grid
onready var x = (get_index() % 3) + 1
onready var y = (get_index() / 3) + 1

# --------------------------------------------------------------------------- #

func _on_Piece_focus_entered():
	if modulate.a != 1.0:
		# Middle piece can't be moved
		return
	
	# Move piece on click, if adjacent to a blank position
	var x0 = $"../..".x0
	var y0 = $"../..".y0
	var pos_list = [[x-1, y], [x+1, y], [x, y-1], [x, y+1]]
	for pos in pos_list:
		if pos[0] == x0 and pos[1] == y0:
			# Smootly reposition piece
			var tween = Tween.new()
			add_child(tween)
			if x0 != x:
				tween.interpolate_property(self, "rect_position:x",
						null, rect_size.x * (x0 - 1), 0.1,
						Tween.TRANS_LINEAR, Tween.EASE_OUT)
			else:
				tween.interpolate_property(self, "rect_position:y",
						null, rect_size.y * (y0 - 1), 0.1,
						Tween.TRANS_LINEAR, Tween.EASE_OUT)
			tween.start()
			yield(tween, "tween_completed")
			remove_child(tween)
			
			# Update grid matrix
			$"../..".grid[y-1][x-1] = 5 if (x == 2 and y == 2) else 0
			$"../..".grid[y0-1][x0-1] = int(text)
			
			# Swap values
			$"../..".x0 = x
			$"../..".y0 = y
			x = x0
			y = y0
			
			# Recalculate sums
			$"../..".calculate_sums()
			
			break
	
	# Allow piece to be clicked again immediately
	release_focus()
