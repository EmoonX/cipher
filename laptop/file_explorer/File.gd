extends Button

var extension = ""

# --------------------------------------------------------------------------- #

func _ready():
	if "." in $Name.text:
		extension = $Name.text.substr($Name.text.find_last(".") + 1)
	var icon_path = "res://laptop/file_explorer/icons/"
	match extension:
		"":
			icon_path += "folder.png"
		"txt":
			icon_path += "text.png"
		"jpg", "png":
			icon_path += "image.png"
		"wav":
			icon_path += "audio.png"
		"webm":
			icon_path += "video.png"
	$Icon.texture = load(icon_path)

func _on_File_focus_entered():
	get_node("Name").set("custom_colors/font_color", ColorN("white"))

func _on_File_focus_exited():
	get_node("Name").set("custom_colors/font_color", ColorN("black"))

func _on_File_gui_input(event: InputEvent):
	if event.is_action_pressed("ui_accept") or \
			event is InputEventMouseButton and event.doubleclick:
		if not "." in $Name.text:
			# Change the current directory if it's a folder
			$"../..".path += $Name.text + "/"
			$"../..".show_files()
