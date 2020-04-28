extends Button

const ImageViewer = preload("res://laptop/image_viewer/ImageViewer.tscn")
const MediaPlayer = preload("res://laptop/media_player/MediaPlayer.tscn")

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
		var path = $"../..".path + $Name.text
		print(path)
		match extension:
			"":
				# Change the current directory if it's a folder
				$"../..".path = path + "/"
				$"../..".show_files()
			"txt":
				pass
			"jpg", "png":
				# Display (and allow to edit) PNG image in viewer
				$"../..".add_child(ImageViewer.instance())
				$"../../ImageViewer/GUI/Image".texture = load(path)
			"wav", "webm":
				# Play media (audio or video) file
				var player = MediaPlayer.instance()
				player.file_name = path
				$"../..".add_child(player)
