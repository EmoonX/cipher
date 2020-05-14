extends "res://puzzles/Puzzle.gd"

const DIST_EPS = 0.02

onready var pos_lamp = $"../BedsideLamp".translation
onready var pos_cactus = $"../Cactus".translation

# -------------------------------------------------------------------------- #

func check_and_snap(object: Draggable):
	# Check if object is in position to be snapped
	# If positive, translate it to snap position
	for pos in [pos_lamp, pos_cactus]:
		var dist = (object.virtual_pos - pos).length()
		if dist < DIST_EPS:
			object.translation = pos
			return true
	return false

func _is_solved():
	# Return if objects are in swaped positions
	var lamp_ok = ($"../BedsideLamp".translation == pos_cactus)
	var cactus_ok = ($"../Cactus".translation == pos_lamp)
	return (lamp_ok and cactus_ok)
