extends TextureRect

# If the glass is empty or half-full
export(String, "Empty", "Half") var type

onready var puzzle = $"../../.."

# --------------------------------------------------------------------------- #

func _on_Glass_focus_entered():
	# Only work on last row
	if $"..".get_index() != 3:
		return
	
	# Change appearance on click
	modulate.a = 0.5
	
	# Add glass column index to player answer sequence
	var j = get_index()
	puzzle.player_answer.append(j)
	
	# Check player's answer
	puzzle.check_answer()
