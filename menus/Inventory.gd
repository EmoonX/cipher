extends Control

# List of picked up items names
var picked_items = []

# List of references to inventory items
var inventory = []

# --------------------------------------------------------------------------- #

func add(item):
	item.translation = Vector3(0, 0, 0)
	item.scale = Vector3(1, 1, 1)
	picked_items.append(item.name)
	inventory.append(item)

func remove(item):
	inventory.erase(item)
	
func was_picked_up(item):
	return item.name in picked_items
	
func _build_list():
	$ItemList.clear()
	inventory.sort()
	for item in inventory:
		var pretty_name = TranslationServer.translate(item.pretty_name)
		$ItemList.add_item(pretty_name)
	
	$ItemList.select(0)

func _show(idx):
	$Details/Description.text = inventory[idx].description
	$Viewport/Item.remove_child(get_child(0))
	$Viewport/Item.add_child(inventory[idx])
	$Viewport/AnimationPlayer.current_animation = "rotate"
	$Viewport/AnimationPlayer.play()

func save():
	# Get string names of inventory items
	var inventory_names = []
	for item in inventory:
		inventory_names.append(item.name)
	
	var save_dict = {
		"picked_items": var2str(picked_items),
		"inventory": var2str(inventory_names)
	}
	return save_dict

func _process(delta):
	if not visible and Input.is_action_just_pressed("inventory") and \
			not get_tree().paused:
		visible = true
		$"/root/Game".pause_toggle()
		_build_list()
		if inventory:
			_show(0)
	elif visible:
		if Input.is_action_just_pressed("ui_cancel") or \
				Input.is_action_just_pressed("inventory"):
			Input.action_release("ui_cancel")
			Input.action_release("ui_inventory")
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
