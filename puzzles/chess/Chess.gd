extends Node

var aux = "abcdefgh"

# --------------------------------------------------------------------------- #

func _ready():
	for board in [$BoardA, $BoardB]:
		for piece in board.get_children():
			var sprite = piece.type + "_" + piece.color + ".png"
			piece.get_node("Sprite").texture = \
					load("res://puzzles/chess/" + sprite)
			piece.rect_position.x = -448 + 128 * aux.find(piece.position[0])
			piece.rect_position.y = +576 - 128 * int(piece.position[1])
