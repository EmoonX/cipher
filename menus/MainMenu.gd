extends Control

# --------------------------------------------------------------------------- #

func _ready():
	# Create player configuration file (if it doesn't exist)
	var file = File.new()
	if not file.file_exists(Config.FILE):
		var dir = Directory.new()
		var err = dir.copy(Config.BASE, Config.FILE)
	
	# Load saved options
	Config.file.load(Config.FILE)
	Config.set_options()
	
func _process(delta):
	# Apply fade in
	if $Fade.color.a > 0.0:
		var value = $Fade.color.a - delta
		$Fade.color.a = max(value, 0.0)
		if $Fade.color.a == 0.0:
			$Fade.visible = false
			$Items/Start.grab_focus()
	
	# Check button presses
	if $Items/Start.pressed:
		get_tree().change_scene("res://Game.tscn")
	elif $Items/Options.pressed:
		get_tree().change_scene("res://menus/Options.tscn")
	elif $Items/Quit.pressed:
		get_tree().quit()
