extends "res://puzzles/Puzzle.gd"

# Matrix of grid numbers
var grid = []

# Empty space position
var x0 = 2
var y0 = 2

# --------------------------------------------------------------------------- #

func _ready():
	# Shuffle list of numbers
	var numbers = [1, 2, 3, 4, 6, 7, 8, 9]
	numbers.shuffle()
	numbers.insert(4, 5)
	
	# Build initial matrix
	for i in range(3):
		grid.append([])
		for j in range(3):
			grid[i].append(numbers[3*i + j])
	
	# Set each piece with a different number
	var i = 0
	for piece in $Grid.get_children():
		if piece is Label:
			piece.text = str(numbers[i])
		else:
			piece.get_child(0).text = "5"
		i += 1
	
	# Calculate initial sums
	calculate_sums()

func calculate_sums():
	# Calculate sums on rows, columns and diagonals
	var sums = {}
	for node in $Sums.get_children():
		var sum = 0
		if node.name[0] == "H":
			var i = int(node.name[1]) - 1
			for j in range(3):
				sum += grid[i][j]
		elif node.name[0] == "V":
			var j = int(node.name[1]) - 1
			for i in range(3):
				sum += grid[i][j]
		elif node.name == "D1":
			for i in range(3):
				sum += grid[i][i]
		elif node.name == "D2":
			for i in range(3):
				sum += grid[i][2-i]
		
		# Change text
		node.text = str(sum)
		
		# Add sum to set
		sums[sum] = true
	
	# If all sums are equal, you win!
	if len(sums) == 1:
		get_tree().quit()
