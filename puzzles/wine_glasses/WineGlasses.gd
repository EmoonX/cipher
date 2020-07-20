extends "res://puzzles/Puzzle.gd"

const GlassEmpty = preload("GlassEmpty.tscn")
const GlassHalf = preload("GlassHalf.tscn")

# Sequence of glasses selected by player
var player_answer = []

# Correct sequence of glasses
var solution = []

# --------------------------------------------------------------------------- #

func _ready():
	# Build grid of wine glasses
	for row in $Rows.get_children():
		var i = int(row.name) - 1
		var cols = pow(2, i)
		var x0 = -50 + ((1920 - 1400) / 2) + (1400 / (2 * cols))
		var dx = 1400 / cols
		var k
		for j in cols:
			if j % 2 == 0:
				k = randi() % 2
			else:
				k = 1 if k == 0 else 0
			var glass
			if i == 0 or k == 0:
				glass = GlassEmpty.instance()
			else:
				glass = GlassHalf.instance()
			glass.rect_position.x = x0 + (j * dx)
			row.add_child(glass)
	
	_build_solution(0, 0)
	print(solution)

func _build_solution(i: int, j: int):
	# Build solution recursively based on glasses' distribution
	if i == ($Rows.get_child_count() - 1):
		solution.append(j)
		return
	var l = 2*j
	var r = 2*j + 1
	var glass_left = $Rows.get_child(i+1).get_child(l)
	if glass_left.type == "Half":
		_build_solution(i+1, l)
		_build_solution(i+1, r)
	else:
		_build_solution(i+1, r)
		_build_solution(i+1, l)

func check_answer():
	# Check if given answer is correct
	if player_answer == solution:
		get_tree().quit()
	
