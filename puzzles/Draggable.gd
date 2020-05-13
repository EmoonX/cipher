extends "res://objects/Interactable.gd"
class_name Draggable

# Previously registered mouse position on screen
var prev_mouse_pos

# --------------------------------------------------------------------------- #

func _ready():
	# Don't run nothing specific until dragging
	stop_drag()

func start_drag():
	set_physics_process(true)
	prev_mouse_pos = get_viewport().get_mouse_position()

func stop_drag():
	set_physics_process(false)

func _physics_process(_delta):
	# Calculate offset based on mouse position difference
	var mouse_pos = get_viewport().get_mouse_position()
	var mouse_offset = mouse_pos - prev_mouse_pos
	prev_mouse_pos = mouse_pos
	
	if mouse_offset == Vector2(0, 0):
		puzzle.snap_to_led()
		return

	# Calculate real offset based on camera view
	var real_offset = \
			Vector3(mouse_offset.x / 3000, 0.0, mouse_offset.y / 1500)
	
	# Move (or try to) kinematic body
	var prev_pos = $KinematicBody.translation
	var new_pos = prev_pos + real_offset
	$KinematicBody.translation = new_pos
	var collision = $KinematicBody.move_and_collide(Vector3(0, 0, 0))
	if collision:
		# In case of collision detected, check if is indeed horizontal
		var normal = collision.normal
		if abs(normal.y) < 0.9:
			$KinematicBody.translation = prev_pos
			return
	
	# If everything's okay, move object together
	translation += $KinematicBody.translation
	$KinematicBody.translation = Vector3(0, 0, 0)

func _process(_delta):
	if Input.is_action_just_released("left_click"):
		stop_drag()
