extends Node

const Number = preload("res://puzzles/sudoku/Number.tscn")

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

# --------------------------------------------------------------------------- #

func _ready():
	# Position numbers on grid
	for i in len(grid):
		for j in len(grid[0]):
			var number = Number.instance()
			$Grid.add_child(number)
			number.i = i
			number.j = j
			number.text = grid[i][j]
			number.rect_position += Vector2(-350 + 78*j, -350 + 79*i)
			if number.text != " ":
				# Disallow changing original numbers
				number.focus_mode = Control.FOCUS_NONE

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
	
	# If all numbers are valid, then we're done!
	var ok = true
	for number in $Grid.get_children():
		if number.text == " " or \
				number.get("custom_colors/font_color") == ColorN("red"):
			ok = false
			break
	if ok:
		get_tree().quit()
			
	return true
