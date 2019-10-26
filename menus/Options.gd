extends Control

# --------------------------------------------------------------------------- #

func _ready():
	var languages = ["English", "Português (Brasil)"]
	for id in range(len(languages)):
		$Language/OptionButton.add_item(languages[id], id)
	
	$Language/OptionButton.grab_focus()
