extends Control

const Text = preload("res://terminal/Text.tscn")
const CommandLine = preload("res://terminal/CommandLine.tscn")
const ImageViewer = preload("res://terminal/ImageViewer.tscn")
const AudioPlayer = preload("res://terminal/audio_player/AudioPlayer.tscn")

const DX = 12
const DY = 30

# Dictionaries of command explanation
const base_commands = {
	"cat": "print contents of file",
	"cd": "change current working directory",
	"exit": "quit terminal",
	"help": "what you are reading right now :)",
	"ls": "show current folder files",
	"play": "play audio file",
	"view": "display PNG image"
}
const extra_commands = {
	"bintoascii": "convert binary files to ASCII readable representation",
	"decode64": "decode a base64 encoded file and save into a new file",
	"demorse": "translate morse code from a file"
}

# Ordered ASCII chars
const ascii = "................................ !\"#$%&'()*+,-./0123456789" + \
		":;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`" + \
		"abcdefghijklmnopqrstuvwxyz{|}~."

# Dictionary of morse translations
const morse = {
	'.-': 'A', '-...': 'B', '-.-.': 'C', '-..': 'D', '.': 'E', 
	'..-.': 'F', '--.': 'G', '....': 'H', '..': 'I', '.---': 'J',
	'-.-': 'K', '.-..': 'L', '--': 'M', '-.': 'N', '---': 'O',
	'.--.': 'P', '--.-': 'Q', '.-.': 'R', '...': 'S', '-': 'T',
	'..-': 'U', '...-': 'V', '.--': 'W', '-..-': 'X', '-.--': 'Y', '--..': 'Z'
}

export(Color) var prompt_color
export(Color) var cwd_color

var current_pos = Vector2(0, 0)
var line

onready var cwd = Directory.new()

# List of gotten files (i.e. scanned)
#var files = []

# --------------------------------------------------------------------------- #

func _ready():
	# Set up ~ directory
	cwd.change_dir("res://user/files")
	
	# Position ImageViewer at screen center
	#$ImageViewer.position.x = get_viewport().size.x / 2
	#$ImageViewer.position.y = get_viewport().size.y / 2

func _position(box, newline=false):
	box.rect_position.x = current_pos.x * DX
	box.rect_position.y = current_pos.y * DY
	if newline:
		current_pos.x = 0
		current_pos.y += 1
	else:
		current_pos.x += len(box.text)
	
	# Flow content when screen limit reached
	if current_pos.y * DY >= rect_size.y:
		for node in get_children():
			if not node.name in ["ColorRect", "ImageViewer"]:
				node.rect_position.y -= DY
		current_pos.y -= 1

func _print_prompt():
	var text = Text.instance()
	add_child(text)
	text.add_color_override("font_color", prompt_color)
	text.text = "emoon@cipher:"
	_position(text)
	
	text = Text.instance()
	add_child(text)
	text.add_color_override("font_color", cwd_color)
	var dir = cwd.get_current_dir()
	dir = dir.replace("res://user/files", "~")
	text.text = dir
	_position(text)
	
	text = Text.instance()
	add_child(text)
	text.add_color_override("font_color", prompt_color)
	text.text = "$ "
	_position(text)
	
func _enter_command():
	if current_pos.x == 0:
		_print_prompt()
	line = CommandLine.instance()
	add_child(line)
	_position(line)
	line.grab_focus()
	line.connect("text_entered", self, "_on_CommandLine_text_entered")

func _on_CommandLine_text_entered(comm):
	current_pos.x = 0
	current_pos.y += 1
	line.disconnect("text_entered", self, "_on_CommandLine_text_entered")
	_execute(comm)
	_enter_command()

func _print(s, newline=false):
	var text = Text.instance()
	add_child(text)
	text.text = s
	_position(text, newline)

func _check(comm):
	# Check if a single argument is given AND file exists
	if len(comm) != 2:
		_print("Usage: " + comm[0] + " [FILE]", true)
		return false
	if not cwd.file_exists(comm[1]):
		_print(comm[0] + ": " + comm[1] + ": file not found", true)
		return false
	
	return true

