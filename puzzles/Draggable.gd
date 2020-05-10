extends "res://objects/Interactable.gd"

# --------------------------------------------------------------------------- #

func _ready():
	# Don't run nothing specific until dragging
	_stop_drag()

func _start_drag():
	set_process_input(true)
	set_physics_process(true)

func _stop_drag():
	set_process_input(false)
	set_physics_process(false)

func _input(event):
	if event is InputEventMouseMotion:
		pass
		
	elif event is InputEventMouseButton:
		_stop_drag()
		
func _physics_process(delta):
	$KinematicBody.move_and_slide(Vector3(1, 0, 0))
	$Meshes.transform = $KinematicBody.transform
