extends Button

# --------------------------------------------------------------------------- #

func _on_File_focus_entered():
	get_node("Name").set("custom_colors/font_color", ColorN("white"))

func _on_File_focus_exited():
	get_node("Name").set("custom_colors/font_color", ColorN("black"))
