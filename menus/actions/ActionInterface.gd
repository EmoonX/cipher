extends VBoxContainer

const Item = preload("res://menus/actions/Item.tscn")

# Initial position x of container
onready var x_ini = rect_position.x

# --------------------------------------------------------------------------- #

func _ready():
	# Build list of actions
	for action in $"..".actions:
		var item = Item.instance()
		item.name = $"..".ActionType.keys()[action]
		item.name = item.name.capitalize().replace(" ", "")
		$Actions.add_child(item)
		
	set_process_input(false)
	
	# Attribute focus neighbours
#	var k = $Actions.get_child_count()
#	for idx in range(k):
#		var item = $Actions.get_child(idx)
#		if idx > 0:
#			var prev = $Actions.get_child(idx - 1)
#			item.focus_neighbour_bottom = item.get_path_to(prev)
#		if idx < k-1:
#			var next = $Actions.get_child(idx + 1)
#			item.focus_neighbour_top = item.get_path_to(next)

func _on_ActionInterface_visibility_changed():
	show_actions()

func show_actions():
	# Play animations to make interface appear in view
	if visible:
		for item in $Actions.get_children():
			var player = item.get_node("AnimationPlayer")
			var reverse_playback = $AnimationPlayer.is_playing() and \
					$AnimationPlayer.get_playing_speed() < 0.0
			if reverse_playback or not visible:
				# Hiding animation already started 
				# (or even finished), so we stop immediately
				break
			player.play("show")
			yield(get_tree().create_timer(0.15), "timeout")
	
	set_process_input(true)

func hide_actions():
	# Play hiding animations before turning interface invisible
	var items = $Actions.get_children()
	for item in items:
		if item.modulate.a == 0.0:
			# Item hasn't even appeared, so avoid playing animation
			break
		var player = item.get_node("AnimationPlayer")
		player.play_backwards("show")
	$AnimationPlayer.play_backwards("show")
	yield($AnimationPlayer, "animation_finished")
	visible = false
	
	set_process_input(false)

func _input(event):
	# Allow scroll wheel down/up to be used for changing between items
	if event is InputEventMouseButton and event.pressed:
		var k = $Actions.get_child_count()
		var idx
		for i in range(k):
			var item = $Actions.get_child(i)
			if item.has_focus():
				idx = i
				break
		var item
		match event.button_index:
			BUTTON_WHEEL_UP:
				idx -= 1
			BUTTON_WHEEL_DOWN:
				idx += 1
		if idx >= 0 and idx < k:
			item = $Actions.get_child(idx)
			item.grab_focus()

func _process(delta):
	# Position node correctly on screen
	var offset = OS.window_size.x - OS.window_size.y * 16.0/9.0
	offset = max(0, offset)
	rect_position.x = x_ini + (offset * (1080 / OS.window_size.y) / 2)
