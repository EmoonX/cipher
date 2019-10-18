extends KinematicBody

onready var camera = $Rotation_Helper/Camera    
onready var rotation_helper = $Rotation_Helper

const MAX_SPEED = 40
const ACCEL = 4.5
const DEACCEL = 16
const MOUSE_SENSITIVITY = 0.20

var inventory = []

var vel = Vector3()
var dir = Vector3()

# --------------------------------------------------------------------------- #

func _ready():
	# Hide mouse and avoid it leaving screen
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta):
	process_input(delta)
	process_movement(delta)
	print(inventory)

func process_input(delta):
	# Get movement vector
	var input_movement_vector = Vector3()
	if Input.is_action_pressed("movement_forward"):
		input_movement_vector.z += 1
	if Input.is_action_pressed("movement_backward"):
		input_movement_vector.z -= 1
	if Input.is_action_pressed("movement_left"):
		input_movement_vector.x -= 1
	if Input.is_action_pressed("movement_right"):
		input_movement_vector.x += 1
	
	# Normalize it (that is, resulting norm will be 1)
	input_movement_vector = input_movement_vector.normalized()
	
	# Get direction vector relative to camera positioning
	var cam_xform = camera.get_global_transform()
	dir = Vector3()
	dir += cam_xform.basis.x * input_movement_vector.x
	dir += -cam_xform.basis.z * input_movement_vector.z
	
	# Toogle flashlight
	if Input.is_action_just_pressed("flashlight"):
		$Rotation_Helper/FlashLight.visible = \
			not $Rotation_Helper/FlashLight.visible
	
	# ESC quits game
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()

func process_movement(delta):
	# Horizontal velocity isn't affected by vertical direction
	dir.y = 0
	dir = dir.normalized()
	dir *= MAX_SPEED
	
	# Check if we should accel or not based on relative position of movements
	var accel = ACCEL if dir.dot(vel) > 0 else DEACCEL

	# Produce resulting velocity by applying accel and (possibly) wall slide
	vel = vel.linear_interpolate(dir, accel * delta)
	vel = move_and_slide(vel, Vector3(0, 1, 0))

func _input(event):
	# If mouse is moved...
	if event is InputEventMouseMotion:
		# Rotate player camera
		rotation_helper.rotate_x(deg2rad(event.relative.y * MOUSE_SENSITIVITY))
		rotate_y(deg2rad(event.relative.x * MOUSE_SENSITIVITY * -1))
		
		# Avoid too inclined vertical rotation
		var camera_rot = rotation_helper.rotation_degrees
		camera_rot.x = clamp(camera_rot.x, -70, 70)
		rotation_helper.rotation_degrees = camera_rot