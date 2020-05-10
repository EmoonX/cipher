extends Spatial

enum ActionType {
	EXAMINE
	OPEN_DOOR
	TURN_ON
	TURN_OFF
	OPEN
	CLOSE
	PICK_UP
	SCAN
	INVESTIGATE
	DRAG
}

# List of possible actions to be done with the object
export(Array, ActionType) var actions = []

# If the object should have a simpler pretty name before examining it
export(bool) var has_pre_name = false

# If true, then it's only interactable in puzzle mode;
# if false, only in room mode.
export(bool) var is_puzzle_piece = false

# If the object can be investigated, then which node contain its puzzles
export(NodePath) var puzzle_node_path
onready var puzzle = get_node(puzzle_node_path)

# In case of being a switch, which node contain lights to be turned on/off
export(NodePath) var linked_lights

# The currently selected action
var selected_action

var cont = 0.0

onready var probe = $"/root/Game".current.get_node("ReflectionProbe")

# --------------------------------------------------------------------------- #

func _ready():
	# Set object pretty name to label
	var s = "OBJECT_" + name.to_upper()
	if has_pre_name and not name in $"/root/Game".examined_objects:
		s += "_PRE"
	var pretty_name = TranslationServer.translate(s)
	if pretty_name == s:
		# There's no explicit pre-name, so it's just "unknown"
		pretty_name = "????"
	$ActionInterface/Name.text = pretty_name
	
	# Set up emission "glow" features in materials for when active
	for mesh in get_node("Meshes").get_children():
		for idx in mesh.mesh.get_surface_count():
			var material = mesh.mesh.surface_get_material(idx)
			if not material is SpatialMaterial:
				continue
			material.emission_enabled = true
			material.emission = material.albedo_color
			if material.albedo_texture:
				material.emission_operator = \
						SpatialMaterial.EMISSION_OP_MULTIPLY
				material.emission_texture = material.albedo_texture
			mesh.mesh.surface_set_material(idx, material)

func _update_actions(idx, value):
	# Change list of actions by setting index idx to value
	var old_value = actions[idx]
	var old_name = ActionType.keys()[old_value].capitalize().replace(" ", "")
	actions[idx] = value
	
	# Update interface item
	var name = ActionType.keys()[value].capitalize().replace(" ", "")
	var item = $ActionInterface/Actions.get_node(old_name)
	item.name = name
	item.update()
	
	# TODO: Refresh the interface
	#$ActionInterface

func _update_probe():
	# Update ReflectionProbe when lighting changes
	probe.update_mode = ReflectionProbe.UPDATE_ONCE

func _on_AnimationPlayer_animation_finished(_anim_name):
	_update_probe()

func _process(delta):
	var energy
	if self == $"/root/Game".active_object:
		if not $ActionInterface.visible:
			# Start animations playback one frame before
			# turning interface visible (so to not render garbage)
			$ActionInterface/AnimationPlayer.play("show")
			yield(get_tree(), "idle_frame")
		$ActionInterface.visible = true
		
		# Calculate energy amount
		energy = abs(cont) / 2
		cont -= delta * 2
		if cont < -1.0:
			cont = 1.0
		
		if Input.is_action_just_pressed("ui_accept") or \
				Input.is_action_just_pressed("action"):
			match selected_action:
				ActionType.EXAMINE:
					# Examine (get player's flavored info from) the object
					var examine_text = "OBJECT_" + name.to_upper() + "_EXAMINE"
					$"/root/Game".display_subtitles(examine_text)
					
					# Upon first examination and if it has a pre-name,
					# register it and change pretty name
					if has_pre_name and \
							not self in $"/root/Game".examined_objects:
						$"/root/Game".examined_objects[name] = true
						var s = "OBJECT_" + name.to_upper()
						var pretty_name = TranslationServer.translate(s)
						$ActionInterface/Name.text = pretty_name
						
						# Do animation to transit to new name / commands
						$ActionInterface/AnimationPlayer.play_backwards("show")
						yield($ActionInterface/AnimationPlayer, \
							"animation_finished")
						$ActionInterface/AnimationPlayer.play("show")
					
				ActionType.OPEN:
					# Open a curtain, closet, etc
					$AnimationPlayer.current_animation = "open"
					$AnimationPlayer.play()
					_update_actions(0, ActionType.CLOSE)
					
				ActionType.CLOSE:
					# Close a curtain, closet, etc
					$AnimationPlayer.current_animation = "close"
					$AnimationPlayer.play()
					_update_actions(0, ActionType.OPEN)
					
				ActionType.TURN_ON, ActionType.TURN_OFF:
					# Turn on or off a light source
					var lights = get_node(linked_lights)
					lights.visible = not lights.visible
					if actions[0] == ActionType.TURN_ON:
						_update_actions(0, ActionType.TURN_OFF)
					else:
						_update_actions(0, ActionType.TURN_ON)
					_update_probe()
				
				ActionType.INVESTIGATE:
					# Switch to puzzle mode
					puzzle.visible = true
					
				ActionType.DRAG:
					call("_start_drag")
	
	else:
		if $ActionInterface.visible and \
				not $ActionInterface/AnimationPlayer.is_playing():
			$ActionInterface.hide_actions()
		energy = 0.0
		cont = 0
	
	# Brigthen up object while examining
	for mesh in get_node("Meshes").get_children():
		for idx in mesh.mesh.get_surface_count():
			var material = mesh.mesh.surface_get_material(idx)
			if not material is SpatialMaterial:
				continue
			material.emission_energy = energy
			mesh.mesh.surface_set_material(idx, material)
