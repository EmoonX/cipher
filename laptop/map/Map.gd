extends Control

const MapRoom = preload("res://laptop/map/Room.tscn")

# The scaling factor
const SCALE = 8.0

# --------------------------------------------------------------------------- #

func register_room(room, door=null):
	# Get top-down representation of the room by its floor dimensions
	var size = SCALE * room.get_node("Box/Floor_plane").mesh.size
	var scale = room.get_node("Box").scale
	size.x *= scale.x
	size.y *= scale.z
	
	# Add correctly scaled room to the map
	var map_room = MapRoom.instance()
	$Rooms.add_child(map_room)
	map_room.rect_size = size
	map_room.rect_position = Vector2(0, 0) - size/2

func _position_player():
	# Update player position by making whole map re-center on it
	var player = $"/root/Game/Player"
	var pos = SCALE * Vector2(player.translation.x, player.translation.z)
	$Rooms.rect_position = get_viewport_rect().size/2 + pos
	
	# Rotate player accordingly
	var rot = 180.0 - player.rotation_degrees.y
	$Player.rect_rotation = rot
	print(rot)

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
	
	_position_player()
