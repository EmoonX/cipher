extends Spatial

onready var initial_pos = $Camera.translation
onready var initial_fov = $Camera.fov

# Position of the mouse on the viewport
var mouse_pos = Vector2(0, 0)

# --------------------------------------------------------------------------- #

func _ready():
	set_process(false)
	set_process_input(false)

func _on_Puzzle_visibility_changed():
	if visible:
		$"/root/Game/Speech".pause_mode = PAUSE_MODE_PROCESS
		$"/root/Game".active_object = null
		_transition_camera(true)
	else:
		$"/root/Game/Speech".pause_mode = PAUSE_MODE_STOP
		$"/root/Game/Player/RotationHelper/Camera".current = true
		$Camera.translation = initial_pos
		$Camera.fov = initial_fov
	
	get_tree().paused = visible

func _transition_camera(is_direct):
	# Transition smoothly between player and puzzle cameras
	var player_camera = $"/root/Game/Player/RotationHelper/Camera"
	var pos_ini = player_camera.global_transform
	var pos_end = $Camera.global_transform
	var fov_ini = player_camera.fov
	var fov_end = $Camera.fov
	var blur_ini = 0
	var blur_end = 2.5
	if not is_direct:
		var aux = pos_ini
		pos_ini = pos_end
		pos_end = aux
		aux = fov_ini
		fov_ini = fov_end
		fov_end = aux
		aux = blur_ini
		blur_ini = blur_end
		blur_end = aux
	var duration = 2.0
	var trans_type = Tween.TRANS_EXPO
	var ease_type = Tween.EASE_IN_OUT
	print(fov_ini, " ", fov_end)
	$Tween.reset_all()
	$Tween.interpolate_property($Camera, \
			"global_transform", pos_ini, pos_end, \
			duration, trans_type, ease_type)
	$Tween.interpolate_property($Camera, \
			"fov", fov_ini, fov_end, \
			duration, trans_type, ease_type)
	$Tween.interpolate_property($BlurPlane.get("material/0"), \
			"shader_param/amount", blur_ini, blur_end, \
			duration, trans_type, ease_type)
	$Tween.start()
	yield(get_tree(), "idle_frame")
	if is_direct:
		$Camera.current = true

func _on_Tween_tween_completed(_object, _key):
	var in_puzzle_mode = ($Camera.fov < 50)
	var mouse_mode = Input.MOUSE_MODE_VISIBLE if in_puzzle_mode \
			else Input.MOUSE_MODE_CAPTURED
	Input.set_mouse_mode(mouse_mode)
	set_process_input(in_puzzle_mode)
	set_process(in_puzzle_mode)
	visible = in_puzzle_mode

func _input(event):
	# Make camera lightly follow mouse movement on screen
	if event is InputEventMouseMotion:
		# Calculate mouse offset based on its position relative to center
		mouse_pos = get_viewport().get_mouse_position()
		var mouse_offset = mouse_pos - (OS.window_size / 2)
		
		# Calculate new adjusted camera translation
		var x_new = initial_pos.x + (mouse_offset.x / 15000)
		var y_new = initial_pos.y - (mouse_offset.y / 15000)
		var pos_new = Vector3(x_new, y_new, $Camera.translation.z)
		
		# Make smooth "delayed" interpolation to next position
		$Tween.interpolate_property($Camera, "translation", \
				null, pos_new, 1.5, Tween.TRANS_EXPO, Tween.EASE_OUT)
		$Tween.start()

func _process(_delta):
	if Input.is_action_just_pressed("go_back"):
		_transition_camera(false)
		return
	
	# Cast ActionRay correctly to mouse position
	var action_ray = $Camera/ActionRay
	var to = $Camera.project_local_ray_normal(mouse_pos)
	action_ray.cast_to = to * 100
	
	# Detect highlighted object (or none) by ray collision
	var object = action_ray.get_collider()
	if object:
		object = object.get_parent()
		if object is Interactable and \
				object.is_puzzle_piece and object.puzzle == self:
			$"/root/Game".active_object = object
			return
	$"/root/Game".active_object = null
