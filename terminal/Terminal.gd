extends Control

const Text = preload("res://terminal/Text.tscn")
const CommandLine = preload("res://terminal/CommandLine.tscn")

const PROMPT = "emoon@cipher$ "
const DX = 12
const DY = 30

var current_pos = Vector2(0, 0)
var line

# List of gotten files (i.e. scanned)
var files = []

# --------------------------------------------------------------------------- #

func _print(s, newline=false):
	var text = Text.instance()
	add_child(text)
	text.text = s
	text.rect_position.x = current_pos.x * DX
	text.rect_position.y = current_pos.y * DY
	if newline:
		current_pos.x = 0
		current_pos.y += 1
	else:
		current_pos.x += len(s)

func _enter_command():
	if current_pos.x == 0:
		_print(PROMPT)
	line = CommandLine.instance()
	add_child(line)
	line.rect_position.x = current_pos.x * DX
	line.rect_position.y = current_pos.y * DY
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
			pass
		
		_:
			_print(comm[0] + ": command not found", true)

func _exit():
	visible = false
	get_tree().paused = false

func _process(comm):
	if not visible and Input.is_action_just_pressed("terminal_toggle"):
		visible = true
		get_tree().paused = true
		_enter_command()
	elif visible and Input.is_action_just_pressed("ui_cancel"):
		_exit()
