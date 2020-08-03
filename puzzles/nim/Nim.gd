extends "res://puzzles/Puzzle.gd"

const Stone = preload("Stone.tscn")

# Stones count for each stack
var stones = []

# Currently selectable stack
var cur = 0

# --------------------------------------------------------------------------- #

func _ready():
	randomize()
	
	# Build stacks of stones
	for stack in $Stacks.get_children():
		var k = 1 + (randi() % 5);
		stones.append(k);
		for i in range(k):
			var stone = Stone.instance()
			stack.add_child(stone)

func remove_stones(idx: int):
	# Remove substack of stones from index to top in current stack
	var k = stones[cur] - idx - 1
	var stack = $Stacks.get_child(cur)
	for j in range(stones[cur] - 1, k - 1, -1):
		var stone = stack.get_child(j)
		stack.remove_child(stone)
	stones[cur] = k
	
	# If stack is now empty, make the next one selectable
	if stones[cur] == 0:
		cur += 1
