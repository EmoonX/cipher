extends "res://puzzles/Puzzle.gd"

# Position of empty space
var x0 = 2
var y0 = 2

# --------------------------------------------------------------------------- #

func _ready():
	# Shuffle list of numbers
	var numbers = [1, 2, 3, 4, 6, 7, 8, 9]
	numbers.shuffle()
	
	# Set each piece with a different number
	var i = 0
	for piece in $Grid.get_children():
		if piece is Label:
			piece.text = str(numbers[i])
			i += 1
		else:
			piece.get_child(0).text = "5"

func _process(delta):
	print(x0, " ", y0)
	
