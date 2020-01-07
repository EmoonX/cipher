extends HBoxContainer

var last_notes = ""

# --------------------------------------------------------------------------- #

func add(note):
	# Add note to string
	if len(last_notes) == 7:
		last_notes = last_notes.substr(1, 6)
	last_notes += note
	
	# Puzzle solution?
	if last_notes == "cabbage":
		get_tree().quit()
