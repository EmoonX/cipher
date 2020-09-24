extends "res://puzzles/Puzzle.gd"

# --------------------------------------------------------------------------- #

func _draw():
	for soldier in get_children():
		var size = soldier.get_node("Image").rect_size
		var pos1 = soldier.offset + soldier.get_node("Image").rect_position
		pos1 += size / 2
		for other in get_children():
			var pos2 = other.offset + other.get_node("Image").rect_position
			pos2 += size / 2
			draw_line(pos1, pos2, ColorN("crimson"), 5.0)

func _process(delta):
	update()
