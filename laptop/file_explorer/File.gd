extends Button

# --------------------------------------------------------------------------- #

func _on_File_focus_entered():
	get_node("Name").set("custom_colors/font_color", ColorN("white"))

func _on_File_focus_exited():
	get_node("Name").set("custom_colors/font_color", ColorN("black"))

func _on_File_gui_input(event: InputEvent):
	if event.is_action_pressed("ui_accept") or \
			event is InputEventMouseButton and event.doubleclick:
		$"../..".path += $Name.text + "/"
		$"../..".show_files()
