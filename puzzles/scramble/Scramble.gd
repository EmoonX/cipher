extends Node

const Piece = preload("res://puzzles/scramble/Piece.tscn")

const image = preload("res://user/files/images/zephyra.jpg")

# Size of grid
export(int) var height = 5
export(int) var width = 5

# Matrix representing grid pieces
var grid = []

# --------------------------------------------------------------------------- #

func _ready():
	# Fill grid with width x height randomly rotated pieces
	for i in range(height):
		grid.append([])
		for j in range(width):
			var piece = Piece.instance()
			var w = piece.texture.atlas.get_width() / width
			var h = piece.texture.atlas.get_height() / height
			piece.i = i
			piece.j = j
			piece.rect_position = Vector2(j * w, i * h)
			piece.rect_size = Vector2(w, h)
			piece.texture.region.position = Vector2(j * w, i * h)
			piece.texture.region.size = Vector2(w, h)
			piece.rect_pivot_offset = Vector2(w/2, h/2)
			piece.rect_rotation = (randi() % 16) * 360 / 16
			$Grid.add_child(piece)
			grid[i].append(piece)

func _solved():
	for i in range(height):
		for j in range(width):
			if grid[i][j].rect_rotation != 0.0:
				return false
	return true

func _process(delta):
	if _solved():
		get_tree().quit()