func _cat(filename):
	# Open file and print lines from it
	var file = File.new()
	filename = cwd.get_current_dir() + "/" + filename
	file.open(filename, File.READ)
	while true:
		var line = file.get_line()
		if not line:
			break 
		_print(line, true)
	file.close()

func _play(filename):
	# Play audio file
	filename = cwd.get_current_dir() + "/" + filename
	add_child(AudioPlayer.instance())
	$AudioPlayer/Player.stream = load(filename)

func _view(filename):
	# Display PNG image in viewer
	filename = cwd.get_current_dir() + "/" + filename
	add_child(ImageViewer.instance())
	print(filename)
	$ImageViewer/GUI/Image/Sprite.texture = load(filename)

func _bin_to_ascii(filename):
	# Convert binary string from file to ASCII readable format
	var file = File.new()
	filename = cwd.get_current_dir() + "/" + filename
	file.open(filename, File.READ)
	var src = file.get_as_text()
	var text = ""
	for i in range(0, len(src) - 1, 8):
		var s = src.substr(i, 8)
		var index = 0
		for value in s:
			value = int(value)
			index *= 2
			index += value
		text += ascii[index]
	_print(text, true)

func _decode64(filename):
	# Open base64 input file
	var input = File.new()
	var input_name = cwd.get_current_dir() + "/" + filename
	input.open(input_name, File.READ)
	
	# Open to-be-decoded output file
	var output = File.new()
	var output_name = input_name + ".jpg"  # temporary?
	output.open(output_name, File.WRITE)
	
	# Decode buffer from input and store in output
	var text = input.get_as_text()
	text = Marshalls.base64_to_raw(text)
	output.store_buffer(text)

func _demorse(filename):
	# Translate text files containing morse code
	var file = File.new()
	filename = cwd.get_current_dir() + "/" + filename
	file.open(filename, File.READ)
	var src = file.get_as_text()
	var text = ""
	var code = ""
	for c in src:
		if c == "." or c == "-":
			code += c
		elif c == "/":
			text += " "
		else:
			text += morse[code]
			code = ""
	_print(text, true)

func _exit():
	# Exit terminal
	visible = false
	$"/root/Game".pause_toggle()

func _execute(s):
	var comm = s.split(" ")
	match comm[0]:
		"cat":
			if not _check(comm):
				return
			_cat(comm[1])
		
		"cd":
			if cwd.dir_exists(comm[1]):
				if comm[1] != ".":
					var dir = cwd.get_current_dir()
					if comm[1] == "..":
						if dir != "res://user/files":
							dir = dir.substr(0, dir.find_last("/"))
					else:
						dir += "/" + comm[1]
					cwd.change_dir(dir)
			else:
				_print("cd: " + comm[1] + ": directory not found", true)
		
		"exit":
			_exit()
		
		"help":
			_print("Available commands:", true)
			for c in base_commands:
				_print("  " + c + ": " + base_commands[c], true)
			_print("  ====", true)
			for c in extra_commands:
				_print("  " + c + ": " + extra_commands[c], true)
		
		"ls":
			cwd.list_dir_begin()
			var filenames = []
			while true:
				var filename = cwd.get_next()
				if filename:
					if cwd.dir_exists(filename):
						filename += "/"
					filenames.append(filename)
				else:
					break
			cwd.list_dir_end()
			filenames.sort()
			for filename in filenames:
				_print(filename, true)
		
		"play":
			if not _check(comm):
				return
			_play(comm[1])
		
		"view":
			if not _check(comm):
				return
			_view(comm[1])
		
		# ------------------------------------------------------------------- #
		
		"bintoascii":
			if not _check(comm):
				return
			_bin_to_ascii(comm[1])
		
		"decode64":
			if not _check(comm):
				return
			_decode64(comm[1])
		
		"demorse":
			if not _check(comm):
				return
			_demorse(comm[1])
		
		# ------------------------------------------------------------------- #
		
		"":
			_print("")
		
		_:
			_print(comm[0] + ": command not found", true)

func _process(delta):
	if not visible and Input.is_action_just_pressed("terminal") and \
			not get_tree().paused:
		visible = true
		$"/root/Game".pause_toggle()
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		_enter_command()
	elif visible and Input.is_action_just_pressed("ui_cancel"):
		Input.action_release("ui_cancel")
		_exit()
