extends Control

const MapRoom = preload("res://laptop/map/Room.tscn")

# --------------------------------------------------------------------------- #

func register_room(room, door=null):
	# Get top-down representation of the room by its floor dimensions
	var size = 8 * room.get_node("Box/Floor_plane").mesh.size
	var scale = room.get_node("Box").scale
	size.x *= scale.x
	size.y *= scale.z
	
	# Add correctly scaled room to the map
	var map_room = MapRoom.instance()
	add_child(map_room)
	map_room.rect_size = size

func _process(delta):
	# Enter or exit map
	if not visible and Input.is_action_just_pressed("map") and \
			not get_tree().paused:
		visible = true
		$"..".visible = true
		$"/root/Game".pause_toggle()
	elif visible and Input.is_action_just_pressed("map"):
		visible = false
		$"..".visible = false
		$"/root/Game".pause_toggle()
	Input.action_release("map")
