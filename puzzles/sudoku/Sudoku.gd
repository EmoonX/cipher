extends Node

const Number = preload("res://puzzles/sudoku/Number.tscn")

var grid = [ \
	"79    3  ",
	"      69 ",
	"8   3  76",
	"     5  2",
	"  54187  ",
	"4  7     ",
	"61  9   8",
	"  23     ",
	"  9    54"
]

# --------------------------------------------------------------------------- #

func _ready():
	# Position numbers on grid
	for i in len(grid):
		for j in len(grid[0]):
			var number = Number.instance()
			$Grid.add_child(number)
			number.text = grid[i][j]
			number.rect_position += Vector2(-335 + 79*j, -350 + 79*i)
