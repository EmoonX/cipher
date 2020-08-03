extends "res://puzzles/Puzzle.gd"

const Stone = preload("Stone.tscn")

# Stones count for each stack
var stones = []

# --------------------------------------------------------------------------- #

func _ready():
	randomize()
	
	# Build stacks of stones
	for stack in $Stacks.get_children():
		var k = 1 + (randi() % 5);
		stones.append(k);
		
		#
		var gap = Control.new()
		
		
		for i in range(k):
			var stone = Stone.instance()
			stack.add_child(stone)
		
