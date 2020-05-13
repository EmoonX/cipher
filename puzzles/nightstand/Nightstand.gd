extends "res://puzzles/Puzzle.gd"

const DIST_EPS = 0.05

onready var pos_lamp = $"../BedsideLamp".translation
onready var pos_cactus = $"../Cactus".translation

# -------------------------------------------------------------------------- #

func _is_solved():
	# Puzzle is solved if objects are in swaped positions
	var lamp_ok = ($"../BedsideLamp".translation == pos_cactus)
	var cactus_ok = ($"../Cactus".translation == pos_lamp)
	return lamp_ok and cactus_ok

func snap_to_led():
	for object in [$"../BedsideLamp", $"../Cactus"]:
		for pos in [pos_lamp, pos_cactus]:
			var dist = (object.translation - pos).length()
			if dist < DIST_EPS:
				object.translation = pos
				break
