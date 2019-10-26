extends Control

onready var mode = $ScreenMode/OptionButton

# --------------------------------------------------------------------------- #

func _ready():	
	$Language/OptionButton.grab_focus()

func _process(delta):
	# Enable changing OptionButtons content with <- and -> keys
	for node in [$Language, $ScreenMode]:
		var button = node.get_node("OptionButton")
		if button.has_focus():
			if Input.is_action_just_pressed("ui_left"):
				if button.selected > 0:
					button.selected -= 1
			elif Input.is_action_just_pressed("ui_right"):
				if button.selected < button.get_item_count() - 1:
					button.selected += 1
	
	match mode.get_item_text(mode.selected):
		"Window":
			OS.window_fullscreen = false
			OS.window_borderless = false
		"Borderless Window":
			OS.window_fullscreen = false
			OS.window_borderless = true
		"Borderless Fullscreen":
			OS.window_fullscreen = true
	
	if $Back.pressed:
		get_tree().change_scene("res://menus/MainMenu.tscn")
