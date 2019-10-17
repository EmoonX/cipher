extends Label

var dialog = [
	"Once again, I find myself stuck at the same dark corridor...",
	"Gotta find my way out."
]

var cont = 120
var index = 0

func _process(delta):
	if cont == 240:
		text = dialog[index] if index < len(dialog) else ""
		index += 1
		cont = 0
	
	cont += 1
