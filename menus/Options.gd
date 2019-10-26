extends Control

onready var mode = $ScreenMode/OptionButton
onready var res = $Resolution/OptionButton

# Configuration file
var config

# --------------------------------------------------------------------------- #

func _ready():
	# Load config file for read and (truncated) writing operations
	config = File.new()
	config.open("player.cfg", File.READ)
	
	# Get options per config file and set the respective buttons
	while true:
		var aux = config.get_line()
		if not aux:
			break
		aux = aux.split("=")
		var item = aux[0]
		var value = aux[1]
		var button = get_node(item.replace(" ", "") + "/OptionButton")
		for id in range(button.get_item_count()):
			if button.get_item_text(id) == value:
				button.selected = id
				break
	
	$Language/OptionButton.grab_focus()

func _process(delta):
	# Enable changing OptionButtons content with <- and -> keys
	var change = false
	for node in get_children():
		if node.name == "Apply":
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
	
	# It's necessary to not change important options every frame!
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
		var text = res.get_item_text(res.selected)
		if text == "Screen Adapt":
			OS.window_size = OS.get_screen_size()
		else:
			var aux = text.split("x")
			OS.window_size = Vector2(int(aux[0]), int(aux[1]))
	
	if $Apply.pressed:
		# Write new config file
		config.open("player.cfg", File.WRITE)
		for node in get_children():
			if node.name == "Apply":
				continue
			var item = node.name
			var button = node.get_node("OptionButton")
			var value = button.get_item_text(button.selected)
			var s = item + "=" + value + "\n"
			config.store_string(s)
			
		config.close()
		get_tree().change_scene("res://menus/MainMenu.tscn")
