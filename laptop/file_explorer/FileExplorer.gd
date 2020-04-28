extends ColorRect

const _File = preload("File.tscn")

var cwd = Directory.new()
var path = "res://user/files/"

# --------------------------------------------------------------------------- #

func _ready():
	show_files()
	
func show_files():
	# Clean up previous directory files (if any)
	for file in $FileGrid.get_children():
		file.queue_free()
	
	# Show current directory files (including folders)
	var files = []
	cwd.change_dir(path)
	cwd.list_dir_begin(true)
	while true:
		var filename = cwd.get_next()
		if not filename:
			break
		if ".import" in filename:
			continue
		files.append(filename)
	files.sort()
	for filename in files:
		var file = _File.instance()
		
		var icon
		if not "." in filename:
			# If it doesn't have an extension, it must be a folder
			icon = load("res://laptop/file_explorer/icons/folder.png")
			
		file.get_node("Icon").texture = icon
		file.get_node("Name").text = filename
		$FileGrid.add_child(file)
