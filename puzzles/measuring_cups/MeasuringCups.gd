extends "res://puzzles/Puzzle.gd"

# --------------------------------------------------------------------------- #

class Vertex:
	# Cups' capacities
	const capacity = [11, 9, 7]
	
	# State of current vertex
	var oil = []
	var water = []
	
	# Minimum number of moves to reach state
	var dist = INF
	
	# List of adjacent vertices
	var adj = []
	
	func solved() -> bool:
		# Check if there's no cup with both water and oil
		for i in range(3):
			if oil[i] > 0 and water[i] > 0:
				return false
		return true
	
	func build_adj() -> void:
		# Build list of adjacent vertices
		for i in range(3):
			for j in range(3):
				if i == j:
					continue
				var v = Vertex.new()
				v.oil = [] + oil
				v.water = [] + water
				if v.oil[j] + v.water[j] < capacity[j]:
					var oil_d = \
							min(v.oil[i], capacity[j] - v.oil[j] - v.water[j])
					v.oil[i] -= oil_d
					v.oil[j] += oil_d
				if v.oil[j] + v.water[j] < capacity[j]:
					var water_d = \
							min(v.water[i], capacity[j] - v.oil[j] - v.water[j])
					v.water[i] -= water_d
					v.water[j] += water_d
				v.dist = dist + 1
				adj.append(v)

class Problem:
	# Initial state
	var root = Vertex.new()
	
	func solve(l: int, r: int) -> void:
		# Run BFS for finding solutions between l and r moves
		# If positive, print the minimum number of moves
		root.dist = 0
		var queue = [root]
		var visited = {[root.oil, root.water]: true}
		while not queue.empty():
			var v = queue.pop_front()
			if v.solved():
				if v.dist >= l and v.dist <= r:
					print(root.oil, ", ", root.water, ", ", v.dist)
				return
			v.build_adj()
			for u in v.adj:
				if not [u.oil, u.water] in visited:
					visited[[u.oil, u.water]] = true
					queue.push_back(u)

func _ready():
	# Search for solutions in a huge amount of base states (problems)
	for k in range(1e4):
		var p = Problem.new()
		for i in range(3):
			var oil = randi() % (Vertex.capacity[i] + 1)
			var water = randi() % (Vertex.capacity[i] - oil + 1)
			p.root.oil.append(oil)
			p.root.water.append(water)
		p.solve(11, 50)
