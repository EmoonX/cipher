extends "res://puzzles/Puzzle.gd"

const DIST_EPS = 0.02

# -------------------------------------------------------------------------- #

func check_and_snap(object):
	# Check if object is in position to be snapped
	# If positive, translate it to snap position
	var ok = false
	for led in $"../LEDs".get_children():
		var pos = led_pos[led.name]
		var dist = (object.virtual_pos - pos).length()
		if dist < DIST_EPS:
			object.translation = pos
			ok = true
			if led.name != object.name:
				led.change(true)
				return true
			break
	for led in $"../LEDs".get_children():
		if led.name != object.name:
			led.change(false)
			break
	return ok

func _is_solved():
	# Return if objects are in swaped positions
	var lamp_ok = ($"../BedsideLamp".translation == led_pos["Cactus"])
	var cactus_ok = ($"../Cactus".translation == led_pos["BedsideLamp"])
	return (lamp_ok and cactus_ok)
