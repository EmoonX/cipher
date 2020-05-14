extends "res://objects/Interactable.gd"
class_name Draggable

# Virtual object translation (for snapping)
onready var virtual_pos = translation

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

	# Calculate real offset based on camera view
	var real_offset = \
			Vector3(mouse_offset.x / 3000, 0.0, mouse_offset.y / 1500)
	
	# Move (or try to) kinematic body
	var virtual_offset = virtual_pos - translation
	$KinematicBody.translation = real_offset + virtual_offset
	var collision = $KinematicBody.move_and_collide(Vector3(0, 0, 0))
	if collision:
		# In case of collision detected, check if is indeed horizontal
		var normal = collision.normal
		if abs(normal.y) < 0.9:
			$KinematicBody.translation = Vector3(0, 0, 0)
			return
	
	# If everything's okay, move object together
	virtual_pos += ($KinematicBody.translation - virtual_offset)
	$KinematicBody.translation = Vector3(0, 0, 0)
	var snap = puzzle.check_and_snap(self)
	if not snap:
		translation = virtual_pos
	print(virtual_pos)

func _process(_delta):
	if Input.is_action_just_released("left_click"):
		stop_drag()
