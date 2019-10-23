extends Control

const Text = preload("res://terminal/Text.tscn")
const CommandLine = preload("res://terminal/CommandLine.tscn")

const PROMPT = "emoon@cipher$ "
const DX = 12
const DY = 30

var current_pos = Vector2(0, 0)
var line

var files = {
	"begin.txt": [ \
		"The answer is 'braggart'"
	]
}

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

func _execute(s):
	var comm = s.split(" ")
	match comm[0]:
		"cat":
			if len(comm) != 2:
				_print("Usage: cat [FILE]", true)
			elif not comm[1] in files:
				_print("cat: " + comm[1] + ": file not found", true)
			else:
				for line in files[comm[1]]:
					_print(line, true)
		"exit":
			visible = false
		"ls":
			for filename in files:
				_print(filename, true)
		_:
			_print(comm[0] + ": command not found", true)

func _process(comm):
	if not visible and Input.is_action_just_pressed("terminal_toggle"):
		visible = true
		_enter_command()
