extends Control

# Formal puzzle info
export(String) var number
export(String) var title
export(String) var rank
export(String) var description

# --------------------------------------------------------------------------- #

func _ready():
	# Easy randomizer for all puzzles :)
	randomize()
