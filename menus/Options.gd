extends Control

onready var mode = $ScreenMode/OptionButton
onready var res = $Resolution/OptionButton

# --------------------------------------------------------------------------- #

func _ready():
	# Get options from config file and set them on the respective buttons
	for option in Config.file.get_section_keys("base"):
		var item = option.replace("_", " ").capitalize().replace(" ", "")
		var value = Config.file.get_value("base", option)
		var button = get_node(item + "/OptionButton")
		for id in range(button.get_item_count()):
			if button.get_item_text(id) == value:
				button.selected = id
	
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
		# Update config *in memory*
		for node in get_children():
			if node.name == "Apply":
				continue
			var item = node.get_node("Label").text.to_lower().replace(" ", "_")
			var button = node.get_node("OptionButton")
			var value = button.get_item_text(button.selected)
			Config.file.set_value("base", item, value)
		
		Config.set_options()
	
	if $Apply.pressed:
		# Save pending changes to file
		Config.file.save(Config.FILE)
		
		get_tree().change_scene("res://menus/MainMenu.tscn")
