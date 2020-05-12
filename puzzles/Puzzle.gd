extends Spatial

onready var initial_pos = $Camera.translation

# Position of the mouse on the viewport
var mouse_pos = Vector2(0, 0)

# --------------------------------------------------------------------------- #

func _ready():
	set_process(false)
	set_process_input(false)

func _on_Puzzle_visibility_changed():
	if visible:
		$"/root/Game/Speech".pause_mode = PAUSE_MODE_PROCESS
		get_tree().paused = true
		$"/root/Game".active_object = null
		
		# Transition smoothly between player camera and puzzle camera
		var player_camera = $"/root/Game/Player/RotationHelper/Camera"
		var pos_ini = player_camera.global_transform
		var pos_end = $Camera.global_transform
		$Tween.interpolate_property($Camera, \
				"global_transform", pos_ini, pos_end, 2.0)
		$Tween.interpolate_property($Camera, \
				"fov", player_camera.fov, $Camera.fov, 2.0)
		$Tween.interpolate_property($BlurPlane.get("material/0"), \
				"shader_param/amount", 0, 2.5, 2.0)
		$Tween.start()
		yield(get_tree(), "idle_frame")
		$Camera.current = true
	
	else:
		$"/root/Game/Speech".pause_mode = PAUSE_MODE_STOP
	
	$"/root/Game/Player".visible = not visible

func _on_Tween_tween_completed(object, key):
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	set_process(visible)
	set_process_input(visible)
	

func _input(event):
	# Make camera lightly follow mouse movement on screen
	if event is InputEventMouseMotion:
		# Calculate mouse offset based on its position relative to center
		mouse_pos = get_viewport().get_mouse_position()
		var mouse_offset = mouse_pos - (OS.window_size / 2)
		
		# Calculate new adjusted camera translation
		var x_new = initial_pos.x + (mouse_offset.x / 20000)
		var y_new = initial_pos.y - (mouse_offset.y / 10000)
		var pos_new = Vector3(x_new, y_new, $Camera.translation.z)
		
		# Make smooth "delayed" interpolation to next position
		$Tween.interpolate_property($Camera, "translation", \
				null, pos_new, 1.5, Tween.TRANS_EXPO, Tween.EASE_OUT)
		$Tween.start()

func _process(_delta):
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
