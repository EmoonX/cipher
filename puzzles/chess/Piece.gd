extends Control

export(String) var color
export(String) var type
export(String) var position

# --------------------------------------------------------------------------- #

func _on_Piece_focus_entered():
	# Turn or unturn piece transparent when clicked
	if modulate.a == 1.0:
		modulate = Color(1, 1, 1, 0.1)
	else:
		modulate = Color(1, 1, 1, 1.0)
	
	# Make piece clickable again immediately
	release_focus()
