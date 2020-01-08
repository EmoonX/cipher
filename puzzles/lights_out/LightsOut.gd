extends Node

const Button = preload("res://puzzles/lights_out/Button.tscn")

# Size of grid
export(int) var height = 5
export(int) var width = 5

# Boolean atrix representing grid state
var grid = []

# --------------------------------------------------------------------------- #

func _ready():
	# Fill grid with WIDTH x HEIGHT buttons
	$Grid.columns = width
	for i in range(height):
		grid.append([])
		for j in range(width):
			var button = Button.instance()
			button.i = i
			button.j = j
			button.pressed = false
			$Grid.add_child(button)
			grid[i].append(button)
