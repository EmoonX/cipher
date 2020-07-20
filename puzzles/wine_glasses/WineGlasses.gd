extends "res://puzzles/Puzzle.gd"

const GlassEmpty = preload("GlassEmpty.tscn")
const GlassHalf = preload("GlassHalf.tscn")

# --------------------------------------------------------------------------- #

func _ready():
	for row in $Rows.get_children():
		var i = int(row.name) - 1
		var cols = pow(2, i)
		for j in cols:
			var glass = GlassEmpty.instance()
			glass.rect_position.x += 200 * j
			row.add_child(glass)
