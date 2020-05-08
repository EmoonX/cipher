extends Node

const default_cursor = preload("res://assets/cursor-default.png")

# --------------------------------------------------------------------------- #

func _process(delta):
	# Get screen aspect ratio
	var ratio = OS.window_size.x / OS.window_size.y
	ratio = max(16.0/9.0, ratio)

	for node in get_tree().get_nodes_in_group("center_on_screen"):
		# Center node on screen
		var offset = OS.window_size.x - OS.window_size.y * 16.0/9.0
		offset = max(0, offset)
		node.rect_position.x = offset * (1080 / OS.window_size.y) / 2
		
	for node in get_tree().get_nodes_in_group("expand_to_screen"):
		# Expand node to fill entire screen
		node.rect_size.x = 1080 * ratio
		
	for node in get_tree().get_nodes_in_group("center_on_parent"):
		# Center control on parent node
		var x_mid = node.get_parent().rect_size.x / 2
		var x = x_mid - node.rect_size.x / 2
		node.rect_position.x = x
