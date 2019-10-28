extends Control

# Lists of, respectly, picked up and used up items
var items = []
var used = []

# --------------------------------------------------------------------------- #

func add(item):
	item.translation = Vector3(0, 0, 0)
	item.scale = Vector3(1, 1, 1)
	items.append(item)

func remove(item):
	items.erase(item)
	used.append(item)
	
func was_picked_up(item):
	for x in items:
		if item.name == x.name:
			return true
	for y in used:
		if item.name == y.name:
			return true
	return false
	
func _build_list():
	$ItemList.clear()
	items.sort()
	for item in items:
		var pretty_name = TranslationServer.translate(item.pretty_name)
		$ItemList.add_item(pretty_name)
	
	$ItemList.select(0)

func _show(idx):
	$Details/Description.text = items[idx].description
	$Viewport/Item.remove_child(get_child(0))
	$Viewport/Item.add_child(items[idx])
	$Viewport/AnimationPlayer.current_animation = "rotate"
	$Viewport/AnimationPlayer.play()

func _process(delta):
	if not visible and Input.is_action_just_pressed("inventory"):
		visible = true
		$"/root/Game".pause_toggle()
		_build_list()
		if items:
			_show(0)
	elif visible:
		if Input.is_action_just_pressed("ui_cancel") or \
				Input.is_action_just_pressed("inventory"):
			visible = false
			$"/root/Game".pause_toggle()
		elif $ItemList.get_item_count() > 0:
			# Enable scrolling through items with \/ and /\ keys
			var idx = $ItemList.get_selected_items()[0]
			if Input.is_action_just_pressed("ui_down") and idx > 0:
				$ItemList.select(idx - 1)
				_show(idx)
			elif Input.is_action_just_pressed("ui_up") and \
					idx < $ItemList.get_item_count() - 1:
				$ItemList.select(idx + 1)
				_show(idx)
