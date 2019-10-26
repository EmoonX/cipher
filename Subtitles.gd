extends Label

var dialog = []
var index = 0
var cont = 0

# --------------------------------------------------------------------------- #

func display(dialog):
	self.dialog = TranslationServer.translate(dialog).split("\n")
	index = 0
	cont = 0
	text = ""

func _process(delta):
	if not dialog:
		return
	if cont == 0:
		if index < len(dialog):
			text = dialog[index]
			index += 1
			cont = 0
		else:
			text = ""
			dialog = []
			index = 0
	
	cont = (cont + 1) % 240
