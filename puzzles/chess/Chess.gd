extends Node

var ranks = "abcdefgh"
var positions = []

# --------------------------------------------------------------------------- #

func _ready():
	# Load piece sprites and position them accordingly
	for board in [$BoardA, $BoardB]:
		for piece in board.get_children():
			var sprite = piece.type + "_" + piece.color + ".png"
			piece.get_node("Sprite").texture = \
					load("res://puzzles/chess/" + sprite)
			piece.rect_position.x = -520 + 128 * ranks.find(piece.position[0])
			piece.rect_position.y = +504 - 128 * int(piece.position[1])
	
	# Save which positions appear simultaneously on both boards
	for a in $BoardA.get_children():
		for b in $BoardB.get_children():
			if a.position == b.position:
				positions.append(a.position)
				break

func _process(delta):
	# Check if there are any wrongly active/inactive pieces
	print(positions)
	for board in [$BoardA, $BoardB]:
		for piece in board.get_children():
			if piece.modulate.a == 1.0 and not piece.position in positions:
				return
			if piece.modulate.a != 1.0 and piece.position in positions:
				return
	
	# If piece positions on boards A and B are all equal, you win!
	get_tree().quit()
