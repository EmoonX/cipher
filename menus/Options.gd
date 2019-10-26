extends Control

onready var mode = $ScreenMode/OptionButton
onready var res = $Resolution/OptionButton

# --------------------------------------------------------------------------- #

func _ready():	
	$Language/OptionButton.grab_focus()

func _process(delta):
	# Enable changing OptionButtons content with <- and -> keys
	var change = false
	for node in get_children():
		if node.name == "Back":
			continue
		var button = node.get_node("OptionButton")
		if button.has_focus():
			if Input.is_action_just_pressed("ui_left"):
				if button.selected > 0:
					button.selected -= 1
				change = true
			elif Input.is_action_just_pressed("ui_right"):
				if button.selected < button.get_item_count() - 1:
					button.selected += 1
				change = true
	
	# It's important to don't change important options every frame!
	if change:
		# Screen mode
		match mode.get_item_text(mode.selected):
			"Window":
				OS.window_fullscreen = false
				OS.window_borderless = false
			"Borderless Window":
				OS.window_fullscreen = false
				OS.window_borderless = true
			"Borderless Fullscreen":
				OS.window_fullscreen = true
		
		# Screen resolution
		var aux = res.get_item_text(res.selected).split("x")
		OS.window_size = Vector2(int(aux[0]), int(aux[1]))
	
	if $Back.pressed:
		get_tree().change_scene("res://menus/MainMenu.tscn")
