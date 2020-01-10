extends Node

const Slot = preload("res://puzzles/scramble/Slot.tscn")
const Piece = preload("res://puzzles/scramble/Piece.tscn")

const image = preload("res://user/files/images/zephyra.jpg")

# Size of grid
export(int) var height = 5
export(int) var width = 5

# Matrix representing grid pieces
var grid = []

# --------------------------------------------------------------------------- #

func _ready():
	# Do piece generation thingamajig
	for i in range(height):
		grid.append([])
		for j in range(width):
			var piece = Piece.instance()
			var w = piece.texture.atlas.get_width() / width
			var h = piece.texture.atlas.get_height() / height
			piece.i_goal = i
			piece.j_goal = j
			piece.rect_size = Vector2(w, h)
			piece.rect_position = OS.window_size / 2
			piece.texture.region.position = Vector2(j * w, i * h)
			piece.texture.region.size = Vector2(w, h)
			piece.rect_rotation = (randi() % 16) * 360 / 16
			piece.rect_pivot_offset = Vector2(w/2, h/2)
			add_child(piece)
			grid[i].append(piece)
			$Grid.add_child(Slot.instance())
	
	# Scatter and rotate pieces randomly
	for i in range(height-1, -1, -1):
		for j in range(width-1, -1, -1):
			var x = (1400 * (randi() % 2)) + randi() % 300
			var y = randi() % 900
			Util.move(grid[i][j], "rect_position", Vector2(x, y))
			Util.move(grid[i][j], "rect_rotation", (randi() % 16) * 360 / 16)
			yield(get_tree().create_timer(0.1), "timeout")

func _is_solved():
	# Check if all pieces are in correct position and rotation
	for i in range(height):
		for j in range(width):
			if grid[i][j].i_goal != grid[i][j].i or \
					grid[i][j].j_goal != grid[i][j].j:
				return false
			if grid[i][j].rect_rotation != 0.0:
				return false
	return true

func _process(delta):
	if _is_solved():
		get_tree().quit()
