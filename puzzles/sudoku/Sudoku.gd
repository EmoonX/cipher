extends Node

const Number = preload("res://puzzles/sudoku/Number.tscn")

const SIZE = 9

var grid = [ \
	"79    3  ",
	"     69  ",
	"8   3  76",
	"     5  2",
	"  54187  ",
	"4  7     ",
	"61  9   8",
	"  23     ",
	"  9    54"
]

var pgrid = []

# --------------------------------------------------------------------------- #

func _ready():
	# Position numbers on grid
	for i in len(grid):
		pgrid.append([])
		for j in len(grid[0]):
			var number = Number.instance()
			$Grid.add_child(number)
			pgrid[i].append(number)
			number.i = i
			number.j = j
			number.text = grid[i][j]
			number.rect_position += Vector2(-350 + 78*j, -350 + 79*i)
			if number.text != " ":
				# Disallow changing original numbers
				number.focus_mode = Control.FOCUS_NONE
	
	_solve()

func check(i, j):
	# Check if number just entered is valid
	var number = grid[i][j]
	
	# Row
	for k in range(len(grid)):
		if k == j:
			continue
		if grid[i][k] == number:
			return false
	# Column
	for k in range(len(grid)):
		if k == i:
			continue
		if grid[k][j] == number:
			return false
	# Box
	var ki = i/3
	var kj = j/3
	for p in range(3*ki, 3*(ki+1)):
		for q in range(3*kj, 3*(kj+1)):
			if p == i and q == j:
				continue
			if grid[p][q] == number:
				return false
	
	# If all numbers are valid, then the game is won!
	if _is_solved():
		get_tree().quit()
			
	return true
	
func mark_number(i, j, number):
	# Mark number on grid
	grid[i][j] = str(number)
	pgrid[i][j].text = grid[i][j]
	
	# Color it acordingly
	var color = ColorN("green" if check(i, j) else "red")
	pgrid[i][j].set("custom_colors/font_color", color)

func _is_solved():
	# Check if all numbers are valid ones
	for number in $Grid.get_children():
		if number.text == " " or \
				number.get("custom_colors/font_color") == ColorN("red"):
			return false
	return true

func _mark_dots(aux_grids, i, j):
	# Mark empty squares on respective row, column and large square
	var number = int(grid[i][j])
	for k in range(SIZE):
		if grid[i][k] == " ":
			aux_grids[number][i][k] = "."
		if grid[k][j] == " ":
			aux_grids[number][k][j] = "."
		var ii = i/3*3 + k/3
		var jj = j/3*3 + k%3
		if grid[ii][jj] == " ":
			aux_grids[number][ii][jj] = "."

func _valid_square(aux_grids, k, ki, kj):
	# Check if large square has exactly one valid position for number k
	var i = -1
	var j = -1
	for ii in range(ki*3, ki*3 + 3):
		for jj in range(kj*3, kj*3 + 3):
			if aux_grids[k][ii][jj] == " ":
				if i >= 0:
					return false
				i = ii
				j = jj
	
	return Vector2(i, j) if i >= 0 else false

func _solve_step(aux_grids):
	# Try to put a new number on the grid
	for k in range(1, 9+1):
		for ki in range(SIZE/3):
			for kj in range(SIZE/3):
				var pos = _valid_square(aux_grids, k, ki, kj)
				if pos:
					var i = int(pos.x)
					var j = int(pos.y)
					for kk in range(1, 9+1):
						aux_grids[kk][i][j] = str(k)
					mark_number(i, j, k)
					_mark_dots(aux_grids, i, j)
					return true
	return false

func _solve():
	# Solve a sudoku board, if possible
	
	# Start by creating auxiliary grids
	# Dots will represent empty squares where number is forbidden
	var aux_grids = {}
	for k in range(1, 9+1):
		aux_grids[k] = [] + grid
	for i in range(SIZE):
		for j in range(SIZE):
			if grid[i][j] != " ":
				_mark_dots(aux_grids, i, j)
	
	# Solve step by step by putting valid numbers
	while _solve_step(aux_grids):
		yield(get_tree().create_timer(1.0), "timeout")
