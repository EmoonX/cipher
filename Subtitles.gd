extends Label

# Dictionary containing subtitles to be displayed
const subtitles = {
	"start": [ \
		"I find myself again stuck at the same dark corridor...",
		"Gotta find my way out."
	],
	"first_locked": [ \
		"Great, a locked door, already.",
		"Legend says that the dark side holds many things...",
		"Good thing that I have my flashlight with me.",
		"(whisper) Press F..."
	]
}

# List of already displayed subtitles
var displayed = []

var dialog = ""
var index = 0
var cont = 0

# --------------------------------------------------------------------------- #

func display(dialog):
	if not dialog in displayed:
		if self.dialog:
			displayed.append(self.dialog)
		self.dialog = dialog
		displayed.append(dialog)
		index = 0
		cont = 0
		text = ""

func _process(delta):
	if not dialog:
		return
	if cont == 0:
		if index < len(subtitles[dialog]):
			text = subtitles[dialog][index]
			index += 1
			cont = 0
		else:
			text = ""
			dialog = ""
			index = 0
	
	cont = (cont + 1) % 300
