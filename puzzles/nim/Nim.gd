extends "res://puzzles/Puzzle.gd"

const Stone = preload("Stone.tscn")

# Stones count for each stack
var stones = []

# Currently selectable stack reference
onready var stack = $Stacks.get_child(0)

# Position of current stack and base stone index
var cur = 0
var pos = 0

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

func _fade_stones(idx: int):
	# Highlight and fade currently selected stones starting from index
	var color = ColorN("lightgoldenrod" if not cpu else "pink")
	for j in range(pos, idx + 1):
		var stone = stack.get_child(j)
		var tween = Tween.new();
		var invis = color
		invis.a = 0.0
		tween.interpolate_property(stone, "modulate", color, invis, 1.0)
		add_child(tween)
		tween.start()

func remove_stones(idx: int):
	# Show planned move for a little bit
	_fade_stones(idx)
	yield(get_tree().create_timer(1.0), "timeout")
	
	# Remove substack of stones from index to top in current stack
	for j in range(pos, idx + 1):
		var stone = stack.get_child(j)
		stone.focus_mode = Control.FOCUS_NONE
	pos = idx + 1
	stones[cur] = stack.get_child_count() - pos
	
	# If stack is now empty, make the next one selectable	
	if stones[cur] == 0:
		cur += 1
		pos = 0
		if cur < stones.size():
			stack = $Stacks.get_child(cur)
		else:
			if cpu:
				print("YOU DIED")
			else:
				print("YOU WIN!")
			get_tree().quit()
			return
			
	# Change turn
	cpu = not cpu
	
	if cpu:
		# Do CPU thinking and action
		_cpu_turn()

func _cpu_turn():
	# If current is last stack, CPU wins immediately
	if cur == stones.size() - 1:
		remove_stones(stack.get_child_count() - 1)
	elif stones[cur] == 1:
		# If just one stone, pick it up
		remove_stones(pos);
	else:
		# Check if ahead is an odd-length continuous sequence
		# of one-stones that ends *before* the last one
		var count = 0
		for i in range(cur + 1, stones.size()):
			if stones[i] == 1:
				count += 1
			else:
				break
		if count % 2 == 1 and cur < stones.size() - 2:
			# If positive, pick up all to avoid losing advantage
			# (except if next is last and has just one stone)
			remove_stones(stack.get_child_count() - 1)
		else:
			# General case: just pick up all minus the bottom one
			remove_stones(stack.get_child_count() - 2)
		
