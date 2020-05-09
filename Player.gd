extends KinematicBody

const Interactable = preload("res://objects/Interactable.gd")
const PauseMenu = preload("res://menus/Pause.tscn")

const MAX_SPEED = 30.0
const ACCEL = 4.5
const DEACCEL = 16.0
const MOUSE_SENSITIVITY = 0.20

onready var camera = $RotationHelper/Camera    
onready var rotation_helper = $RotationHelper
onready var zoom_player = $RotationHelper/Camera/AnimationPlayer

# Items currently in player's possession
var inventory = []

# Initial position upon entering a room
var translation_ini = Vector3()
var rotation_ini = Vector3()

# Velocity and direction vectors
var vel = Vector3()
var dir = Vector3()

# Length of zoom animation
var zoom_length

var cont = 0.0

# --------------------------------------------------------------------------- #

func _ready():
	# Hide mouse and avoid it leaving screen
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	# Set zoom animation to player and get length of it
	zoom_player.current_animation = "zoom_in"
	zoom_player.stop(false)
	zoom_length = zoom_player.current_animation_length

func _physics_process(delta):
	_process_input(delta)
	_process_movement(delta)
	_process_interaction(delta)

func _input(event):
	# If mouse is moved...
	if event is InputEventMouseMotion:
		# Rotate player camera
		rotation_helper.rotate_x( \
				deg2rad(event.relative.y * MOUSE_SENSITIVITY))
		rotate_y(deg2rad(event.relative.x * MOUSE_SENSITIVITY * -1))
		
		# Avoid too inclined vertical rotation
		var camera_rot = rotation_helper.rotation_degrees
		camera_rot.x = clamp(camera_rot.x, -70, 70)
		rotation_helper.rotation_degrees = camera_rot

func _process_input(delta):
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
	
	# Zoom in/out
	var pos = zoom_player.current_animation_position
	if Input.is_action_pressed("zoom"):
		if pos + delta <= zoom_length:
			zoom_player.advance(delta)
		else:
			zoom_player.seek(zoom_length, true)
	else:
		if pos - 2 * delta >= 0.0:
			zoom_player.advance(-2 * delta)
		else:
			zoom_player.seek(0.0, true)
	
	# Toggle flashlight
	if Input.is_action_just_pressed("flashlight"):
		$RotationHelper/Flashlight.visible = \
			not $RotationHelper/Flashlight.visible
		$RotationHelper/Camera/MotionBlur.visible = false
	
	# Capture screen by camera
	if Input.is_action_just_pressed("camera"):
		# Hide unwanted layers from photo
		$"/root/Game/Subtitles".visible = false
		$"/root/Game/ScreenEffects".visible = false
		yield(get_tree(), "idle_frame")
		yield(get_tree(), "idle_frame")
		
		# Get, crop, resize, adjust and compress image
		var img : Image = get_viewport().get_texture().get_data()
		var ratio = float(img.get_width()) / img.get_height()
		if ratio > 16.0/9.0:
			var h = img.get_height()
			var w = h / 9.0 * 16.0
			var dx = (img.get_width() - w) / 2.0
			var rect = Rect2(dx, 0, w, h)
			img = img.get_rect(rect)
		img.resize(1280, 720)
		img.flip_y()
		img.convert(Image.FORMAT_RGBA4444)
		
		# Save PNG image on camera files
		var filename = str("%04d" % ($"/root/Game".num_pics + 1)) + ".png"
		$"/root/Game".num_pics += 1
		img.save_png("res://user/files/camera/" + filename)
		
		# Unhide what has hidden before
		$"/root/Game/Subtitles".visible = true
		$"/root/Game/ScreenEffects".visible = true
	
	# Brighten interactable objects on key press (focus on all)
	var energy
	if Input.is_action_pressed("focus_all"):
		energy = abs(cont) / 16
		cont -= delta * 2
		if cont < -1.0:
			cont = 1.0
	else:
		energy = 0.0
		cont = 0.0
	for node in $"/root/Game".current.get_children():
		if node is Interactable:
			for mesh in node.get_node("Meshes").get_children():
				continue
				var material = mesh.mesh.get("surface_1/material")
				if not material :
					continue
				material.emission_enabled = true
#				material.emission = ColorN("white")
				material.emission_energy = energy
				mesh.mesh.set("surface_1/material", material)

func _process_movement(delta):
	# Horizontal velocity isn't affected by vertical direction
	dir.y = 0
	dir = dir.normalized()
	dir *= MAX_SPEED
	
	# Check the type of accel based on relative position of movements
	var accel = ACCEL if dir.dot(vel) > 0 else DEACCEL

	# Produce resulting velocity by applying accel and (possibly) wall slide
	vel = vel.linear_interpolate(dir, accel * delta)
	vel = move_and_slide(vel, Vector3(0, 1, 0))

func _process_interaction(_delta):
	var object = $RotationHelper/ActiveRay.get_collider()
	if object:
		object = object.get_parent()
	$"/root/Game".active_object = object

func save():
	var save_dict = {
		"player_translation": var2str(translation_ini),
		"player_rotation": var2str(rotation_ini),
	}
	return save_dict
