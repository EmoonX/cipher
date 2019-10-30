extends Control

const Text = preload("res://terminal/Text.tscn")
const CommandLine = preload("res://terminal/CommandLine.tscn")

const PROMPT = "emoon@cipher$ "
const DX = 12
const DY = 30

export(Color) var prompt_color

var current_pos = Vector2(0, 0)
var line

# List of gotten files (i.e. scanned)
var files = []

# --------------------------------------------------------------------------- #

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
			if node.name == "ColorRect":
				continue
			node.rect_position.y -= DY
		current_pos.y -= 1

func _print_prompt():
	var text = Text.instance()
	add_child(text)
	text.add_color_override("font_color", prompt_color)
	text.text = PROMPT
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

func _check(comm):
	# Check if a single argument is given AND file exists
	if len(comm) != 2:
		_print("Usage: " + comm[0] + " [FILE]", true)
		return false
	if not comm[1] in files:
		_print(comm[0] + ": " + comm[1] + ": file not found", true)
		return false
	
	return true

func _execute(s):
	var comm = s.split(" ")
	match comm[0]:
		"cat":
			if not _check(comm):
				return
			# Open file and print lines from it
			var file = File.new()
			var name = "res://qr/" + str(comm[1])
			file.open(name, File.READ)
			while true:
				var line = file.get_line()
				if not line:
					break 
				_print(line, true)
			file.close()
		
		"exit":
			_exit()
		
		"ls":
			for filename in files:
				_print(filename, true)
		
		"":
			_print("")
		
		_:
			_print(comm[0] + ": command not found", true)

func _print(s, newline=false):
	var text = Text.instance()
	add_child(text)
	text.text = s
	_position(text, newline)

func _exit():
	# Exit terminal
	visible = false
	get_tree().paused = false

func _process(delta):
	if not visible and Input.is_action_just_pressed("terminal"):
		visible = true
		get_tree().paused = true
		_enter_command()
	elif visible and Input.is_action_just_pressed("ui_cancel"):
		Input.action_release("ui_cancel")
		_exit()
