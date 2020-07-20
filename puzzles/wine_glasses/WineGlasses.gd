extends "res://puzzles/Puzzle.gd"

const GlassEmpty = preload("GlassEmpty.tscn")
const GlassHalf = preload("GlassHalf.tscn")

# --------------------------------------------------------------------------- #

func _ready():
	for row in $Rows.get_children():
		var i = int(row.name) - 1
		var cols = pow(2, i)
		var x0 = -50 + ((1920 - 1400) / 2) + (1400 / (2 * cols))
		var dx = 1400 / cols
		for j in cols:
			var glass = GlassEmpty.instance()
			glass.rect_position.x = x0 + (j * dx)
			row.add_child(glass)
