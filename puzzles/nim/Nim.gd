extends "res://puzzles/Puzzle.gd"

const Stone = preload("Stone.tscn")

# Stones count for each stack
var stones = []

# Currently selectable stack
var cur = 0

# If current turn is CPU's turn
var cpu = false

# --------------------------------------------------------------------------- #

func _ready():
	randomize()
	
	# Build stacks of stones
	for stack in $Stacks.get_children():
		var k = 1 + (randi() % 5);
		if k == 5:
			# One-stone stacks are more frequent >:)
			k = 1
		if stones.empty() and k == 1:
			# Avoid starting with one-stones, as they lead to
			# unwinnable situations (and overall just shorten the game)
			k = 2 + (randi() % 3)
		stones.append(k);
		for i in range(k):
			var stone = Stone.instance()
			stack.add_child(stone)
	
	_highlight_current()

func _highlight_current():
	# Glow current stack
	var stack = $Stacks.get_child(cur)
	var color = ColorN("lightgoldenrod" if not cpu else "pink")
	for stone in stack.get_children():
		stone.modulate = color

func remove_stones(idx: int):
	# Remove substack of stones from index to top in current stack
	var k = stones[cur] - idx - 1
	var stack = $Stacks.get_child(cur)
	for j in range(stones[cur] - 1, k - 1, -1):
		var stone = stack.get_child(j)
		stack.remove_child(stone)
	stones[cur] = k
	
	# Change turn
	cpu = not cpu
	
	# If stack is now empty, make the next one selectable
	if stones[cur] == 0:
		cur += 1
	
	# Highlight current stack
	_highlight_current()
	
	if cpu:
		_cpu_turn()

func _cpu_turn():
	# Wait a little bit
	yield(get_tree().create_timer(1.0), "timeout")
	
	# If current is last stack, CPU wins immediately
	if cur == stones.size() - 1:
		remove_stones(stones[cur] - 1)
		print("YOU DIED")
		get_tree().quit()
	
	if stones[cur] == 1:
		# If just one stone, pick it up
		remove_stones(0);
	else:
		# Check if ahead is an odd-length continuous sequence
		# of one-stones that ends *before* the last one
		var count = 0
		for i in range(cur + 1, stones.size()):
			if stones[i] == 1:
				count += 1
			else:
				break
		if count % 2 == 1:
			# If positive, pick up all to avoid losing advantage
			remove_stones(stones[cur] - 1)
		else:
			# General case: just pick up all minus the bottom one
			remove_stones(stones[cur] - 2)
		
