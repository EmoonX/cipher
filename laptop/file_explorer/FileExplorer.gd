extends ColorRect

const _File = preload("File.tscn")

onready var path = "res://user/files/"

# --------------------------------------------------------------------------- #

func _ready():
	_show_files()
	
func _show_files():
	# Show current directory files (including folders)
	var cwd = Directory.new()
	cwd.change_dir(path)
	cwd.list_dir_begin(true)
	while true:
		var filename = cwd.get_next()
		if not filename:
			break
		if cwd.current_is_dir():
			var file = _File.instance()
			file.get_node("Icon").texture = \
					load("res://laptop/file_explorer/icons/folder.png")
			file.get_node("Name").text = filename
			$FileGrid.add_child(file)
