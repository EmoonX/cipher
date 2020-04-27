extends Control

# --------------------------------------------------------------------------- #

func _ready():
	# Create player configuration file (if non existent)
	var file = File.new()
	if not file.file_exists(Config.FILE):
		var dir = Directory.new()
		var err = dir.copy(Config.BASE, Config.FILE)
	
	# Load saved options
	Config.file.load(Config.FILE)
	Config.set_options()
	
	# Allow mouse interaction
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	# Center window on screen (if applicable)
	var screen_size = OS.get_screen_size()
	var window_size = OS.get_window_size()
	OS.set_window_position(0.5 * screen_size - 0.5 * window_size)
	
	# Enable Continue button if save file exists
	if file.file_exists(Save.FILE):
		$Items/Continue.disabled = false
	
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
	elif $Items/Continue.pressed:
		Save.load_game()
	elif $Items/Options.pressed:
		get_tree().change_scene("res://menus/OptionsMenu.tscn")
	elif $Items/Quit.pressed:
		get_tree().quit()
