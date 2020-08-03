extends Control

const MapRoom = preload("res://laptop/map/Room.tscn")
const MapDoor = preload("res://laptop/map/Door.tscn")

# The scaling factor
const SCALE = 8.0

# --------------------------------------------------------------------------- #

func register_room(room, entry_door=""):
	# Get top-down representation of the room by its floor dimensions
	var size = SCALE * room.get_node("Box/Floor_plane").mesh.size
	var scale = room.get_node("Box").scale
	size.x *= scale.x
	size.y *= scale.z
	
	# Find where to put room based on door position
	var room_pos = Vector2(0, 0)
	if entry_door:
		for node in $Rooms.get_children():
			if node.name == entry_door:
				var map_door = node
				var exit_pos = map_door.rect_position
				for node2 in room.get_children():
					if node2.name == entry_door:
						var door = node2
						var entry_pos = SCALE * \
								Vector2(door.translation.x, door.translation.z)
						room_pos = exit_pos + entry_pos
						break
				break
	
	# Add correctly scaled room to the map
	var map_room = MapRoom.instance()
	$Rooms.add_child(map_room)
	map_room.name = room.name
	map_room.rect_size = size
	map_room.rect_position = room_pos - size/2
	
	# Add unmarked doors to map
	for node in room.get_children():
		if not "Door" in node.name or node.name == entry_door:
			continue
		var door = node
		var door_pos = SCALE * Vector2(door.translation.x, door.translation.z)
		var map_door = MapDoor.instance()
		$Rooms.add_child(map_door)
		map_door.name = door.name
		map_door.rect_position = \
				room_pos - door_pos - (map_door.rect_size / 2)
		map_door.rect_rotation = door.rotation_degrees.y
		
		# If it's locked, color it in some different way
		if door.key:
			map_door.color = ColorN("red")
	
	# Duplicate style box to allow individual recoloring
	var panel = map_room.get("custom_styles/panel").duplicate()
	map_room.set("custom_styles/panel", panel)

func highlight(current):
	# Highlight current room on map (and only it)
	for node in $Rooms.get_children():
		if "Door" in node.name:
			continue
		var room = node
		var color
		if room.name == current.name:
			color = Color("af0076ff")
		else:
			color = Color("af003a7d")
		room.get("custom_styles/panel").bg_color = color

func _position_player():
	# Update player position by making whole map re-center on it
	var player = $"/root/Game/Player"
	var pos = SCALE * Vector2(player.translation.x, player.translation.z)
	var room = $Rooms.get_node($"/root/Game".current.name)
	var delta = room.rect_position + room.rect_size/2
	$Rooms.rect_position = get_viewport_rect().size/2 + pos - delta
	
	# Rotate player accordingly
	var rot = 180.0 - player.rotation_degrees.y
	$Player.rect_rotation = rot

func _process(delta):
	# Enter or exit map
	if not visible and Input.is_action_just_pressed("map") and \
			not get_tree().paused:
		visible = true
		$"..".visible = true
#		$"/root/Game".pause_toggle()
	elif visible and Input.is_action_just_pressed("map"):
		visible = false
		$"..".visible = false
#		$"/root/Game".pause_toggle()
	Input.action_release("map")
	
	if visible:
		_position_player()
