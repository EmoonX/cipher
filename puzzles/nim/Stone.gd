extends TextureRect

onready var puzzle = $"../../.."

# --------------------------------------------------------------------------- #

func _on_Stone_focus_entered():
	# Remove substack of stones from itself to top upon click
	release_focus()
	var i = $"..".get_index()
	if puzzle.cur != i:
		return
	var j = get_index()
	puzzle.remove_stones(j)
