extends Node

const Button = preload("res://puzzles/lights_out/Button.tscn")

# Size of grid
export(int) var height = 5
export(int) var width = 5

# How many random clicks are done before playing
export(int) var clicks = 10

# Matrix containing grid buttons
var grid = []

# --------------------------------------------------------------------------- #

func _ready():
	# Fill grid with width x height buttons
	$Grid.columns = width
	for i in range(height):
		grid.append([])
		for j in range(width):
			var button = Button.instance()
			button.i = i
			button.j = j
			button.pressed = true
			$Grid.add_child(button)
			grid[i].append(button)
	
	# Click randomly to generate initial grid
	for x in range(clicks):
		var i = randi() % height
		var j = randi() % width
		grid[i][j].pressed = not grid[i][j].pressed
		toggle(i, j)

func toggle(i, j):
	# Toggle neighbour positions of clicked button
	var positions = [
		Vector2(i-1, j), Vector2(i+1, j), Vector2(i, j-1), Vector2(i, j+1)
	]
	for pos in positions:
		if pos.x < 0 or pos.x >= height or pos.y < 0 or pos.y >= width:
			continue
		var button = grid[pos.x][pos.y]
		button.pressed = not button.pressed

func _is_solved():
	# Check if all buttons are lightened up
	for i in range(height):
		for j in range(width):
			if not grid[i][j].pressed:
				return false
	return true

func _process(delta):
	if _is_solved():
		get_tree().quit()
