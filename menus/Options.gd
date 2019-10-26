extends Control

# --------------------------------------------------------------------------- #

func _ready():	
	$Language/OptionButton.grab_focus()

func _process(delta):
	# Enable changing OptionButtons content with <- and -> keys
	for node in [$Language, $Resolution]:
		var button = node.get_node("OptionButton")
		if button.has_focus():
			if Input.is_action_just_pressed("ui_left"):
				if button.selected > 0:
					button.selected -= 1
			elif Input.is_action_just_pressed("ui_right"):
				if button.selected < button.get_item_count() - 1:
					button.selected += 1
				
	if $Back.pressed:
		get_tree().change_scene("res://menus/MainMenu.tscn")
