extends Control

# Lists of, respectly, picked up and used up items
var items = []
var used = []

# --------------------------------------------------------------------------- #

func add(item):
	items.append(item)
	$ItemList.add_item(item)
	$ItemList.sort_items_by_text()

func remove(item):
	items.erase(item)
	for idx in range($ItemList.get_item_count()):
		if $ItemList.get_item_text(idx) == item:
			$ItemList.remove_item(idx)
			break
	$ItemList.sort_items_by_text()
	used.append(item)

func _process(delta):
	if not visible and Input.is_action_just_pressed("inventory"):
		visible = true
		get_tree().paused = true
	elif visible and Input.is_action_just_pressed("ui_cancel") or \
			Input.is_action_just_pressed("inventory"):
		visible = false
		get_tree().paused = false
