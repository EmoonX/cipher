extends "res://objects/Interactable.gd"

# Previously registered mouse position on screen
var prev_mouse_pos

# --------------------------------------------------------------------------- #

func _ready():
	# Don't run nothing specific until dragging
	_stop_drag()

func _start_drag():
	set_physics_process(true)
	prev_mouse_pos = get_viewport().get_mouse_position()

func _stop_drag():
	set_physics_process(false)
		
func _physics_process(delta):
	# Calculate offset based on mouse position difference
	var mouse_pos = get_viewport().get_mouse_position()
	var mouse_offset = mouse_pos - prev_mouse_pos
	prev_mouse_pos = mouse_pos

	# Calculate real offset on surface
	var real_offset = \
			Vector3(mouse_offset.x / 2000, 0.0, mouse_offset.y / 1500)
	
	# Move (or try to) kinematic body
	var prev_pos = $KinematicBody.translation
	$KinematicBody.translation += real_offset
	var collision = $KinematicBody.move_and_collide(Vector3(0, 0, 0))
	if collision:
		# In case of collision detected, check if is indeed horizontal
		var normal = collision.normal
		print(normal)
		if abs(normal.y) < 0.9:
			$KinematicBody.translation = prev_pos
			return
	
	# If everything's okay, move meshes together
	$Meshes.transform = $KinematicBody.transform
