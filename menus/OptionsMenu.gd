extends Control

onready var mode = $Items/ScreenMode/OptionButton
onready var res = $Items/Resolution/OptionButton

# --------------------------------------------------------------------------- #

func _ready():
	# Get options from config file and set them on the respective buttons
	for option in Config.file.get_section_keys("base"):
		var item = option.replace("_", " ").capitalize().replace(" ", "")
		var value = Config.file.get_value("base", option)
		for node in $Items.get_children():
			if node.has_node("Label") and \
					node.get_node("Label").text == option.to_upper():
				var button = node.get_node("OptionButton")
				for id in range(button.get_item_count()):
					if button.get_item_text(id) == value:
						button.selected = id
				break
				
	# Erase all data option should be grayed out ingame
	if has_node("/root/Game"):
		$Items/EraseAllData.disabled = true
	
	$Items/Language/OptionButton.grab_focus()

func _process(delta):
	# Enable changing OptionButtons content with <- and -> keys
	var change = false
	for node in $Items.get_children():
		if node.get_child_count() == 0:
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
		for node in $Items.get_children():
			if node.get_child_count() == 0:
				continue
			var item = node.get_node("Label").text.to_lower().replace(" ", "_")
			var button = node.get_node("OptionButton")
			var value = button.get_item_text(button.selected)
			Config.file.set_value("base", item, value)
		
		Config.set_options()
	
	if $Items/EraseAllData.pressed:
		# TODO: add some VERY NEEDED confirmation beforehand
		
		# Erase all save, config and user data files
		var dir = Directory.new()
		dir.change_dir("res://user/")
		dir.list_dir_begin(true)
		while true:
			var filename = dir.get_next()
			if not filename:
				break
			if not dir.current_is_dir():
				dir.remove(filename)
		
		# Quit game so we can start all over
		get_tree().quit()
	
	elif $Items/Apply.pressed:
		# Save pending changes to file
		Config.file.save(Config.FILE)
		
		# Different procedures in-game and in main menu
		if has_node("/root/Game"):
			Input.action_release("ui_accept")
			var pause_menu = $"/root/Game/Interfaces/PauseMenu"
			pause_menu.pause_mode = PAUSE_MODE_PROCESS
			pause_menu.get_node("Items/Options").grab_focus()
			queue_free()
		else:
			get_tree().change_scene("res://menus/MainMenu.tscn")
